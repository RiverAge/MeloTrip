# melo_trip

Melo Trip.

### flutter pub run build_runner watch

## TODO

1. ~~登录超时~~
1. 用户信息等一些基本信息的保持（如何优雅的访问）
1. ~~高斯模糊~~
1. ~~通用的深色模式的适配~~
1. ~~通知栏图标的优化（现在图标过大）~~
1. ~~App图标~~ 
1. ~~搜索页面优化成Tab页方式的切换~~
1. ~~CachedNetworkImage转圈~~
1. 红心（收藏点下）之后通知栏、页面之间最好同步
1. ~~程序流量使用过大~~
1. 缓存最大限制配置
1. ~~专辑页面优化~~
1. ~~搜索页面的文本不居中~~
1. ~~provider model 命名混乱，很多叫一个名字的，无法区分~~
1. 今日推荐的实现，是否需要通过一个代理服务器生成今日推荐的数据？ 
1. subsonic-response 的stauts字段是否需要处理成enums
1. ~~star/unstar 会同时影响 `favoriteprovider` 和 `songdetailprovider` 该如何优化~~
1. ~~搜索页面进入后需要自动获取焦点~~
1. ``AsyncValueBuilder`` ``AsyncStreamBuilder`` 空的情况需要考虑优化
1. ~~从旋转封面滑动到歌词，有明显的动画效果，期望在这一阶段直接跳过去(暂无法解决)~~
1. ~~长按歌曲需要有 ``查看歌曲详情`` ``添加到播放列表`` ``收藏`` ``添加到歌单``~~
1. ~~首页音乐栏的播放列表需要优化包括 标题样式优化  添加 ``随机`` ``列表循环`` ``单曲播放等的功能``~~
1. 选择音质的功能没有实现
1. ~~播放次数功能的实现~~
1. ~~最近播放歌曲功能的实现~~
1. ~~艺术家页面功能实现~~
1. ~~统一 ``elevation``~~

### BUG
1. ~~正在播放页面旋转的圆形封面图片不圆~~
1. ~~正在播放页面播放进度偶尔无法获取，导致显示 ``暂无数据``~~
1. ~~播放页面的单曲循环好像不好使(没有复现)~~
1. ~~首页播放栏，点开的播放列表，不断的删除直至为空，会报错~~

### 启动

#### freezed 自动生成代码
`dart run build_runner watch`
