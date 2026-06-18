# Navidrome Recommendation P1 Design

## 一、背景

P0 已完成 MeloTrip 推荐能力基线：
- Similar Songs / Similar Radio / Sonic Path：基于 AudioMuse-AI Sonic Similarity API
- For You：使用收藏歌曲作为 seeds，调用 `getSonicSimilarTracks.view` 聚合推荐
- Similar Artists：使用 `getArtistInfo2`

P1 目标是设计更强的"用户品味 seed 聚合层"，让 For You 不只基于收藏歌曲，还可以基于更多用户信号。

**严格边界**：
1. 不修改数据库 schema
2. 不新增 DDL / migration / SQLite version
3. 不恢复 `server_capability`
4. 不做 capability 检测
5. 不 fallback 到 `getSimilarSongs2`
6. 不直接调用 AudioMuse-AI Web UI/API
7. 不调用 `/api/sonic_fingerprint/generate`
8. 未实现的 P1-B/P1-C 能力不得描述成已实现；P1-A 已实现状态以第七章为准
9. 不引入需要后端 AudioMuse-AI 直连的方案作为默认路线

---

## 二、当前 P0 基线

### 2.1 已实现能力

| 能力 | Seed 来源 | API | Provider |
|------|-----------|-----|----------|
| For You | 收藏歌曲 | `getStarred` + `getSonicSimilarTracks.view` | `forYouRecommendationsProvider` |
| Similar Songs | 单首歌曲 | `getSonicSimilarTracks.view` | `similarSongsProvider` |
| Similar Radio | 单首歌曲 | `getSonicSimilarTracks.view` | `radioQueueProvider` |
| Sonic Path | 两首歌曲 | `findSonicPath.view` | `sonicPathProvider` |
| Similar Artists | 艺术家 ID | `getArtistInfo2` | `similarArtistsProvider` |

### 2.2 P0 Seed 聚合架构

```
favoriteProvider
    ↓
favoriteRecommendationSeedsProvider (提取 songId，max 5)
    ↓
forYouRecommendationsProvider
    ↓
recommendationsProvider (调用 Sonic Similarity，去重，多样性限制)
```

**关键代码位置**：
- `lib/provider/recommendation/favorite_recommendation_seeds.dart`：从收藏提取 seed songId
- `lib/provider/recommendation/for_you_recommendations.dart`：For You 入口
- `lib/provider/sonic_similarity/sonic_similarity.dart`：`Recommendations` provider 聚合逻辑

### 2.3 P0 `Recommendations` Provider 能力

`recommendationsProvider(limit, seedSongIds)` 已实现：
- 接收 `List<String> seedSongIds`
- 对每个 seed 调用 `getSonicSimilarTracks.view`
- 去重（跳过已见 songId、跳过 seed 自身）
- 多样性限制（每 artist 最多 3 首、每 album 最多 3 首）
- 随机打乱 seed 顺序增加多样性
- 最多使用 5 个 seed

**结论**：P1 应复用 `recommendationsProvider`，只需设计新的 seed 聚合 provider。

---

## 三、可用用户信号审计

### 3.1 收藏歌曲 (Favorites)

| 项目 | 结论 |
|------|------|
| **状态** | ✅ 已可用，P0 已使用 |
| **Repository** | `lib/repository/favorite/favorite_repository.dart` |
| **API** | `/rest/getStarred` |
| **Provider** | `favoriteProvider` → `favoriteRecommendationSeedsProvider` |
| **数据结构** | `StarredEntity { song, album, artist }`，song 有 `id` (songId) |
| **P0 用法** | 提取 `song.id`，最多 5 个，去重 |
| **P1 可用性** | ✅ 无需修改，直接复用 |

### 3.2 最近播放专辑 (Recent Albums)

