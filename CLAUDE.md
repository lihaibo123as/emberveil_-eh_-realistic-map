# EH_RealisticMap 记忆体（子插件自己的判据 / 铁律 / 锚点）

> ★用户定：**子插件的记忆体放在子插件自己目录里，自己管理自己**（不与宿主 `CLAUDE.md` 混合）。
> 本文件只写「**搬过来之后变了什么**」与「**现行锚点在哪**」；**逐条判据的历史与全案仍在宿主 `CLAUDE.md` §5.4**
> （`⑨`~`⑯` 那一大段 = 世界迷雾 / 接管守护 / 残留清理 / 编辑模式 / 区域实景），**读那些条目时按本文件顶部的
> 「搬迁映射表」替换路径 / 命令 / 存档键 / 帧名**即可 —— 两处并存必然漂移，所以正文**不复述**。

## 0. 搬迁映射表（2026-10-10 整族迁入，宿主 `tools/WorldFog.lua` 已删除）

| 宿主期（旧） | 现在（本插件） |
| --- | --- |
| `tools/WorldFog.lua`（宿主 toc 里的模块） | `addons\EH_RealisticMap\EH_RealisticMap.lua`（**唯一真值**，7100+ 行） |
| 存档根 `EvalHelp.lua` 的 `worldFogCfg` 子树 | 存档根 **`EH_REALISTICMAP_CFG`**（自己那份；旧数据**只在首次载入纯读导入一次**） |
| 工具箱 → UI 工具 → **「关闭世界迷雾」那一行**（勾选框 + `[设置]`） | **该行已从工具箱删除** ⇒ 入口 = **第 ⑦ 页「子插件」里 `EH_RealisticMap` 那一行的 `[打开]`** + **`/erm`** |
| `/ehm mapfit <子命令>`（宿主转发） | **`/erm <子命令>`**（**子命令逐字相同**）；宿主那一条现在只回一行**指路播报**，不再转发 |
| 聊天前缀 `[简易地图]` / `[mapfit]` | **`[EH_RealisticMap]`**（`ADDON_NAME` / `ADDON_TAG` 一处拼） |
| 节拍帧 `EH_WF_FEAT` · 清账帧 `EH_WF_CLEAN` · 编辑面板/列表/接盘 `EVAL_WF_*` | `ERM_FEAT` · `ERM_CLEAN` · `ERM_EDITLIST` / `ERM_EDITCATCH` / `ERM_GRAB<n>` |
| 贴图/数据：根目录 `MapOverlayJPGData.lua`、`MapOverlayOffsetJPG.lua`、`media\WorldMapJpg\` | **整份搬进本目录**（随子插件打包；主包不再带 `media\WorldMap*`） |
| 语言键 `TB_SM_*` / `WF_*` 里的 35 条（宿主 `Locales\*`） | 搬进本插件的 `Locales\{zhCN,enUS,ruRU}.lua`（**键名一字未改**，另加 19 条 `ERM_*`） |
| `MDQ.BUILD` = 宿主版本 | **`MDQ.BUILD` = `0.1.0`**（== 本目录 `.toc` 的 `## Version`），与宿主版本**解耦** |

## 1. 本插件是什么

