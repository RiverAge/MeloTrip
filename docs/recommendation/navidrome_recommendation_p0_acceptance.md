# Navidrome Recommendation P0 Acceptance

## 一、背景

MeloTrip 作为 Navidrome/OpenSubsonic 客户端，推荐能力 P0 定位如下：

- MeloTrip 保持普通 Navidrome/OpenSubsonic 客户端边界。
- 不直接依赖 AudioMuse-AI Web UI/API。
- AudioMuse-AI 只通过 Navidrome/OpenSubsonic 扩展端点间接提供能力。
- P0 不做完整用户画像，不使用播放历史、评分、scrobble、本地画像缓存。
- P0 使用收藏歌曲作为 For You seeds。

## 二、已完成能力矩阵

| 能力 | 中文名 | 输入 | 接口 | 个性化 | UI 入口 | 空态 |
|------|--------|------|------|--------|---------|------|
| Similar Songs | 相似歌曲 | songId | `/rest/getSonicSimilarTracks.view` | 否 | 歌曲控制面板、相似歌曲页面 | 未找到相似歌曲 |
| Similar Radio | 相似电台 | seed song | `/rest/getSonicSimilarTracks.view` | 否 | 歌曲控制面板、当前播放页 | 无法开始电台/不 fallback |
| Sonic Path | 声音路径 | startSongId + endSongId | `/rest/findSonicPath.view` | 否 | 歌曲控制面板、Sonic Path 页面 | 不 fallback |
| For You | 猜你喜欢 | 当前用户收藏歌曲 seeds | 收藏 API + `/rest/getSonicSimilarTracks.view` | 近似个性化，基于收藏 seeds | 首页 | 首页占位 |
| Similar Artists | 相似艺术家 | artistId | `/rest/getArtistInfo2` | 否 | 移动端/桌面端艺术家详情页 | 隐藏区块 |

**说明**：

- Similar Songs、Similar Radio、Sonic Path 基于 AudioMuse-AI 提供的 Sonic Similarity 端点，属于声学相似性推荐，不是个性化推荐。
- For You 使用用户收藏歌曲作为种子，近似个性化推荐，但不是 AudioMuse-AI Sonic Fingerprint 直连模式。
- Similar Artists 使用 Navidrome/OpenSubsonic 扩展端点 `getArtistInfo2`。

## 三、明确禁止事项

以下行为在 P0 中明确禁止：

- 不调用 `/api/sonic_fingerprint/generate`。
- 不直接调用 AudioMuse-AI Web UI/API。
- 不 fallback 到 `getSimilarSongs2`。
- 不 fallback 到外部链接推荐。
- 不恢复 `server_capability`。
- 不做 capability 检测/cache/writeback。
- 不新增数据库 schema。
- 不新增 DDL。
- 不提升 SQLite version。
- 不新增 migration。
- P0 不使用播放历史、评分、scrobble、本地画像缓存。

## 四、主要代码位置

### Repository

- `lib/repository/sonic_similarity/sonic_similarity_repository.dart`
- `lib/repository/artist/artist_detail_repository.dart`

### Provider

- `lib/provider/sonic_similarity/sonic_similarity.dart`
- `lib/provider/recommendation/favorite_recommendation_seeds.dart`
- `lib/provider/recommendation/for_you_recommendations.dart`
- `lib/provider/artist/similar_artists.dart`

### UI

- `lib/pages/mobile/song_control/parts/song_actions.dart`
- `lib/pages/mobile/playing/parts/music_controls.dart`
- `lib/pages/mobile/similar_songs/similar_songs_page.dart`
- `lib/pages/mobile/sonic_path/sonic_path_page.dart`
- `lib/pages/mobile/home/parts/for_you_recommendations.dart`
- `lib/pages/mobile/artist/artist_detail_page.dart`
- `lib/pages/desktop/artist/artist_detail_page.dart`

### Model

- `lib/model/response/sonic_similarity/sonic_similarity.dart`
- `lib/model/response/artist_info2/artist_info2.dart`
- `lib/model/response/subsonic_response.dart`

## 五、验收测试命令