| 项目 | 结论 |
|------|------|
| **状态** | ⚠️ 部分可用，仅 album 级别 |
| **Repository** | `lib/repository/album/album_repository.dart` |
| **API** | `/rest/getAlbumList?type=recent` |
| **Provider** | `albumListProvider(AlbumListQuery(type: 'recent'))` |
| **数据结构** | `AlbumEntity`，有 `id` (albumId)、`songCount`，但无 songId 列表 |
| **问题** | 返回的是 albumId，不是 songId。要拿 songId 需要额外调用 `getAlbum` |
| **P1 可用性** | ⚠️ 需要额外 API 调用成本，或暂缓 |

**替代方案**：
- 方案 A：暂缓 recent songs，P1-A 只做 favorite seeds 基础设施
- 方案 B：从 recent albums 中取 N 张专辑，每张调用 `getAlbum` 获取歌曲，从中抽取 seed
- 方案 C：使用本地 `play_history` 表（见 3.3）

### 3.3 本地播放历史 (Play History)

| 项目 | 结论 |
|------|------|
| **状态** | ⚠️ 表已存在，但无 DAO/Provider |
| **Model** | `lib/model/auth_user/play_history.dart` |
| **表结构** | `play_history(song_id, play_count, last_played, is_completed, is_skipped, username)` |
| **SQLite 文件** | `lib/persistence/app_persistence_sqlite.dart:11-20` |
| **问题** | `AppPersistence` 接口未暴露 play_history 读写方法 |
| **风险** | 修改 `AppPersistence` 接口属于 breaking change，需要审计所有实现 |

**表结构详情**：
```sql
CREATE TABLE play_history (
  song_id TEXT NOT NULL,
  play_count INTEGER NOT NULL DEFAULT 0,
  last_played INTEGER NOT NULL,
  is_completed TEXT NOT NULL DEFAULT 0,
  is_skipped TEXT NOT NULL DEFAULT 0,
  username TEXT NOT NULL,
  PRIMARY KEY (song_id, username)
)
```

**字段说明**：
- `song_id`：歌曲 ID ✅ 可直接作为 seed
- `play_count`：播放次数，可用于权重
- `last_played`：最近播放时间戳，可用于时间衰减
- `is_completed` / `is_skipped`：完成/跳过标记，可用于过滤

**P1 可用性**：
- ⚠️ 需要新增 DAO 方法到 `AppPersistence` 接口
- ⚠️ 需要新增 provider
- ⚠️ 需要确认表中是否有实际数据（当前 scrobble runtime 不写此表）

### 3.4 Scrobble

| 项目 | 结论 |
|------|------|
| **状态** | ✅ 已实现，但仅发送到服务器 |
| **Repository** | `lib/repository/scrobble/player_scrobble_repository.dart` |
| **API** | `/rest/scrobble` (submission=true/false) |
| **Runtime** | `lib/app_logic/runtime/player_scrobble_runtime.dart` |
| **触发条件** | 播放 ≥30s 且 ≥90% 时长时提交 scrobble |
| **本地落库** | ❌ 不落库到 `play_history` 表 |

**Scrobble Runtime 行为**：
- 监听 `playQueueStream` + `playingStream`
- 播放 10s 后发送 "now playing" (submission=false)
- 歌曲切换时，若上一首满足条件则提交 scrobble (submission=true)
- 同时调用 `savePlayQueue` 保存队列到服务器

**P1 可用性**：
- ✅ 可以拦截 scrobble 调用，同时写入本地 `play_history`
- ⚠️ 需要修改 `PlayerScrobbleRuntime`
- ⚠️ 需要扩展 `AppPersistence` 接口

### 3.5 评分 (Rating)

| 项目 | 结论 |
|------|------|
| **状态** | ⚠️ 字段存在，但无批量获取 API |
| **SongEntity** | `int? userRating` (0-5) ✅ |
| **AlbumEntity** | `int? userRating` (0-5) ✅ |
| **setRating API** | `/rest/setRating?id=xxx&rating=N` ✅ |
| **批量获取 API** | ❌ 不存在 `getSongsByRating` 或类似 API |

**可用的评分数据来源**：
1. `getStarred` 返回的 song/album 携带 `userRating` 字段
2. `getAlbumList?type=highest` 返回高评分专辑（Navidrome 支持，但 MeloTrip 未暴露）
3. 逐个调用 `getSong` / `getAlbum` 获取评分（成本过高）