- **世界迷雾（S_WorldMap 表驱动全渲染）** + **接管守护**（原生探索层全藏 + 按表自绘 + 每拍查数量/存在性）
  + **残留图层清理**（切到没有探索层数据的图 ⇒ 把上一张图的 `WorldMapOverlay*` 全藏，切回来再全还）
  + **区域实景贴图**（`media\WorldMapJpg\` 整区一张铺满 1002×668 帧；默认档 = **开 + 区域实景**）
  + **编辑模式**（贴图列表 / 逐块拖拽 / 位置箭头 / 尺寸 / 统一透明度 / 两级重置 / 保存并 `/reload`）。
- 宿主侧**只剩 5 个只读桥**：`EVAL_SM_MAPINFO` / `EVAL_SM_MAPKEY` / `EVAL_SM_NUMOVERLAYS` /
  `EVAL_SM_EFFSCALE` / `EVAL_SM_OPEN`（全走 `brCall` = `rawget` + `type` 两道 + `pcall`）。
  宿主 `tools/SimpleMap.lua` 另出三个薄壳给它自己用：`smFogApi()` / `smFogTakesMap()` / `smFogOn()`。
  ★**读取口一律运行期现读、绝不载入期抓成 local**（契约 ⑤）。

## 2. 契约（动本插件前必读）

- **② 记忆体分离**：本插件**只写自己的 `EH_REALISTICMAP_CFG`**；宿主的 `EVAL_HELP_CONFIG` / `EVAL_HELP_CHAR`
  **只读**，而且**只有一个地方读**——`importHostCfg()`（一次性导入，标记 `importedV1`，纯读、不写回）。
  ★宿主 `texTestCfg` 这类**宿主自己的存档清理不许在这里做**（已按契约撤掉，交回 `Core.lua` 的 `LOAD_RESIDUE_KEYS`）。
- **⑤ 隔离性**：所有对外口 = `EH_RealisticMap.{name,build,on,takesMap,status}`（文件末尾统一收口）+
  面板/状态走 `MDQ.*`。**对手方不在场也不许报错**：`rawget` + `type` 两道 + `pcall` + fail-open + 如实降级。
- **⑥ 命名**：面向玩家的前缀 = **`[EH_RealisticMap]`**，只由 `ADDON_NAME` 一处拼（`ADDON_TAG = "["..ADDON_NAME.."] "`）。
- **① 动它的 5 处清单**：本目录（toc + 源码 + Locales + 两张数据表 + media）· 宿主 `Toolbox.lua` 的 `SUBADDONS`
  表 · 三语 `SUB_REALISTICMAP[_TIP]` · `probe_localorder.js` 默认清单（**已加**）· `tmp/*_harness.js` 与
  `tmp/*_wiring_check.js`（**欠账，见 §5**）。**新跨插件口 ⇒ 同时更新 `tmp/subaddon_isolation_probe.js` 的 `LIST`**。

## 3. 现行锚点（改代码先看这几行）

- `ADDON_NAME = "EH_RealisticMap"` · `ADDON_TAG` · `MDQ.BUILD = "0.1.0"` —— 版本号**只此一处**（+ `.toc`）。
- 存档代理：`cfgLive()` / `ERM_CFG` → `EH_REALISTICMAP_CFG`；键 = `importedV1` / `swmOverlay` / `staleClean` /
  `layerMode` / `editMode` / `edit` / `editJpg` / `editLog` / `staleLog` / `trace` / `perfProbe` / `fitDiag` /
  `cacheCleared51` / `probeCleared52` / `mapFitMode` / `mapFitVerbose` / `texPack`(已清) / `buildTag`。
- 播报：`fogSay` / `fogSayV`（受宿主总闸门 `EVAL_CHAT_ON` 管）+ **命令回显窗口** `ECHO_SEC = 0.75` / `ECHO_AT`；
  `verboseOn()`；取证环 `fogLog` → `ERM_CFG.trace`（有界 `ERM_TRACE_MAX = 60`）。
- 默认档归一 / 一次性导入 / 清账 = **`VARIABLES_LOADED` 块**（`ERM_CLEAN` 帧）：
  ★**顺序铁律 = 先 `importHostCfg()` 再「默认档归一」**（反了 = 导入进来的值还没落地就被 `nil ⇒ 显式 true` 顶掉 = 顶改用户选择）。
- 面板：`MDQ.cfgPanel{Build,Show,Hide,Shown,Refresh,ChromeLine}` + `ERM_EDITLIST`；
  **边框走项目唯一配方**（§三.10：tooltip 圆角 + `GetBackdrop` 读回自证 + flat 时四边描边 + **圆角时收起自建方底**）。
- 命令：`SLASH_ERM1 = "/erm"` + `SlashCmdList["ERM"]` ⇒ 空/`ui`/`面板`/`状态` 打状态行，其余**原样交给 `MDQ.cmd`**
  （与宿主期 `/ehm mapfit <子命令>` 逐字同义）。未知子命令**如实报 + 摊开用法**，绝不静默。

## 4. 常驻闸门（**只在「统一推送」那轮跑**）

`node luacheck.js` · `node probe_localorder.js`（**本文件已在默认清单里**）· `node scan_dangling.js` ·
`node tmp/subaddon_isolation_probe.js` · `node tmp/subaddon_naming_probe.js` · `node tmp/mem_sep_probe.js`
（豁免 = `importHostCfg` 那一处**纯读**，写点必须 0）· `node tmp/toc_savedvars_check.js` ·
`node tmp/glyph_minus_scan.js`（非注释行 U+2212 一个都不许有）· `node tmp/verify_jpgdata.js`（52 键 ↔ 52 张顶层 JPG，
主城 4 键**不许**在表里）· `node sync_game.js` + `node tmp/verify_sync.js`。

## 5. 欠账（搬迁当轮如实记，统一推送时重指）

- ★★★**打包器已修（2026-10-10 实抓，本插件就是那个受害者）**：`tmp/pack_subaddons.ps1` 原来那条 toc 解析正则
  （`^([A-Za-z0-9_\-\.]+\.(lua|…))\s*$`）**不允许 `\`** ⇒ 本插件 toc 里的 `Locales\zhCN.lua` / `enUS` / `ruRU`
  **既没被打进包、也没被自检发现**（自检那条腿与打包器**共用同一个坏正则** = **假绿**：`tocMissing=0`，
  而包里一个语言包都没有 —— 玩家单独装那份 = 全界面裸键名，纯静默）。
  修法三条：① 字符类加 `\\/`；② 子目录条目要**先建父目录**再拷（不能把 `Locales\x.lua` 直接拷进包根）；
  ③ **新增一条独立腿**：「**raw toc 行（现读、分隔符归一）必须 ⊆ 已列清单**」+ `rawMissing=0` + `tocRaw=N` 计数
  —— **绝不与打包器共用解析器**（本次就是共享解析器才绿的）。
  ★同批收窄了 xml 的 `file="…"` 传递腿：**只认裸脚本名**（`x.lua`/`x.xml`），因为 xml 里还有
  `file="Interface\Buttons\…"`（客户端美术）与 `file="Interface\AddOns\<名>\<图>.blp"`（插件美术，归 assets 腿）
  —— 放宽后会把这些当 toc 条目 ⇒ `SOURCE MISSING` 假红（EH_Mail 当场报了 3 个 blp/tga）。
  ★该口径的**正典位置** = 宿主 `CLAUDE.md` §4.3 契约 ④ 的「打包口径」那段（下次清账时补进那一行）。
  ★复算 = `powershell -File tmp\pack_subaddons.ps1` ⇒ **六包全 `fail=0`**，本插件 `entries=62` 且含
  `Locales/{zhCN,enUS,ruRU}.lua`、`_city=0`、`CLAUDE=0`。
- `tmp/swm_harness.js` / `tmp/swm_mutate.js` / `tmp/worldfog_guard_harness.js` / `tmp/worldfog_guard_mutate.js` /
  `tmp/wfcmd_harness.js` / `tmp/wfverdict_harness.js` / `tmp/wfalpha_harness.js` / `tmp/smdiag_harness.js` /
  `tmp/layer_probe_harness.js` / `tmp/say_gate_check.js` —— 读的还是 `tools/WorldFog.lua`（**该文件已删除**）⇒
  下一轮统一推送必须改路径 + 桥白名单 9→5 + `EVAL_WF_*` 三口的对象改成 `EH_RealisticMap` 表。
- `tmp/read_wfedit.js` / `tmp/wf_diff.js` / `tmp/wf_accounts.js` / `tmp/smcfg_diff.js`：偏移量与日志环现在在
  **`EH_REALISTICMAP_CFG`**（自己的存档文件 `EH_RealisticMap.lua`）里，不在 `EvalHelp.lua` 的 `worldFogCfg`。
- `tmp/ver_check.js` / `tmp/ver3_check.js` / `tmp/verify_version3.js` 三个旧版本脚本也指着 `tools/WorldFog.lua`
  （现行版本闸门 = `tmp/rel_version_check.js`：**宿主两处 + 每个子插件 toc ↔ 源码 build 常量**）。
- 本目录**还没有** `tmp/erm_*_harness.js` / `_wiring_check.js`（契约 ① 的第 5 处）—— 搬迁当轮按纪律没跑判据批次。