```bash
# Sonic Similarity 测试
flutter test test/repository/sonic_similarity/sonic_similarity_repository_test.dart test/sonic_boundary_test.dart test/provider/sonic_similarity/radio_queue_test.dart --no-pub

# Recommendation 测试
flutter test test/provider/recommendation/favorite_recommendation_seeds_test.dart test/provider/recommendation/for_you_recommendations_test.dart --no-pub

# Artist Detail / Similar Artists 测试
flutter test test/repository/artist_detail_repository_test.dart test/provider/artist_detail_test.dart test/provider/similar_artists_test.dart --no-pub

# 静态分析
flutter analyze
```

## 六、P1 暂缓事项

以下功能在 P0 中暂缓，后续可讨论：

- 播放历史 seeds。
- 高评分 songs/albums seeds。
- scrobble-based seeds。
- 本地 recommendation cache。
- 更复杂的 seed 权重。
- AudioMuse-AI Sonic Fingerprint 直连模式。
- 桌面端更多推荐入口统一。
- 推荐结果解释/可视化。

## 七、P1-A Follow-up Status

P1-A 已完成基础设施搭建，以下是相对于 P0 的变更：

### 7.1 P1-A 新增内容

| 组件 | 说明 |
|------|------|
| `SeedSource` enum | 定义 seed 来源类型（favorite, recent, rating, current, queue, playHistory） |
| `WeightedSeed` model | 加权种子数据结构 |
| `favoriteWeightedSeedsProvider` | 将收藏歌曲转换为 WeightedSeed |
| `userTasteSeedsProvider` | 聚合用户品味 seeds（当前仅 favorite） |
| `forYouRecommendationsV2Provider` | P1 推荐入口（并行实现，未接 UI） |

### 7.2 P0 验收仍然成立

- ✅ P0 推荐能力未受影响
- ✅ 首页 For You 仍使用 `forYouRecommendationsProvider`（P0 版本）
- ✅ `forYouRecommendationsV2Provider` 未连接 UI，不影响用户可见行为

### 7.3 P1-A 未改变的事项

| 事项 | 状态 |
|------|------|
| 数据库 schema | ✅ 未修改 |
| DDL / migration | ✅ 未新增 |
| SQLite version | ✅ 未提升 |
| server_capability | ✅ 未恢复 |
| 首页 UI | ✅ 未修改 |
| P0 provider 行为 | ✅ 未修改 |

### 7.4 P1-A 未引入的事项

| 事项 | 状态 |
|------|------|
| current playing seeds | ❌ 未引入 |
| play_history seeds | ❌ 未引入 |
| scrobble seeds | ❌ 未引入 |
| rating seeds | ❌ 未引入 |
| fallback to getSimilarSongs2 | ❌ 未引入 |
| AudioMuse-AI direct API | ❌ 未引入 |

### 7.5 P1-B 注意事项

**recommendationsProvider shuffle 行为**：
- 当前 `recommendationsProvider` 内部会 shuffle seedSongIds
- P1-A 全部 favorite seeds 权重相同（1.0），不受影响
- P1-B 如引入不同权重 source，需处理 shuffle 与权重的关系
- 详见 `docs/recommendation/navidrome_recommendation_p1_design.md` 第 7.4 节

### 7.6 验收测试命令

P0 验收测试命令仍然适用：

```bash
# Sonic Similarity 测试
flutter test test/repository/sonic_similarity/sonic_similarity_repository_test.dart test/sonic_boundary_test.dart test/provider/sonic_similarity/radio_queue_test.dart --no-pub

# Recommendation 测试（含 P1-A）
flutter test test/provider/recommendation/ --no-pub

# Artist Detail / Similar Artists 测试
flutter test test/repository/artist_detail_repository_test.dart test/provider/artist_detail_test.dart test/provider/similar_artists_test.dart --no-pub

# 静态分析
flutter analyze
```

---

## 八、参考项目

- Navidrome: `C:\Users\Mercury\Desktop\src\navidrome`
- AudioMuse-AI: `C:\Users\Mercury\Desktop\src\AudioMuse-AI`
- AudioMuse-AI-NV-plugin: `C:\Users\Mercury\Desktop\src\AudioMuse-AI-NV-plugin`