**Navidrome 支持但 MeloTrip 未使用的 API**：
- `getAlbumList?type=highest`：按评分降序返回专辑
- `getAlbumList2`：返回 AlbumID3 格式（含 `userRating`），MeloTrip 只用 `getAlbumList`

**P1 可用性**：
- ⚠️ 可以从 `getStarred` 返回的 song 中过滤 `userRating >= 4` 的歌曲
- ⚠️ 无法获取"高评分但未收藏"的歌曲
- 建议：P1-A 暂缓评分 seeds，P1-B 再考虑

### 3.6 当前播放歌曲 / 播放队列 (Current Playing / Queue)

| 项目 | 结论 |
|------|------|
| **状态** | ✅ 已可用 |
| **Player** | `lib/app_player/player.dart` |
| **State** | `lib/app_player/parts/state.dart` |
| **数据结构** | `PlayQueue { songs: List<SongEntity>, index: int }` |
| **访问方式** | 通过 `appPlayerHandlerProvider.future` 获取 `AppPlayer?`，然后读取 `playQueue` 或监听 `playQueueStream` |

**访问示例**：
```dart
final player = await ref.read(appPlayerHandlerProvider.future);
final queue = player?.playQueue;
if (queue == null || queue.songs.isEmpty) {
  return null;
}
final index = queue.index;
if (index < 0 || index >= queue.songs.length) {
  return null;
}
final currentSong = queue.songs[index];
```

**P1 可用性**：
- ✅ 当前播放歌曲可直接作为 seed
- ✅ 播放队列可抽取多个 seed
- ⚠️ **重要**：应区分场景
  - **首页 For You**：不使用当前播放（用户可能在听特定风格，会影响推荐多样性）
  - **上下文推荐**（相似电台、当前播放上下文推荐）：可以使用当前播放

### 3.7 信号汇总表

| 信号 | Song 级别 | 本地 SQLite | Server API | P0 使用 | P1-A 可行性 | 数据获取成本 |
|------|-----------|-------------|------------|---------|-------------|--------------|
| 收藏歌曲 | ✅ songId | ❌ | `getStarred` | ✅ | ✅ 直接复用 | 低（1 次 API） |
| 最近播放专辑 | ❌ 仅 albumId | ❌ | `getAlbumList?type=recent` | ❌ | ⚠️ 需额外调用 | 中高（1+N 次 API） |
| 本地播放历史 | ✅ songId | ✅ 表存在 | N/A（本地） | ❌ | ⚠️ 需新增 DAO | 低（本地查询） |
| Scrobble | ✅ songId | ❌ | `/rest/scrobble`（仅提交） | ❌ | ⚠️ 需拦截写入本地 | 中 |
| 评分 | ✅ userRating | ❌ | 无批量 API | ❌ | ⚠️ 暂缓 | 高 |
| 当前播放 | ✅ SongEntity | ❌ | N/A（内存） | ❌ | ⚠️ 仅上下文推荐 | 低（内存） |
| 播放队列 | ✅ SongEntity | ❌ | `getPlayQueue` | ❌ | ⚠️ 仅上下文推荐 | 低 |

**Scrobble 说明**：`/rest/scrobble` 仅用于提交播放事件到服务器，不直接返回可用 seeds。P1-B 如需使用 scrobble 作为 seed 来源，需要本地拦截 scrobble 调用并写入 `play_history` 表，或等待服务端提供可读历史接口。

---

## 四、Navidrome/OpenSubsonic API 审计

### 4.1 MeloTrip 已使用的 API

