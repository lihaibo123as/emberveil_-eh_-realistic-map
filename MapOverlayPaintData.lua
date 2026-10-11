-- ★★★生成物（**勿手改**）—— 生成器：`node tmp/gen_mappaintdata.js`（源 = 磁盘上的 media/WorldMapPaint/*_cn.jpg）
--   用途：**图层彩绘**（`media\WorldMapPaint\<图>_cn.jpg` 整区一张）在世界地图帧里的定位数据。
--   形态：`EVAL_MAP_OVERLAY_PAINT_DATA[地图文件名] = { 宽, 高, 偏移x, 偏移y }`
--     · 单位 = **地图像素**（原点 = 地图帧左上、y 向下，与 `MapOverlayData.lua` / `MapOverlayJPGData.lua` 同口径）
--     · 整区一张图 ⇒ 每张图**只有一条**记录；只有走 `MapOverlayPaintData.lua` 这一档的图才在这里
--   ★素材怎么来的（生成器 `tmp/gen_mappaint.js`，几何口径 = 客户端自己的 FrameXML）：
--     `WorldMapDetailTile1..12` 每块 256×256，从 `WorldMapDetailFrame`(1002×668) 左上 **1:1** 铺成
--     4×3 = 1024×768（右下被帧裁掉 22 / 100）；区域层 `GetMapOverlayInfo` 给 (w,h,ox,oy) 并按 256 网格切块，
--     **UV = 像素/2的幂**（与文件实际尺寸无关）⇒ 素材是原生几何的 **2 倍**。
--     出图 = 2× 帧空间（2004×1336）→ 1500×1000 ⇒ 比例恰为 1002:668 ⇒ **基准 = 铺满帧 @0,0**。
--   ★画法 = **12 块基础瓦片打底 + 区域块叠上去** = 游戏里「全探索」时的真实画面（`unrealMap.lua`：
--     没探索画基础、探索后叠区域）；艾尔文森林已目视验收：彩色区与底图水系/山脉逐特征对齐。
--   ★用户微调不进这个文件（生成物）：活增量在存档 `EH_REALISTICMAP_CFG.editPaint`，
--     烘成插件基线走 `node gen_mapoffset.js --paint` → `MapOverlayOffsetPaint.lua`（与实景那套完全对称）。
--   统计：图 41 张 ｜ 帧 1002x668 ｜ 源 = media/WorldMapPaint（UnrealMap 的 HD 贴图派生）
EVAL_MAP_OVERLAY_PAINT_DATA = {
	["AlteracValley"]={1002,668,0,0}, ["Alterac"]={1002,668,0,0}, ["Arathi"]={1002,668,0,0}, ["Ashenvale"]={1002,668,0,0}, ["Aszhara"]={1002,668,0,0},
	["Badlands"]={1002,668,0,0}, ["Barrens"]={1002,668,0,0}, ["BlastedLands"]={1002,668,0,0}, ["BurningSteppes"]={1002,668,0,0}, ["Darkshore"]={1002,668,0,0},
	["DeadwindPass"]={1002,668,0,0}, ["Desolace"]={1002,668,0,0}, ["DunMorogh"]={1002,668,0,0}, ["Durotar"]={1002,668,0,0}, ["Duskwood"]={1002,668,0,0},
	["Dustwallow"]={1002,668,0,0}, ["EasternPlaguelands"]={1002,668,0,0}, ["Elwynn"]={1002,668,0,0}, ["Felwood"]={1002,668,0,0}, ["Feralas"]={1002,668,0,0},
	["Hilsbrad"]={1002,668,0,0}, ["Hinterlands"]={1002,668,0,0}, ["LochModan"]={1002,668,0,0}, ["Moonglade"]={1002,668,0,0}, ["Mulgore"]={1002,668,0,0},
	["Redridge"]={1002,668,0,0}, ["SearingGorge"]={1002,668,0,0}, ["Silithus"]={1002,668,0,0}, ["Silverpine"]={1002,668,0,0}, ["StonetalonMountains"]={1002,668,0,0},
	["Stranglethorn"]={1002,668,0,0}, ["SwampOfSorrows"]={1002,668,0,0}, ["Tanaris"]={1002,668,0,0}, ["Teldrassil"]={1002,668,0,0}, ["ThousandNeedles"]={1002,668,0,0},
	["Tirisfal"]={1002,668,0,0}, ["UngoroCrater"]={1002,668,0,0}, ["WesternPlaguelands"]={1002,668,0,0}, ["Westfall"]={1002,668,0,0}, ["Wetlands"]={1002,668,0,0},
	["Winterspring"]={1002,668,0,0}
}
-- ★元信息（取证用：核对时写日志，一眼知道比对的是哪一版数据）
EVAL_MAP_OVERLAY_PAINT_META = { maps = 41, frame = "1002x668", src = "media/WorldMapPaint", gen = "gen_mappaintdata.js" }
