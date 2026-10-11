-- ★★★生成物（**勿手改**）—— 生成器：`node tmp/gen_worldmapsourcedata.js`（源 = 磁盘上的 media/WorldMapSource/*_src.jpg）
--   用途：**原始图**（`media\WorldMapSource\<图>_src.jpg` 整区一张）在世界地图帧里的定位数据。
--   形态：`EVAL_MAP_OVERLAY_SOURCE_DATA[地图文件名] = { 宽, 高, 偏移x, 偏移y }`
--     · 单位 = **地图像素**（原点 = 地图帧左上、y 向下，与 `MapOverlayData.lua` / `MapOverlayJPGData.lua` 同口径）
--     · 整区一张图 ⇒ 每张图**只有一条**记录；基线恒 `1002,668,0,0`（= 铺满帧、与世界地图坐标逐像素对齐）
--   ★素材怎么来的（生成器 `tmp/gen_worldmapsource.js`，**不是外部素材，是客户端自己的美术**）：
--     ① 基础底图 = `Interface\WorldMap\<图>\<图>1..12`（4x3x256 行优先，从帧左上 1:1 铺、右下被 1002x668 裁掉），
--        抽取器 `tmp/wmsrc_base_tiles.js --kind base`：**按补丁优先级**取（interface → patch → patch-2 … patch-9 → patch-Z，
--        后者覆盖前者 = 客户端实际加载顺序）⇒ 53 张图的底图全部齐全（patch-9 474 块 + patch-Z 162 块）；
--     ② 区域块 = `<区域><块号>`（抽取器 `--kind area`，同样按优先级：patch-Z 656 块 + patch-9 363 块 = 1019 块）；
--     ③ 位置 = `MapOverlayData.lua` 表值 + `MapOverlayOffset.lua` 补偿（与运行期 `editFinal`/`editSize` **同一套算式**：
--        `ox+x, oy+y`、尺寸 = 块尺寸 + `dw/dh`）⇒ 与游戏里「全探索」时逐像素对位。
--   ★用户微调不进这个文件（生成物）：活增量在存档 `EH_REALISTICMAP_CFG.editSrc`，
--     烘成插件基线走 `node gen_mapoffset.js --src` → `MapOverlayOffsetSource.lua`（与另两档完全对称）。
--   统计：图 53 张 ｜ 帧 1002x668 ｜ 源 = media/WorldMapSource（客户端美术合成）
EVAL_MAP_OVERLAY_SOURCE_DATA = {
	["AlteracValley"]={1002,668,0,0}, ["Alterac"]={1002,668,0,0}, ["Arathi"]={1002,668,0,0}, ["Ashenvale"]={1002,668,0,0}, ["Aszhara"]={1002,668,0,0},
	["Badlands"]={1002,668,0,0}, ["Balor"]={1002,668,0,0}, ["Barrens"]={1002,668,0,0}, ["BlackstoneIsland"]={1002,668,0,0}, ["BlastedLands"]={1002,668,0,0},
	["BurningSteppes"]={1002,668,0,0}, ["Darkshore"]={1002,668,0,0}, ["DeadwindPass"]={1002,668,0,0}, ["Desolace"]={1002,668,0,0}, ["DunMorogh"]={1002,668,0,0},
	["Durotar"]={1002,668,0,0}, ["Duskwood"]={1002,668,0,0}, ["Dustwallow"]={1002,668,0,0}, ["EasternPlaguelands"]={1002,668,0,0}, ["Elwynn"]={1002,668,0,0},
	["Felwood"]={1002,668,0,0}, ["Feralas"]={1002,668,0,0}, ["Gillijim"]={1002,668,0,0}, ["Gilneas"]={1002,668,0,0}, ["GrimReaches"]={1002,668,0,0},
	["Hilsbrad"]={1002,668,0,0}, ["Hinterlands"]={1002,668,0,0}, ["Hyjal"]={1002,668,0,0}, ["Icepoint"]={1002,668,0,0}, ["Lapidis"]={1002,668,0,0},
	["LochModan"]={1002,668,0,0}, ["Moonglade"]={1002,668,0,0}, ["Moonwhisper"]={1002,668,0,0}, ["Mulgore"]={1002,668,0,0}, ["Northwind"]={1002,668,0,0},
	["Redridge"]={1002,668,0,0}, ["SearingGorge"]={1002,668,0,0}, ["Silithus"]={1002,668,0,0}, ["Silverpine"]={1002,668,0,0}, ["StonetalonMountains"]={1002,668,0,0},
	["Stranglethorn"]={1002,668,0,0}, ["SwampOfSorrows"]={1002,668,0,0}, ["Tanaris"]={1002,668,0,0}, ["TelAbim"]={1002,668,0,0}, ["Teldrassil"]={1002,668,0,0},
	["ThalassianHighlands"]={1002,668,0,0}, ["ThousandNeedles"]={1002,668,0,0}, ["Tirisfal"]={1002,668,0,0}, ["UngoroCrater"]={1002,668,0,0}, ["WesternPlaguelands"]={1002,668,0,0},
	["Westfall"]={1002,668,0,0}, ["Wetlands"]={1002,668,0,0}, ["Winterspring"]={1002,668,0,0}
}
-- ★元信息（取证用：核对时写日志，一眼知道比对的是哪一版数据）
EVAL_MAP_OVERLAY_SOURCE_META = { maps = 53, frame = "1002x668", src = "media/WorldMapSource", gen = "gen_worldmapsourcedata.js" }