| API | 用途 | 返回 songId |
|-----|------|-------------|
| `/rest/getStarred` | 获取收藏 | ✅ `song[].id` |
| `/rest/getAlbumList` | 专辑列表 | ❌ 仅 albumId |
| `/rest/search3` | 搜索 | ✅ `song[].id` |
| `/rest/scrobble` | 提交播放 | N/A |
| `/rest/savePlayQueue` | 保存队列 | N/A |
| `/rest/getPlayQueue` | 获取队列 | ✅ `entry[].id` |
| `/rest/getSong` | 歌曲详情 | ✅ `id` |
| `/rest/getAlbum` | 专辑详情 | ✅ `song[].id` |
| `/rest/setRating` | 设置评分 | N/A |

### 4.2 Navidrome 支持但 MeloTrip 未使用的 API

| API | 用途 | 返回 songId | P1 潜在用途 |
|-----|------|-------------|-------------|
| `/rest/getStarred2` | 收藏 (ID3 格式) | ✅ | 更丰富的元数据 |
| `/rest/getAlbumList2` | 专辑列表 (ID3 格式) | ❌ | 含 userRating 字段 |
| `/rest/getAlbumList?type=highest` | 高评分专辑 | ❌ | 评分 seeds（需额外调用） |
| `/rest/getAlbumList?type=starred` | 收藏专辑 | ❌ | 已有 getStarred |
| `/rest/getRandomSongs` | 随机歌曲 | ✅ | 可作为 fallback seed |
| `/rest/getNowPlaying` | 当前播放 | ✅ | 多用户场景 |
| `/rest/reportPlayback` | 播放报告 | N/A | 比 scrobble 更丰富 |

### 4.3 批量获取用户信号的 API

| API | 返回内容 | 是否含 songId |
|-----|----------|---------------|
| `getStarred` / `getStarred2` | 所有收藏项目 | ✅ song 数组含 songId |
| `getAlbumList?type=recent` | 最近播放专辑 | ❌ 仅 albumId |
| `getAlbumList?type=frequent` | 最常播放专辑 | ❌ 仅 albumId |
| `getAlbumList?type=highest` | 高评分专辑 | ❌ 仅 albumId |
| `getPlayQueue` | 保存的播放队列 | ✅ entry 数组含 songId |

**关键发现**：
- 只有 `getStarred` 和 `getPlayQueue` 能批量返回 songId
- `getAlbumList` 系列只返回 albumId，要拿 songId 需要额外调用

---

## 五、P1 Seed 聚合模型

### 5.1 WeightedSeed 数据结构

```dart
/// 加权推荐种子
class WeightedSeed {
  final String songId;
  final SeedSource source;
  final double weight;
  final String? reason;
  final int? timestamp; // Unix ms, 用于时间衰减

  const WeightedSeed({
    required this.songId,
    required this.source,
    required this.weight,
    this.reason,
    this.timestamp,
  });
}

enum SeedSource {
  favorite,      // 收藏歌曲
  recent,        // 最近播放
  rating,        // 高评分
  current,       // 当前播放
  queue,         // 播放队列
  playHistory,   // 本地播放历史
}
```

### 5.2 Seed 聚合 Provider 设计

**重要**：`userTasteSeedsProvider` 默认只包含 favorite seeds，用于首页 For You。Current playing 仅用于上下文推荐场景。

