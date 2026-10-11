-- ★★★2026-10-11：**「原始图」这一档的插件基线（目前故意是空表）**
--   形态：`EVAL_MAP_OVERLAY_OFFSET_SOURCE[地图文件名][区域名][块号] = { x=, y=, dw=, dh=, bx=, by=, bw=, bh= }`
--     · 语义与另两档（`MapOverlayOffset.lua` / `MapOverlayOffsetPaint.lua`）**逐字相同**：
--       合并累积（存档非零 = 写/更新 ｜ 存档显式 0 影 = 删除 ｜ 存档没有 = 保留）；
--       `x,y` = **表口径**偏移量（正 x 右 / 正 y 下）；`dw,dh` = 尺寸补偿；`bx,by,bw,bh` = 导出时该块在
--       基础表里的值（配对基准 ⇒ 基础表重生时能判出「这条是按旧表调的」）。
--     · 最终坐标 = `MapOverlaySourceData.lua` 表值 + 这里（与另两档同一条算式 `MDQ.editFinal` / `MDQ.editSize`）。
--   ★为什么现在是空的：「原始图」的合成图**已经把 `MapOverlayOffset.lua` 那份偏移烘进像素里了**
--     （生成器 `tmp/gen_worldmapsource.js`：位置 = `MapOverlayData` 表值 + 那份补偿）⇒ 这一档的**活增量从零开始**：
--     用户在编辑模式里针对「原始图」调出来的值存**本插件存档** `EH_REALISTICMAP_CFG.editSrc`（会话内即刻生效），
--     要发给别人才需要把存档烘成这个文件（★**烘基线的生成器模式 `gen_mapoffset.js --src` 尚未实现** = 欠账，
--     见 `CLAUDE.md` §5；在那之前本文件只当「空基线」占位：读口 `MDQ.editFileTbl` 拿到空表 = 与另两档同形状，
--     一处也不用特判）。
EVAL_MAP_OVERLAY_OFFSET_SOURCE = {
}
-- ★元信息（取证用：核对时一眼知道这份基线是哪来的、有几条）
EVAL_MAP_OVERLAY_OFFSET_SOURCE_META = { maps = 0, offsets = 0, src = "EH_REALISTICMAP_CFG.editSrc", gen = "（待实现）gen_mapoffset.js --src" }