```dart
/// 用户品味种子聚合 Provider（For You 首页版本）
///
/// 默认只使用收藏歌曲作为 seeds。
/// 不包含 current playing（current playing 仅用于上下文推荐）。
@riverpod
Future<List<WeightedSeed>> userTasteSeeds(Ref ref) async {
  final seeds = <WeightedSeed>[];

  // 收藏歌曲 (权重 1.0) - For You 首页唯一来源
  final favoriteSeeds = await ref.watch(favoriteRecommendationSeedsProvider().future);
  for (final songId in favoriteSeeds) {
    seeds.add(WeightedSeed(
      songId: songId,
      source: SeedSource.favorite,
      weight: 1.0,
      reason: 'favorite',
    ));
  }

  // 去重：相同 songId 只保留权重最高的
  return deduplicateSeeds(seeds);
}

/// 上下文推荐种子聚合 Provider
///
/// 包含 current playing，用于相似电台、当前播放上下文推荐。
/// 不用于首页 For You。
@riverpod
Future<List<WeightedSeed>> contextRecommendationSeeds(Ref ref) async {
  final seeds = <WeightedSeed>[];

  // 1. 收藏歌曲 (权重 1.0)
  final favoriteSeeds = await ref.watch(favoriteRecommendationSeedsProvider().future);
  for (final songId in favoriteSeeds) {
    seeds.add(WeightedSeed(
      songId: songId,
      source: SeedSource.favorite,
      weight: 1.0,
      reason: 'favorite',
    ));
  }

  // 2. 当前播放歌曲 (权重 0.7) - 仅上下文推荐使用
  final player = await ref.read(appPlayerHandlerProvider.future);
  final queue = player?.playQueue;
  if (queue != null && queue.songs.isNotEmpty) {
    final index = queue.index;
    if (index >= 0 && index < queue.songs.length) {
      final currentSong = queue.songs[index];
      if (currentSong.id != null) {
        seeds.add(WeightedSeed(
          songId: currentSong.id!,
          source: SeedSource.current,
          weight: 0.7,
          reason: 'current_playing',
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ));
      }
    }
  }

  // 去重：相同 songId 只保留权重最高的
  return deduplicateSeeds(seeds);
}
```

### 5.3 Source 优先级与权重建议

| Source | 权重 | 适用场景 | P1 阶段 |
|--------|------|----------|---------|
| favorite | 1.0 | 首页 For You、上下文推荐 | P1-A ✅ |
| current | 0.7 | 仅上下文推荐（相似电台、当前播放上下文） | P1-B（上下文推荐） |
| queue | 0.5 | 仅上下文推荐 | P1-B |
| recent (本地 play_history) | 0.8 | 首页 For You | P1-B（需新增 DAO） |
| recent (server album) | 0.6 | 首页 For You | P1-C（成本高） |
| rating | 0.9 | 首页 For You | P1-C（无批量 API） |

**重要**：Current playing 不默认进入首页 For You，仅用于上下文推荐。

### 5.4 去重与合并策略

```dart
/// 去重：相同 songId 只保留权重最高的
List<WeightedSeed> deduplicateSeeds(List<WeightedSeed> seeds) {
  final bySongId = <String, WeightedSeed>{};
  for (final seed in seeds) {
    final existing = bySongId[seed.songId];
    if (existing == null || seed.weight > existing.weight) {
      bySongId[seed.songId] = seed;
    }
  }
  return bySongId.values.toList();
}

/// 时间衰减：最近播放权重更高
double applyTimeDecay(double baseWeight, int? timestamp) {
  if (timestamp == null) return baseWeight;
  final ageMs = DateTime.now().millisecondsSinceEpoch - timestamp;
  final ageDays = ageMs / (1000 * 60 * 60 * 24);
  // 半衰期 7 天
  return baseWeight * pow(0.5, ageDays / 7);
}
```

---

## 六、推荐排序策略

### 6.1 P0 已有能力

`recommendationsProvider` 已实现：
- Seed 去重
- 候选去重（跳过 seed 自身、跳过已见）
- Artist 多样性限制（max 3 per artist）
- Album 多样性限制（max 3 per album）
- 随机打乱 seed 顺序

### 6.2 P1 扩展建议

**复用策略**：P1 不修改 `recommendationsProvider`，只修改 seed 来源。

```dart
/// P1 For You 推荐 Provider（首页版本）
///
/// 只使用 favorite seeds，不包含 current playing。
@riverpod
Future<List<SongEntity>> forYouRecommendationsV2(Ref ref) async {
  // 使用新的 seed 聚合（仅 favorite）
  final seeds = await ref.watch(userTasteSeedsProvider().future);

  if (seeds.isEmpty) {
    return <SongEntity>[];
  }

  // 提取 songId，按权重排序
  final sortedSeeds = seeds
    ..sort((a, b) => b.weight.compareTo(a.weight));
  final songIds = sortedSeeds.map((s) => s.songId).toList();

  // 复用现有 Recommendations provider
  return ref.watch(recommendationsProvider(
    limit: 20,
    seedSongIds: songIds,
  ).future);
}
```

**注意**：`forYouRecommendationsV2` 仅消费 `userTasteSeedsProvider` 中的 favorite seeds，不包含 current playing。Current playing 仅通过 `contextRecommendationSeedsProvider` 用于上下文推荐。

### 6.3 不需要引入的新 Provider

P1 不需要引入新的推荐聚合 provider，因为：
- `recommendationsProvider` 已经是通用的 seed → recommendations 管道
- 只需要设计新的 seed 提取 provider
- 保持 P0 架构不变，降低风险

---

## 七、P1-A Implementation Status

### 7.1 P1-A 已实现

| 组件 | 文件位置 | 说明 |
|------|----------|------|
| **SeedSource enum** | `lib/model/recommendation/seed_source.dart` | 定义 seed 来源类型：favorite, recent, rating, current, queue, playHistory |
| **WeightedSeed model** | `lib/model/recommendation/weighted_seed.dart` | 不可变类：songId, source, weight, reason?, timestamp? |
| **favoriteWeightedSeedsProvider** | `lib/provider/recommendation/favorite_weighted_seeds.dart` | 将收藏歌曲转换为 WeightedSeed，复用 favoriteRecommendationSeedsProvider |
| **userTasteSeedsProvider** | `lib/provider/recommendation/user_taste_seeds.dart` | 聚合 seeds，当前只包含 favorite seeds，提供去重和排序 |
| **forYouRecommendationsV2Provider** | `lib/provider/recommendation/for_you_recommendations_v2.dart` | P1 推荐入口，复用 recommendationsProvider |

**测试覆盖**：
- `test/provider/recommendation/favorite_weighted_seeds_test.dart`
- `test/provider/recommendation/user_taste_seeds_test.dart`
- `test/provider/recommendation/for_you_recommendations_v2_test.dart`

**所有测试通过**：64 个 recommendation tests + 53 个 sonic similarity tests。

### 7.2 P1-A 当前行为

1. **favoriteWeightedSeedsProvider**
   - 复用 `favoriteRecommendationSeedsProvider`（不直接读 favoriteProvider）
   - 每个 favorite song 转换为 `WeightedSeed(songId, source: favorite, weight: 1.0, reason: 'favorite')`
   - 空收藏返回空列表，不抛异常

2. **userTasteSeedsProvider**
   - 当前只聚合 `favoriteWeightedSeedsProvider`
   - 去重：相同 songId 只保留权重更高的
   - 排序：按 weight 降序，同 weight 保持原始顺序（稳定排序）

3. **forYouRecommendationsV2Provider**
   - 从 `userTasteSeedsProvider` 获取 seeds
   - 提取 songId 列表
   - 调用 `recommendationsProvider(limit: 20, seedSongIds: songIds)`
   - 复用现有推荐聚合逻辑，不修改算法

4. **并行实现**
   - `forYouRecommendationsV2Provider` 不替换现有首页
   - 存在用于并行测试和未来迁移考虑

### 7.3 P1-A 明确未做

| 事项 | 状态 |
|------|------|
| 接首页 UI | ❌ 未做 |
| 接 current playing | ❌ 未做 |
| 接 play_history | ❌ 未做 |
| 接 scrobble | ❌ 未做 |
| 接 rating | ❌ 未做 |
| 修改数据库 schema | ❌ 未做 |
| 新增 DDL/migration | ❌ 未做 |
| 修改 recommendationsProvider 算法 | ❌ 未做 |
| fallback 到 getSimilarSongs2 | ❌ 未做 |
| 直接调用 AudioMuse-AI API | ❌ 未做 |

### 7.4 P1-B 重要注意事项：recommendationsProvider Shuffle 行为

**当前行为**：
- `recommendationsProvider` 内部会 **shuffle seedSongIds** 顺序
- 目的：增加推荐多样性，避免每次使用相同 seed 顺序

**对 P1-A 的影响**：
- P1-A 全部 favorite seeds 权重相同（都是 1.0）
- Shuffle 不影响结果，因为所有 seeds 权重相等

**对 P1-B 的影响**：
- P1-B 如引入不同权重的 source（play_history, current, queue, rating）
- `userTasteSeedsProvider` 输出已按权重排序的 seeds
- 但 `recommendationsProvider` 会 shuffle 打乱顺序
- **高权重 seeds 可能被 shuffle 到后面，导致优先级丢失**

**可选解决方案**：

| 方案 | 说明 | 优点 | 缺点 |
|------|------|------|------|
| **A. preserveSeedOrder 参数** | 给 `recommendationsProvider` 增加 `preserveSeedOrder: bool` 参数 | 向后兼容，可选 | 需修改 recommendationsProvider |
| **B. weightedRecommendationsProvider** | 新增独立的加权推荐 provider，不 shuffle | 不影响现有 provider | 增加代码量 |
| **C. 下游按顺序消费** | `userTasteSeedsProvider` 输出已排序，下游按顺序逐个调用 Sonic API | 不修改 recommendationsProvider | 需要新的聚合逻辑 |

**建议**：P1-B 实现时再决定方案。当前 P1-A 不受影响。

---

## 八、P1-A 最小实现（已完成）

### 8.1 范围

**P1-A: UserTasteSeeds 基础设施 + Favorite Seeds 重构** ✅ 已完成

- ✅ 抽象 `WeightedSeed` / `SeedSource` 数据结构（`lib/model/recommendation/`）
- ✅ 把现有 `favoriteRecommendationSeedsProvider` 包装为 `WeightedSeed` source
- ✅ 新增 `userTasteSeedsProvider`，默认只包含 favorite seeds
- ✅ **For You 首页仍只使用 favorite-derived seeds**
- Current playing 仅作为"上下文推荐 source"设计，不默认进入首页 For You（P1-B）

### 8.2 新增文件（已实现）

| 文件 | 状态 | 说明 |
|------|------|------|
| `lib/model/recommendation/seed_source.dart` | ✅ 已实现 | `SeedSource` enum |
| `lib/model/recommendation/weighted_seed.dart` | ✅ 已实现 | `WeightedSeed` model（不可变类） |
| `lib/provider/recommendation/favorite_weighted_seeds.dart` | ✅ 已实现 | Favorite seeds → WeightedSeed 转换 |
| `lib/provider/recommendation/user_taste_seeds.dart` | ✅ 已实现 | Seed 聚合 provider（仅 favorite） |
| `lib/provider/recommendation/for_you_recommendations_v2.dart` | ✅ 已实现 | P1 For You 入口（仅消费 favorite seeds） |
| `lib/provider/recommendation/context_recommendation_seeds.dart` | ⏳ P1-B | 上下文推荐 seed（含 current playing） |

**首页切换说明**：`forYouRecommendationsV2Provider` 已实现但未接首页 UI，用于并行测试。

### 8.3 不需要（已确认）

- ✅ 不需要新增 repository
- ✅ 不需要修改数据库
- ✅ 不需要新增 migration
- ✅ 不需要修改 `recommendationsProvider`
- ✅ 不需要修改 `favoriteRecommendationSeedsProvider`
- ✅ 不需要修改首页 UI（P1-A 阶段）

### 8.4 测试（已实现）

- ✅ `test/provider/recommendation/favorite_weighted_seeds_test.dart`
- ✅ `test/provider/recommendation/user_taste_seeds_test.dart`
- ✅ `test/provider/recommendation/for_you_recommendations_v2_test.dart`

### 8.5 验证命令

```bash
# Recommendation 测试（含 P1-A）
flutter test test/provider/recommendation/ --no-pub

# Sonic Similarity 测试
flutter test test/repository/sonic_similarity/ test/provider/sonic_similarity/ --no-pub

# 静态分析
flutter analyze
```

### 8.6 风险评估（已验证）

| 风险 | 等级 | 实际结果 |
|------|------|----------|
| 与 P0 行为不一致 | 低 | ✅ P1-A 只包含 favorite seeds，与 P0 行为一致 |
| 过早切换首页到 v2 | 低 | ✅ P1-A 未修改首页，forYouRecommendationsV2Provider 仅用于测试 |

---

## 九、P1-B 实现建议

### 9.1 范围

**P1-B: + Current Playing Seeds（上下文推荐）+ Play History Seeds（本地）**

- 新增 `contextRecommendationSeedsProvider`，包含 current playing，用于相似电台、当前播放上下文推荐
- 使用本地 `play_history` 表作为 seed 来源
- 需要新增 DAO 方法到 `AppPersistence`

### 9.2 新增/修改文件

| 文件 | 操作 | 说明 |
|------|------|------|
| `lib/provider/recommendation/context_recommendation_seeds.dart` | 新增 | 上下文推荐 seed（含 current playing） |
| `lib/persistence/app_persistence.dart` | 修改 | 新增 `loadPlayHistory` 方法 |
| `lib/persistence/app_persistence_sqlite.dart` | 修改 | 实现 `loadPlayHistory` |
| `lib/provider/recommendation/play_history_seeds.dart` | 新增 | 从 play_history 提取 seeds |
| `lib/app_logic/runtime/player_scrobble_runtime.dart` | 修改 | 同时写入本地 play_history |

### 9.3 风险

| 风险 | 等级 | 缓解措施 |
|------|------|----------|
| 修改 `AppPersistence` 接口 | 中 | 需要审计所有实现 |
| play_history 表可能为空 | 低 | 优雅降级，不影响其他 seeds |
| 需要确认表中数据写入逻辑 | 中 | 需要审计当前是否有写入 |
| Current playing 影响上下文推荐风格 | 低 | 这是预期行为，用户当前播放应影响上下文推荐 |

---

## 十、暂缓事项

### 10.1 P1-C 暂缓

- **Recent Albums Seeds**：需要 N+1 次 API 调用（getAlbumList + getAlbum × N），成本高
- **Rating Seeds**：无批量获取高评分歌曲的 API，只能从 getStarred 过滤
- **Scrobble-based Seeds**：需要服务端支持或本地拦截写入

### 10.2 P2 考虑

- 本地推荐结果缓存
- 更复杂的权重调优
- 用户可配置 seed 来源
- 推荐结果解释/可视化

---

## 十一、风险与开放问题

### 11.1 风险

| 风险 | 说明 | 缓解 |
|------|------|------|
| 本地 play_history 表可能无数据 | 当前 scrobble runtime 不写此表 | P1-B 需要同时修改写入逻辑 |
| Current playing 影响上下文推荐风格 | 用户当前播放会影响上下文推荐 | 这是预期行为，不影响首页 For You |
| 多 seed 来源可能导致推荐过于发散 | 不同风格的歌曲混合 | 依赖 Sonic Similarity 的聚类能力 |

### 11.2 开放问题

1. **Current playing 是否应该影响首页 For You？**
   - **已决定**：不影响。Current playing 仅用于上下文推荐（相似电台、当前播放上下文）。
   - 首页 For You 保持只使用 favorite seeds。

2. **Play history 写入时机？**
   - 当前 scrobble runtime 只发送到服务器
   - P1-B 需要决定：在 scrobble 时同步写入本地，还是单独的写入逻辑

3. **Seed 数量上限？**
   - P0 使用 5 个 seed
   - P1 多来源后是否需要调整？
   - 建议：保持 5 个，按权重排序后截取

4. **是否需要 UI 配置？**
   - 用户是否可配置启用哪些 seed 来源？
   - 建议：P1-A 不做，P2 再考虑

---

## 十二、参考

- P0 验收文档：`docs/recommendation/navidrome_recommendation_p0_acceptance.md`
- Navidrome 源码：`C:\Users\Mercury\Desktop\src\navidrome`
- AudioMuse-AI：`C:\Users\Mercury\Desktop\src\AudioMuse-AI`
- AudioMuse-AI-NV-plugin：`C:\Users\Mercury\Desktop\src\AudioMuse-AI-NV-plugin`
