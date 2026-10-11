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
| 语言键 `TB_SM_*` / `WF_*` 里的 35 条（宿主 `Locales\*`） | 搬进本插件的 `Locales\{zhCN,enUS,ruRU}.lua`（**键名一字未改**，另加 `ERM_*`（现共 27 条）） |
| `MDQ.BUILD` = 宿主版本 | **`MDQ.BUILD` = `0.2.9`**（== 本目录 `.toc` 的 `## Version`），与宿主版本**解耦** |

> ★★★**2026-10-11 新增「图层彩绘」与「原始图」（三档并列可切换；后者见 §7）** —— 这一档是**新东西**，不在搬迁映射表里：
> 用户原话「**新建个图层类型:图层彩绘,和实景图层并列可切换**」。素材/数据/生成器/闸门见 §3 与 §4；
> **几何口径与验收**见本文件 §6。

## 6. 图层彩绘（`MDQ.LAYER_PAINT`）—— 口径、生成器、验收（2026-10-11）

- **它是什么**：与「区域实景」并列的第二档整区图层 —— 素材 = `media\WorldMapPaint\<图>_cn.jpg`（**41 张**），
  （★0.2.9 起还有**第三档「原始图」** = `media\WorldMapSource\<图>_src.jpg`，见 §7 —— 三档并列可切换）
  内容 = **UnrealMap**（外部镜像的高清地图包）那套**游戏重绘风格**贴图拼出来的整区图。
- ★★★**三档素材的**文件名必须带档后缀**（0.2.7；用户定：「将所有纹理名称重命名一下后缀加一个 _cn 代表中文纹理.
  实景后缀 _re」）** —— 实景 = `<图>_re.jpg`、彩绘 = `<图>_cn.jpg`、**原始图 = `<图>_src.jpg`**；运行期路径**只在三处**拼
  （`MDQ.jpgPath` / `MDQ.paintPath` / `MDQ.srcPath`，常量 `MDQ.JPG_SUF = "_re"` / `MDQ.PAINT_SUF = "_cn"` / `MDQ.SRC_SUF = "_src"`）。
  ★**为什么**：两档原本**同名不同目录**（`WorldMapJpg\Elwynn` 与 `WorldMapPaint\Elwynn` 逐字相同），
  真机形态恰是「**贴图路径读回换了、对象也在屏上 ⇒ 画面一动不动**」⇒ 先排除「同名被当成同一张」这条；
  同时对上本项目老规矩「**换素材要换新文件名或重启客户端**」（本客户端贴图缓存按名存活）。
  ★**判据**：生成器与闸门都带**命名规范**一条腿（`gen_mapjpgdata.js` / `gen_mappaintdata.js` 生成前查后缀、
  不带就打印文件名 + `exit 1`；`verify_jpgdata.js` / `verify_paintdata.js` 同样）；
  改名脚本 = `tmp/rename_layer_tex.js`（幂等，映射表 `tmp/rename_layer_tex.log.tsv`）。
  ★**改档后缀要一起改的四处**：两个 Lua 常量 · 生成器里的 `SUF` · 两个闸门的正则 · 出图脚本的产物名。
- ★★★**几何口径 = 客户端自己的 FrameXML**（`tmp/mpq_out/Interface/FrameXML/WorldMapFrame.lua:58-167`，
  **唯一权威**，不是猜的）：
  · 基础层：`WorldMapDetailTile1..12` ← `Interface\WorldMap\<图>\<图><i>`，每块 256×256，从
    `WorldMapDetailFrame`（**1002×668**）的 TOPLEFT 起 **1:1** 铺成 4×3 = **1024×768**（右下被帧裁掉 22 / 100）。
  · 区域层：`GetMapOverlayInfo(i)` 给 (name,w,h,ox,oy)，按 256 网格切块；`SetTexCoord(0, 像素/2的幂, …)`
    —— **分母与文件实际尺寸无关** ⇒ 高清包（文件更大）能对上的**唯一不变量 = 分数区不变**。
  · ⇒ 逐块：算 (pw,ph,pwFile,phFile) → 裁 HD 文件的 `(pw/pwFile, ph/phFile)` 分数区 → 缩放到 2×pw × 2×ph
    （HD 内容就是原生的 2 倍；已实测 512×512 ↔ 256×256）→ 贴到 **2× 帧空间**（2004×1336）。
  · ⇒ 出图 1500×1000（比例恰 = 1002:668）⇒ 与实景**共用同一条基线** `{1002,668,0,0}`，逐像素对齐。
- ★**画法 = 基础瓦片打底 + 区域块叠上去** = 游戏里「全探索」时的真实画面（`unrealMap.lua`：没探索画基础、
  探索后叠区域）。**基础层 12/12 恒齐全、恒 100% 不透明** ⇒ 区域块缺几块也**不会出现空洞**。
- ★★★**验收判据（艾尔文森林，用户点名的第一张）**：把「基础层」与「区域块层」叠起来 —— 两套**互相独立**的
  来源在**水系 / 山脉 / 湖泊 / 地名标注**上**逐特征对齐** ⇒ 证明用的就是客户端在跑的那套 UV 口径。
  ★**离线的数值判据不适用**：UnrealMap 是**重绘**（不是放大），与客户端自带美术的逐像素 NCC ≈ 0.1
  ⇒ 「对齐」只能靠**层间自洽**与目视（`tmp/unrealmap_piece_cmp.js` 只能证明「哪种映射不是它」，不能当验收）。
- **工具链**：`tmp/gen_mappaint.js`（拼图出图 / `--all` 出全部 / `--dry` 只报覆盖率）·
  `tmp/gen_mappaintdata.js`（生成基线表，源 = **磁盘上的 JPG** ⇒ 表与素材永不失配）·
  `tmp/unrealmap_coverage.js`（纯读：哪些图有货、基础瓦片齐不齐）· `tmp/verify_paintdata.js`（闸门）。
- **覆盖范围如实**：**41 张**区域图；UnrealMap 没有的那 11 张自定义图（Hyjal / Lapidis / Gillijim / TelAbim /
  Gilneas / Icepoint / BlackstoneIsland / ThalassianHighlands / GrimReaches / Northwind / Moonwhisper）
  **回落到客户端自己的地图**（`paintBase` = nil ⇒ 本图不接管，同一条「表里没有这张图 ⇒ 一个字节都不碰」）。
  主城 / 大陆图两档都不接管（沿用既有口径）。
- ★★★**代码结构（动它先看这条）**：两档**共用同一套**渲染 / 编辑 / 接管守护 / 写后自证代码，
  只在**四处**按模式分派 —— **基表 · 贴图前缀 · 补偿根 · 伪区域名**，且一律走这五个口（**唯一分派点**）：
  `MDQ.frameBase(file)` / `MDQ.framePath(file)` / `MDQ.frameSrcOf(file)` / `MDQ.frameArea()` / `MDQ.frameTile()`
  （另有 `frameMode()` = 行为闸门、`frameTblName()` / `frameSrcName()` / `frameLabel()` = 文案一处拼）。
  ★**行为闸门一律读 `MDQ.frameMode()`，绝不读 `jpgMode()`**（后者只表示「实景那一档」）；
  harness 有一条**反向钉**守着「闸门不许退回 `jpgMode`」。
- **切换写口 = `MDQ.layerSet(mode, quiet)`（唯一）**，四条纪律缺一不可（顺序即判据）：
  ① **先 `release` 再换真值**（反了 = 旧档几何留在池位上 = 「切了没反应」）② 会话态清零（选中集 / 逐块隐藏 /
  悬停 / 闪光 / 数量缓存 / 渲染账 / 每图一次播报门）③ 不新增常驻（`beatSync` 按需）④ **立刻刷一拍**
  （`editViewApply`，当场生效不用 `/reload`）。**补偿数据一个字不动**（两档各有各的根）。
- **入口两处（同一个写口）**：`/erm` 面板里**两行并列的单选勾**（`ermUI.marks[3]` = 实景 · `[4]` = 彩绘；
  勾态每次由 `cfgPanelRefresh` 按真值重画，点已勾着的那一颗 = 忽略）+ 命令 `/erm 图层 实景|彩绘`。
  ★面板高度 = **派生量**（`ERM_PW, ERM_PH = 430, 348`）—— 加行必须一起加，否则底部文字与关闭按钮重叠。
- ★★★**第三处入口 = 世界地图顶栏那颗快捷按钮（0.2.1；用户：「右侧加个按钮，样式跟『缩小』一模一样」）** ——
  截图里他红杠标的就是客户端自己的 `WorldMapZoomOutButton`（顶栏「缩小」）。**六条口径**（改它先看这六条）：
  ① **样式 = 客户端模板**：`CreateFrame("Button", "ERM_MAPBTN", 宿主, "UIPanelButtonTemplate")` —— 它就是
     `WorldMapZoomOutButton` 的 `inherits`（`FrameXML/UIPanelTemplates.xml:18`：Up/Down/Disabled 三张
     `UI-Panel-Button-*` + Highlight + `GameFontNormal`）⇒ **逐像素同款、一张贴图都不用自己带**；
     模板拿不到 ⇒ 退回裸按钮 + `ermFont` 字体串（fail-open：样式朴素总好过没有入口）。
  ② **宿主 = `WorldMapFrame`（全屏地图帧）、锚点 = `WorldMapZoomOutButton`（两件事分开）**：
     ★**绝不挂 `UIParent`**（在案：开全屏地图会隐藏 `UIParent` ⇒ 挂它的帧开着地图时一个像素都不渲染）；
     位置 `SetPoint("LEFT", zoom, "RIGHT", 10, 0)`、尺寸 **110×22**（与「缩小」同）。
  ③ **显隐 = 总开关 ∧ 「缩小」按钮显示着**：包住「缩小」的 `OnShow`/`OnHide`（`MDQ.mapBtnHook`：**先存旧的处理体、
     调用时先原样调它**再 `mapBtnSync` —— 项目纪律「绝不覆盖别人的处理体」）⇒ **不挂节拍、不常驻、不包别的脚本**；
     `MDQ.mapBtnZoomOK()` 判「缩小」在不在，**判不出 ⇒ 返回 true 不拦**（fail-open）。
     ★总开关关着必须收起：那一刻插件不画地图，写「切换到彩绘」就是骗人。
  ④ **文案 = 「点一下会发生什么」**：`MDQ.mapBtnTarget()` = 当前档的另一档；`mapBtnLabel()` 取
     `ERM_MAPBTN_TO_PAINT` / `ERM_MAPBTN_TO_JPG`。★真值只有 `MDQ.layerMode()` 一处 ⇒
     **唯一重画口 `MDQ.mapBtnSync()`**（文案 + 显隐），调用点四处 = 载入期(VLA) / `layerSet` / `fogSet` /
     「缩小」的 OnShow·OnHide ⇒ 按钮上写的永远等于真值，**绝不靠按钮自己那份状态**。
  ⑤ **点 = 走唯一写口**：`OnClick` 先 `wfEcho()` 盖章（用户点界面 = 他主动问的，回显必须可见）再
     `pcall(MDQ.layerSet, MDQ.mapBtnTarget())` + `mapBtnSync`；**反向钉守着「不许直接写 `ERM_CFG.layerMode`」**。
  ⑥ **拿不到就如实降级**：宿主 / 锚点缺席 ⇒ `mapBtnEnsure()` 返回 nil（**不报错**），入口只剩面板与命令，
     下次 `layerSet`/`fogSet` 再试 = 自愈；只读自证 = `/erm 状态` 的「顶栏快捷按钮=… ｜ 文案=… ｜ 缩小按钮=…」。
  ★**实现纪律**：**不新增文件级 local**（主 chunk 局部量有上限）⇒ 句柄与七个口全挂 `MDQ`
  （`mapBtn` / `mapBtnTarget` / `mapBtnLabel` / `mapBtnTip` / `mapBtnZoomOK` / `mapBtnHook` / `mapBtnEnsure` / `mapBtnSync` / `mapBtnLine`）。
  ★**对象守卫一律 `mapBtnObj`（type 为 table/userdata），绝不写 `~= nil`** —— 真跑 harness 当场抓到过
  （`b.ermText ~= nil` 在本客户端/保真桩上会读到非 nil ⇒ 紧接着 `index a function`）。
- ★★★**「顶栏按钮点了没反应」这一族 = 四条固定收口（0.2.2；用户报障「重复点击只有第一次生效」）** ——
  四条都是**静默失败**族（一条都不会报错、`luacheck` 一个字不报），以后动这块先看它们：
  ① ★★★**渲染抛错绝不许被 `pcall` 吞**：`MDQ.tick` 的两拍（节流 + 逐帧重申）与 `MDQ.editViewApply`
     （切完图层当场刷那一拍）**都要接住 err** 并调 `MDQ.renderErrSay(err)` ——
     旧写法裸 `pcall(MDQ.renderCurrent, …)` 吞掉之后，**地图永远停在上一次画好的那一张上**，
     而聊天框一个字都没有 ⇒ 现象与「按钮坏了 / 点了没反应」**完全一致**。
     `renderErrSay` 口径 = **同一条错误只出声一次**（`MDQ.renderErrSeen` 去重，不刷屏）+ 走**不门控**的
     `EVAL_SAY_FORCE`（0.2.8：取证环已删；被「调试日志」挡下就成「地图卡住且不吭声」）。
  ② ★★★**「本图两档都不接管」必须说出来**（唯一判据 `MDQ.mapBtnMapIn(mode)`：true / false / **nil = 判不出**）：
     大陆图 / 主城图 / UnrealMap 没有的那 11 张自定义图，切图层**画面一个像素都不会变**（有意为之）。
     ⇒ 点击回显**追加一行** `ERM_MAPBTN_NOMAP`（`mapBtnTip` 里按同一判据 append 一行；
     ★行数组里**不许有 nil**，只在确定 `== false` 时才 append）。
     ★依据 = 本项目「看不懂的现象必须出声」：不说这一句，「本来就不会变」与「按钮坏了」无从分辨。
  ③ ★★★**按钮必须抬到地图件之上**（`MDQ.mapBtnRaise`：`SetFrameLevel(host:GetFrameLevel() + 30)`，
     **由 `mapBtnSync` 每次重抬一遍** —— 客户端给地图件的层级是**动态值**，写死绝对常数会被压住；
     在案症状 = 「看得见却点不到」，范式 = 宿主 `DataSearch` 的 `dsMapIconRaise`）。
  ④ ★★★**点击**回显**（0.2.2 建 · ★0.2.9 按用户指令大幅收缩）**：用户「子插件 以上日志清理下」点名删掉了
     那两行长诊断（`顶栏按钮：点击 ⇒ 目标=… ｜ 切换前=… ｜ 已切换 ｜ 现在=… ｜ build=…` 与
     `　上一拍渲染：… ｜ 写 X / 跳 Y ｜ 写的对象=userdata… ｜ 来源=… ｜ 自证：… ｜ 显示中非我们: <6 个瓦片名>`）。
     **现在点击只留一行** = `layerSet` 的档名行（`世界迷雾·图层类型 = **<档>**`）+ 只在「本图这一档不接管」时
     追加的 `ERM_MAPBTN_NOMAP` 那一行。★保留这一行短回显的理由 = 项目 1.75.60r 那条尺子（删干净就分不清
     「点了没反应」与「按钮坏了」）；★要看那些账 = 敲 `/erm 图层 自证`（只读、你问它答），**不再每次点击都跑
     `MDQ.selfProbe()`**（旧版那两行每次点击都要写哨兵 alpha + 枚举一遍 region）。
  ★**未结案**：上面几条是「点了没反应」这一族**已证实的缺陷面**；真凶仍待真机确认
  （见 `CHANGELOG.md` 0.2.2 末段）。
- ★★★**「切图层 = 同一个纹理对象、只换贴图」（0.2.3；用户点名：「理论上…不需要重复创建一个新的纹理对象?」）** ——
  三条口径，缺一条就退回「每次切档新建一个对象」的老毛病：
  ① **`MDQ.release` 只 `Hide`，绝不清 `MDQ.own[k]` / `MDQ.ownSet[t]`** —— 1.12 没有销毁纹理的 API，
     对象本来就常驻；句柄丢了**没有任何好处**：`texAt` 只能靠 `_G["WorldMapOverlay<n>"]` 按名字找，
     而这个客户端里按名字找纹理**不可靠** ⇒ 找不到就 `CreateTexture` **再建一个**（每切一次多一个常驻对象），
     找回来则走 `"existing"` 分支 ⇒ `origGrab(1, tex, "pool")` **把我们自己的纹理当成客户端的池位抓原值**。
     ★反向钉守着「`release` 里不许再出现清句柄/身份账那两行」。
  ② **写后自证「贴图真的换了」**：写完读回 `tex:GetTexture()`，必须含**本档**的目录标记
     （唯一来源 `MDQ.framePathMark()`：`WorldMapJpg` / `WorldMapPaint`）；
     **读不到 ⇒ 判不出 ⇒ 一个字节都不动**（本客户端读回不可靠是在案的）；
     **读到了却是另一档** ⇒ 这次 `SetTexture` 没生效 ⇒ **丢旧对象、换新对象重写一次** + 出声一次（带读回原文）。
     ★**只对 `how ~= "existing"`（我们自建的对象）动手**；客户端的池位一个字都不许碰。
     计数 `MDQ.texSwapBad` / `MDQ.texSwapFixed` 会出现在顶栏按钮的点击回显里。
  ③ **判据 = `tmp/erm_layer_harness.js` L 组**：收层后句柄/身份账还在 · 切档 `newN == 0` 且同一个对象 ·
     自建对象不进原值账（对 `origGrab(n==1)` 装探针，必须 0 次）· 正常路径 `texSwapBad == 0`（不误报）·
     塞一个「`SetTexture` 无效」的假对象 ⇒ **必须抓到并自愈**。
- ★★★**「我们写的那个纹理到底上屏了没」= 只读探针 `/erm 图层 自证`（0.2.4）** —— 真机日志已排除「点击没进来 /
  写口没切 / 没渲染」三件事（三次点击全进、真值每次都翻、每拍都写 1 块）之后，**只剩「写到了不被渲染的句柄上」**；
  而这件事**用 `GetTexture()` 读回判不了**（本客户端对这批纹理读不到 —— 0.2.3 的写后自证只会得到「判不出」，
  不误报但也抓不到）⇒ 唯一在本项目真机验证过的判法是**哨兵 alpha**（`dupKill` 那套）：
  往我们那一拍的句柄写哨兵 ⇒ 逐条读 `WorldMapDetailFrame:GetRegions()` 的 alpha ⇒
  **跟着变的那几条 = 与我们共享同一张底层纹理 = 屏幕上那一个** ⇒ **立刻还原基线**。
  ★**三种结论分档**：已上屏 / **根本没上屏** / 判不出；★两条如实边界写进输出（`GetTexture` 读不到、
  透明度 < 1 时 alpha 读回会被缩放 ⇒ 只当线索）。★**只读硬约束**：探针段里不许出现
  `SetTexture` / `.Hide` / `.Show` / `.SetPoint`（反向钉守着）。★新增累计计数 `MDQ.madeN`（本会话建过几个对象）。
- ★★★**「写没写 / 写的哪个对象 / 它在不在屏幕上」（0.2.5 建 · ★0.2.9 已从点击回显里删除）** ——
  ★**0.2.9 起那第二行不再打**（用户「子插件 以上日志清理下」点名删掉点击的那两行长诊断）：
  要看这四件事请敲 **`/erm 图层 自证`**（同一个 `MDQ.selfProbe()`，只读、你问它答）。
  ★下面记的是**当年为什么必须加它**（判据本身仍然有效，只是**出口从「每次点击」变成「你问它答」**）——
  用户追问「难道没记住实景的这个图层吗?」，
  而旧那行日志证明不了三件事（每一件都能让画面一动不动）：① **「渲染 1 块」≠「真的写进去了」**
  （`n=1` 只表示这一拍有 1 块，真写没写看 `MDQ.wroteN` / `MDQ.skipN`）；② **「写进去了」≠「写的就是屏幕上那一个」**；
  ③ 读回贴图路径在本客户端常常读不到。⇒ 点击回显**第二行**固定给出：
  `　上一拍渲染：<图> ｜ N 块 ｜ 写 X / 跳 Y ｜ 写的对象=<id> ｜ 来源=<created|existing|own> ｜ 自证：<结论>`；
  ★**`<id>` 地址不变 = 真的记住了那个图层**；★`自证` 由**唯一实现 `MDQ.selfProbe()`** 现场给出（读基线 → 写哨兵 →
  逐条读 `GetRegions()` → **立刻还原**），`/erm 图层 自证` 与点击回显**共用同一份**（绝不各写一套）；
  结论里带**读回贴图路径**（读得到时是最硬证据，读不到就写「读不到」）。★首行还带 `build=`（一眼判「跑的是哪一份代码」）。
- ★★★**真凶定案：切图层必须「换一个新纹理对象」（0.2.6；本客户端对同一对象的二次 `SetTexture` 不刷新图像）** ——
  真机读数把**写入侧全部排除干净**：两次是**同一个对象**（地址一样，句柄确实记住了）· 每拍 **`写 1 / 跳 0`**（真写了）·
  切彩绘后 **`读回=…/media/WorldMapPaint/Elwynn`**（贴图真的换了）· **`自证：上屏=是`**（对象确实在屏幕上）——
  **画面却一动不动** ⇒ 只剩一种解释：**这个客户端的渲染器对「同一个纹理对象」不会重新上传图像**；
  它只在 ① **显隐真正跨帧变过一次** 或 ② **换了一个新对象** 时才重传。★「第一次成功」正对上 ①：那一次 `release`
  确实把它 `Hide` 过；之后每次都是**同一帧里** `Hide` 完又 `Show`（`release` → 紧接着 `editViewApply` 原地重画）⇒
  客户端根本没「看到」它被藏过。⇒ 新增 **`MDQ.dropOwnForSwitch()`**：把我们自建的纹理**当场 `Hide`、从
  `MDQ.own`/`ownSet` 摘掉、同名全局也摘掉**（★只在 `rawget(_G, nm) == t` 时摘 —— 客户端的池位一个字都不碰），
  **由 `layerSet` 排在 `release` 之后调用**（**顺序即判据**）。★与 0.2.3 那条**不矛盾**：`release`（关开关/收层）
  **保持复用**（稳态每拍零写），**切图层**才换对象。★自证里多点名「显示中但不是我们那条」的名字（最多 6 个）。
  ★★★**0.2.7 补记（本条只是「一种解释」，别再当定案引用）**：上面那套「不重传图像」是**从读数反推的**，
  **真机没有复验过**（复验 = 换对象后画面到底变不变）；用户随即提了**更可能是真因**的一条并直接下令落地 ——
  「**切到别的区域时是怎么重设贴图纹理的?应该不会每次都创建新的纹理对象吧?**」⇒ 查代码的结论：
  **换区域（签名变）根本不新建对象**（`MDQ.tick` 只在换图那一拍武装爆发窗；`texAt(1)` 走 `existing` 分支
  对**同一个对象**再 `SetTexture`）而画面照旧跟着换 ⇒ 「同对象二次 `SetTexture` 不刷新」这条**至少对换文件名不成立**；
  两个场景**唯一的差别就是文件名**（换区域 = 文件名变；换图层 = 只有目录变、文件名逐字相同）⇒
  这才是 0.2.7 改名（`_re` / `_cn`）的由来。★★★**已真机验收（2026-10-11，用户原话「功能正常了」）**：
  **改名即真解** ⇒ 0.2.6 那条「同对象不重传图像」**作废、别再当定案引用**（真因 = 同名不同目录）。

## 7. 「原始图」的**合成整区 JPG** 口径（0.2.9 建 · ★0.2.11 已换回逐区域逐块，见 §8）

> ★★★**0.2.11 起：「原始图」这一档的实现 = 逐区域逐块**（`MapOverlayData.lua` + `MapOverlayOffset.lua` + `media\WorldMap`，见 §8）。
> 下面这份「合成整区 JPG」的记录、素材（`media\WorldMapSource`，53 张 / 22.6 MB）与全套生成器/闸门**都保留在案**，
> 但**当前不可达**（保功能、不删）。要回到这条路 = `layerMode` 认回 `LAYER_SRC` + `.toc` 换回 Source 那两行。

- **它是什么**（用户原话：「地图图层切换内再添加个类型**原始图**」）：素材 = `media\WorldMapSource\<图>_src.jpg`
  —— **不是外部素材**，而是**把客户端自己的地图美术合成成一张完整整图**：
  ① 基础底图 = `Interface\WorldMap\<图>\<图>1..12`（4×3×256 行优先，从帧左上 1:1 铺、右下被 1002×668 帧裁掉）；
  ② 区域块 = `media\WorldMap\<图>\<区域><块号>.blp`，位置 = `MapOverlayData.lua` 表值 + `MapOverlayOffset.lua` 补偿
  （与运行期 `editFinal`/`editSize` **同一套算式**）⇒ 画面 = **游戏里「全探索」时的完整地图**（53 张全覆盖，
  有底图 ⇒ 不像单靠区域块只有 ~50% 覆盖）。
- ★★★**归档优先级 = 硬判据**：TurtleWoW 的美术分散在 `Data1\{interface,patch,patch-2…patch-9,patch-Z}.mpq`，
  **后面的覆盖前面的**（客户端就这么加载）⇒ 抽素材必须取**优先级最高**那个归档里的那一份。
  自证 = `node tmp/wmsrc_base_tiles.js [--kind base|area]`（`--plan` 打每个文件落在哪个归档，`--go` 才抽，落
  `tmp/wmsrc_base` / `tmp/wmsrc_area` + `_manifest.json`）。实测：底图 53 张全 12/12（patch-9 474 + patch-Z 162）、
  区域块 1019/1019（patch-Z 656 + patch-9 363）；★patch-Z 那 656 块区域块与 interface 版**逐字节全不同**。
- **工具链**：`tmp/wmsrc_base_tiles.js`（抽）· `tmp/gen_worldmapsource.js`（合成；`--trace` 逐块对照 ·
  `--audit` 配对基准审计 · `--nocomp` A/B · `--base-only` 诊断）· `tmp/gen_worldmapsourcedata.js`（基表）·
  `tmp/verify_worldsourcedata.js`（闸门 53↔53）· `tmp/wmsrc_ab_diff.js`（A/B 量化）。
- ★★★**BLP 解码器的 `alphaDepth` 映射（踩过坑，别改回去）**：`tmp/blp2png.js` 原先把 `alphaDepth=1` 当 DXT3
  ⇒ 按 16B/块读越界（`Received 32776`）⇒ **12 块底图整块解不出来、静默算「缺块」**（底图只贴上 6/12）。
  正确：**`0/1 ⇒ DXT1`（8B/块；1 = 带 1-bit alpha）· `4 ⇒ DXT3` · `8 ⇒ DXT5`**；
  判据脚本 = `node tmp/blp_alphadepth_survey.js`（**`mip0 长度 ÷ 块数` 反推真实块大小**，1043 个 BLP 实测：
  1019 个 alphaDepth8/16B + 24 个底图 = 12×alphaDepth0/8B + 12×alphaDepth1/8B）。
- ★**补偿基线 = 空表（有意）**：这一档的补偿**已经烘进合成图像素**（用的就是 `MapOverlayOffset.lua`）⇒
  活增量从零开始（存 `EH_REALISTICMAP_CFG.editSrc`），`MapOverlayOffsetSource.lua` 是**空基线占位**
  （读口拿到空表 = 与另两档同形状，一处也不用特判）。★**欠账**：烘基线的 `gen_mapoffset.js --src` **尚未实现**。
- **判据**：`node tmp/verify_worldsourcedata.js`（53 键 ↔ 53 文件 · 基线恒 `1002,668,0,0` · 文件名必须带 `_src` ·
  覆盖 ⊇ 实景 52 ⊇ 彩绘 41，比另两档多 `Balor`）· `node tmp/gen_worldmapsource.js --audit`
  （**补偿配对基准与现表逐条相符 632/632、0 不符** —— 这条同时是「偏移量的基准就是 MapOverlayData」的机器判据）。
- **入口三处**：`/erm` 面板第三行并列单选（`ermUI.marks[5]`；面板高度是派生量 348 → **374**）·
  `/erm 图层 原始图`（别名 `layer src` / `图层 原图`）· **顶栏按钮三档循环**（实景 → 彩绘 → 原始图；
  定序只在 `MDQ.mapBtnTarget` 一处，档名三处同源 = **`MDQ.layerNameKey(mode)`**）。

## 8. 临时关档 / 「原始图」回归（2026-10-11 / 0.2.10 → 0.2.11）

- ★★★**0.2.11（用户：「切换原始图功能调整到采用 MapOverlayOffset.lua MapOverlayData.lua media\WorldMap 内的贴图载入模式…
  现在将这个功能在增加回来」）**：**「原始图」= `MDQ.LAYER_ART`（`"art"`）**，路 = **逐区域逐块**（搬迁前那条已验证的路）：
  `MapOverlayData.lua` 定位 + `MapOverlayOffset.lua`/存档补偿（根 = `edit`）+ `media\WorldMap\<图>\<区域><块号>`（自带优先 → 客户端）。
  · **唯一判据口 = `MDQ.artMode()`**；`frameMode()` 对它为 false ⇒ 渲染走 `MDQ.render`（不是 `jpgRender`）。
  · **0.2.9 的 `"src"`（合成整区 JPG）并入本档**：读口/写口双口归一 + VLA 一次性迁移出声。
  · **四个接线口**：`layerMode`（白名单 + `artMode`）· `layerSet`（不再拒绝）· `editTbl`→`EDIT_ROOT_ART` · `editFileTbl`→`EVAL_MAP_OVERLAY_OFFSET`。
  · **入口同源**：面板第三行（`marks[5]`）· 顶栏三档循环 · `layerNameKey` · `/erm 图层 原始图`（`图层 彩图`/`layer art` = 别名）。
  · **素材/表**：`media\WorldMap`（1020 .blp / 44.8 MB）· `MapOverlayData.lua` · `MapOverlayOffset.lua`（后两份**已进 `.toc`**）。
- ★**当前仍临时关闭的只剩「图层彩绘」一档**（用户 2026-10-11 第一轮：「图层切换功能只保留实景，其他两个功能临时关闭。保留功能」）。
- ★★★**0.2.12（用户：「WorldMapSource 这个先不要对接(这个数据不准).原始图面就是你上面刚完成恢复的数据集贴图」）**：
  **「原始图」只走数据集贴图这一条路**（§7 那条合成整区 JPG **不平移进来**）—— 三件事：① `.toc` **撤下**
  `MapOverlaySourceData.lua` / `MapOverlayOffsetSource.lua`（文件留磁盘，只是不载入）；② `tmp/pack_subaddons.ps1` 把
  `media/WorldMapSource` 列进**不发货清单**；③ 三语 `TB_SM_LAYER_SRC_TIP1` 改口（旧文案还在说「合成整区图」= 会误导）。
  ★`"src"` 旧 id 的就地归一**保留**（那是存档 id 迁移，不是对接 WorldMapSource）。★放回 = toc 加两行 + 打包清单去掉 + `layerMode` 认回 `LAYER_SRC`。

## 8c. 「越切越卡」排查与修 A（0.2.13）

- **主嫌 A**：`layerSet` 每次切档都调 `MDQ.dropOwnForSwitch` ⇒ 丢 N 个句柄 + 全局名 ⇒ 下一拍 `texAt` **重建 N 个对象**
  （N = 本图块数；「原始图」档几十个），1.12 无销毁 API ⇒ 旧对象只 `Hide`、**永远在 `GetRegions()` 枚举里**。
- **修法**：常量 **`MDQ.SWAP_OBJ_ON_SWITCH = false`** 挡住那句（**改 `true` = 一个字回退**）；函数本体保留。
  ★依据 = 0.2.7 已实测「改名才是真解」（0.2.6「必须换新对象」已推翻）。
- **真机取证（2026-10-11 17:5x，Ioiol/LochModan/实景档）**：`/erm perf` 两拍 **0.0 ms**（写 1 / 写 0 跳过 1）、
  `perfGuard=false`、`/erm 图层 自证` 报 **本会话新建对象 4 个**（⇒ 实景档**无泄漏**，A 只在多块档放大）、
  护守 `枚举 33 / 已隐藏 32 / 显示中 1（我们的）/ 活句柄 29 / 在枚举里 0 / 盲=否`。
  ★自证报「枚举 68 / 显示中非我们 35 条」= 底图瓦片等（**两个枚举口径不同**，不是矛盾）。
- **待真机验收**：切到「原始图」档、换 3~5 张多块图，再看 `本会话新建对象`（应**不再**每切一次跳一批）。
- ★★★**0.2.14（F，用户：「F…这个也试下」）**：① **`MDQ.texAt` 建对象改「匿名优先」** —— 旧写法用客户端的池位名
  （`WorldMapOverlay<n>`）建我们的纹理 ⇒ 撞名（「原始图」档建到几十号，撞面最大）；现在匿名建、只按 `own[n]`/`ownSet[t]`
  记账，**不占任何全局名**（匿名建不出来才退回具名 = fail-open）。② **`MDQ.dropOwnForSwitch` 里那句 `rawset(_G, nm, nil)` 已撤**
  —— 它抹的正是客户端自己也用的池位名（给「常量改回 true」那条路留的保险：只 `Hide`，不动名）。
  ★`existing`（复用客户端池位）那条分支**保持不变**（只写几何、不夺名）。
- ★**仍未动**：B（枚举/藏账累积）· C（`dupKill` 按块数）· D（爆发窗整批重写）。
- **崩溃取证（只读，供参考）**：`Crashes\UECC-…C1FCDBCA…_0000`（16:39:21，0.2.11 时代）= `EXCEPTION_ACCESS_VIOLATION`、
  **访问类型=执行**、故障地址**不在任何模块内**、`bIsOOM=0`；其前 4 帧与 **2026-10-08 那三条历史崩溃逐帧相同**
  （而那时「原始图」档还不存在）⇒ 该族**先于本功能存在**，证据不足以归因本插件。

## 8d. 0.2.16：**「原始图」也关掉了**（只留区域实景）+ 未使用图层不进包

- 用户：「先关闭原始图功能.不调试了. 然后子插件打包的时候记得不要将没使用的图层数据打包进去」。
- `MDQ.LAYER_OFF` 现在 = `{ [LAYER_PAINT]=true, [LAYER_ART]=true }` ⇒ **只留「区域实景」**；恢复 = 去掉 `[LAYER_ART]` 一项。
- 打包不发货清单 = `_v` / `Textures` / `WorldMapJpg\_city` / `WorldMapSource` / **`WorldMap`** / **`WorldMapPaint`**。
- `.toc` 撤下 `MapOverlayData` · `MapOverlayOffset` · `MapOverlayPaintData` · `MapOverlayOffsetPaint`（文件都在磁盘上）。
- ★**未结案**：A/F/G 三个修复在代码里但**真机从未验证**（buildTag 一直 0.2.12）⇒ 下次要调，先 `/reload` 看 `build=` 再测。

## 8b. 临时关闭那一套（0.2.10 建，机制保留）

用户原话：「图层切换功能**只保留实景**，其他两个功能**临时关闭**。**保留功能**」。

- ★★★**唯一开关 = `MDQ.LAYER_OFF`**（`EH_RealisticMap.lua`，就在 `MDQ.srcMode` 那一行下面）：
  `{ [MDQ.LAYER_PAINT] = true }`（0.2.11 起只剩彩绘一档）—— **删掉它 / 改成 `{}` = 恢复**（代码一字未删）。
  判据口 = **`MDQ.layerOn(mode)`**（实景恒 true；表里点名 = 关）。
- **三处配套，缺一条就是「关不干净」或「静默降级」**：① `MDQ.layerMode()` 对被关的档**按实景走**（读口兜底）；
  ② `MDQ.layerSet()` 排在白名单之后**如实拒绝**（打印 `ERM_LAYER_OFF` 带档名，**绝不静默切到别档**）；
  ③ `MDQ.mapBtnTarget()` 只把开着的档排进循环 + `MDQ.mapBtnLabel()` 在没有可切档时返回 `ERM_MAPBTN_OFF`。
- **面板那两行不用另外动**：`MDQ.cfgPanelRefresh` 的勾态**每次按 `MDQ.layerMode()` 真值重画**（`marks[3..5]`），
  被关的档永远不是当前档 ⇒ **自动收起**（这是「勾选状态由数据重算」那条 idiom 换来的收益）。
- **恢复清单（一条就够）**：删 `MDQ.LAYER_OFF` ⇒ 读口 / 写口 / 顶栏循环与文案 / 面板三行**同时**回来；
  三语两键（`ERM_LAYER_OFF` / `ERM_MAPBTN_OFF`）可以留着（不再被引用，无副作用）。
- ★**素材与打包不受影响**：`media\WorldMapPaint` · `media\WorldMapSource` 仍随子插件打包（临时关闭 ≠ 删除）。

## 1. 本插件是什么

- **世界迷雾（S_WorldMap 表驱动全渲染）** + **接管守护**（原生探索层全藏 + 按表自绘 + 每拍查数量/存在性）
  + **残留图层清理**（切到没有探索层数据的图 ⇒ 把上一张图的 `WorldMapOverlay*` 全藏，切回来再全还）
  + **两档整区图层（2026-10-11 起）**：**区域实景**（`media\WorldMapJpg\`，52 张 AI 地形实拍拼接）与
    **图层彩绘**（`media\WorldMapPaint\`，41 张游戏重绘风格图，素材派生自 UnrealMap）—— **并列可切换**，
    都铺满 1002×668 帧、都写 `OVERLAY` 绘制层；默认档 = **开 + 区域实景**
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

- `ADDON_NAME = "EH_RealisticMap"` · `ADDON_TAG` · `MDQ.BUILD = "0.2.17"` —— 版本号**只此一处**（+ `.toc`）。
- **顶栏快捷切换按钮的锚点（0.2.1 建 · 0.2.2 收口）**：句柄 `MDQ.mapBtn` · 口 `MDQ.mapBtnTarget /
  mapBtnLabel / mapBtnTip / mapBtnMapIn / mapBtnZoomOK / mapBtnHook / mapBtnRaise / mapBtnEnsure /
  mapBtnSync / mapBtnLine` · 渲染错误出口 `MDQ.renderErrSay` · 帧名 `ERM_MAPBTN` · 模板
  `UIPanelButtonTemplate` · 宿主 `WorldMapFrame` / 锚点 `WorldMapZoomOutButton` · 三语键 `ERM_MAPBTN_*`（8 个）。
- **三档图层的锚点（2026-10-11）**：`MDQ.LAYER_ART / LAYER_JPG / LAYER_PAINT = "art" / "jpg" / "paint"` ·
  `MDQ.layerMode()`（**白名单式**：只认 src/paint/jpg，其余按 jpg）· `MDQ.jpgMode()` / `MDQ.paintMode()` / **`MDQ.srcMode()`** /
  `MDQ.frameMode()`（**行为闸门**）· 五个分派口 `frameBase / framePath / frameSrcOf / frameArea / frameTile` +
  三个文案口 `frameTblName / frameSrcName / frameLabel` · 伪区域名 `MDQ.JPG_AREA = "_JPG"` / `MDQ.PAINT_AREA = "_PAINT"` ·
  档后缀 **`MDQ.JPG_SUF = "_re"`**（实景）/ **`MDQ.PAINT_SUF = "_cn"`**（彩绘）/ **`MDQ.SRC_SUF = "_src"`**（原始图）—— **只在** `MDQ.jpgPath` / `MDQ.paintPath` / `MDQ.srcPath` 三处拼 · 切换写口 `MDQ.layerSet(mode, quiet)` · 基表 `EVAL_MAP_OVERLAY_JPG_DATA` / `EVAL_MAP_OVERLAY_PAINT_DATA` / `EVAL_MAP_OVERLAY_SOURCE_DATA` ·
  补偿根 `MDQ.EDIT_ROOT_JPG = "editJpg"` / `MDQ.EDIT_ROOT_PAINT = "editPaint"` / **`MDQ.EDIT_ROOT_SRC = "editSrc"`** ·
  文件基线 `EVAL_MAP_OVERLAY_OFFSET_JPG` / `EVAL_MAP_OVERLAY_OFFSET_PAINT` / **`EVAL_MAP_OVERLAY_OFFSET_SOURCE`**（空基线，见 §7）。
  ★**档名三处同源**：面板行名 / 顶栏按钮文案 / 按钮提示里的档名一律取 **`MDQ.layerNameKey(mode)`**（加档只改这一处 + 三语键）。
- ★★★**0.2.11：第三档「原始图」= `MDQ.LAYER_ART`（`"art"`）** —— `MDQ.artMode()`（唯一判据）· `layerMode()` 白名单（旧 id
  `"src"` 就地归一成 `"art"`）· `editTbl` → `EDIT_ROOT_ART`（`"edit"`）· `editFileTbl` → `EVAL_MAP_OVERLAY_OFFSET`（`MapOverlayOffset.lua`）·
  `frameMode()` = **false**（走 `MDQ.render` 逐区域逐块）· 数据表 `MapOverlayData.lua`（53 图 / 707 区）·
  贴图 `media\WorldMap\<图>\<区域><块号>`（自带优先 → 客户端 `Interface\WorldMap`）· `srcMode()` 只剩旧 id 兼容（恒 false）。
- 存档代理：`cfgLive()` / `ERM_CFG` → `EH_REALISTICMAP_CFG`；键 = `importedV1` / `swmOverlay` / `staleClean` /
  `layerMode` / `editMode` / `edit` / `editJpg` / **`editPaint`** /
  `cacheCleared51` / `probeCleared52` / `mapFitMode` / `texPack`(已清) / `buildTag` / **`logCleared28`**。
- ★★★**0.2.8「日志整族已删除」**（用户：「子插件: 实景地图 将日志清理下」+ 选定「连取证环一起删」）：
  **删掉了** `fogLog` / `fogSay` / `fogSayV` / `chatGateOn` / `verboseOn` / `ERM_TRACE_MAX`、全部**自动上屏的播报**（12 处）、
  以及五个有界落盘环（`trace` / `staleLog` / `editLog` / `perfProbe` / `fitDiag`）与只服务它们的口
  （`staleLogPut/Get` · `editLogPut/N` · `fitDiagPut` · `MDQ.fitBattery` · `objLine` · `/erm 自检` · `/erm 详细 on|off` · 面板 `[详细]` 按钮）。
  **保留**：命令/按钮回显（`say` + `ECHO_AT` 窗口）· **`renderErrSay` 一行**（走不门控的 `EVAL_SAY_FORCE`，真实故障必须出声）·
  全部**只读探针命令**（残留/检查/贴图/图层/重复/alpha/编辑/状态/perf）。
  ★**存档死键一次性清理** = 载入期 `ERM_CFG.logCleared28` 块（清 `trace`/`staleLog`/`editLog`/`perfProbe`/`fitDiag`）。
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
主城 4 键**不许**在表里）· ★**`node tmp/verify_paintdata.js`**（41 键 ↔ 41 张顶层 JPG · 基线恒 `1002,668,0,0` ·
键集合 ⊆ 实景表 · 不许有子目录；`exit 1` = 有失配）· ★**`node tmp/verify_worldsourcedata.js`**（第三档「原始图」：53 键 ↔ 53 张 `<图>_src.jpg` · 基线恒 `1002,668,0,0` ·
文件名必须带 `_src` · 覆盖 ⊇ 实景 52 ⊇ 彩绘 41）· ★**`node tmp/erm_layer_harness.js`**（两档图层 + 顶栏快捷按钮的行为 + 接线：
**181 条 Lua 行为断言 + 55 条源码钉**，含 14 条反向钉：闸门不许退回 `jpgMode` · 面板不许退回只读标签 ·
按钮不许挂 `UIParent` · 按钮不许自己造节拍 · OnClick 不许绕过唯一写口 `layerSet` · **渲染那两拍不许退回裸 pcall 吞错** · **`release` 不许再清自建纹理的句柄/身份账** · **图层自证必须只读**）· `node sync_game.js` + `node tmp/verify_sync.js`。

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
- ★**0.2.11 新增欠账**：`gen_mapoffset.js` 的**存档源**还是宿主时代那套（在 `Account\<账号>\SavedVariables\EvalHelp.lua` 里找
  `worldFogCfg.edit`），而 0.2.11 起补偿真值是**本插件自己的** `EH_REALISTICMAP_CFG.edit`（`EH_RealisticMap.lua` 存档文件）
  ⇒ **产物路径已改对（进子插件目录）、存档源仍是旧的** ⇒ 烘焙前必须先核这两个名字（下一轮统一推送时改掉）。
- ★**0.2.11 过期断言**：`tmp/swm_harness.js` 的 AUDIT 还在要求**宿主** `EvalHelp.toc` 里必须有 `MapOverlayData.lua`/
  `MapOverlayOffset.lua`（0.2.11 起这两份在**子插件** `.toc` 里）⇒ 统一推送那轮一并重指。
- `tmp/ver_check.js` / `tmp/ver3_check.js` / `tmp/verify_version3.js` 三个旧版本脚本也指着 `tools/WorldFog.lua`
  （现行版本闸门 = `tmp/rel_version_check.js`：**宿主两处 + 每个子插件 toc ↔ 源码 build 常量**）。
- ★**契约 ① 的第 5 处（judged harness）已补上（2026-10-11）**：`tmp/erm_layer_harness.js` =
  本插件第一个 harness（两档图层 + 顶栏快捷按钮：**181 条 Lua 行为断言 + 55 条源码钉**，真源码 + 真语言包 + 真数据表 + 保真桩）。
  ★**欠账**：这个 harness **没有配套的 `*_mutate.js`**（本项目「闸门要自证不是装饰」那条）⇒ 统一推送那轮补一个变异套件。
  ★★**0.2.9 新增欠账**：该 harness **还没覆盖第三档「原始图」**（`LAYER_SRC` / `srcMode` / `srcPath` / `layerNameKey` /
  顶栏三档循环 / 面板第三行 / `EDIT_ROOT_SRC`）⇒ 统一推送那轮补断言 + 反向钉（「加档只许加在四个分派口里」）。
  ★★**0.2.9 第二条欠账**：`gen_mapoffset.js --src`（把 `EH_REALISTICMAP_CFG.editSrc` 烘成 `MapOverlayOffsetSource.lua`）**尚未实现**
  ⇒ 在那之前「原始图」这一档只有活增量、没有可发出去的基线。
  ★它的**写法铁律**（下次扩它必读）：`MDQ` / `ERM_CFG` 都是**模块文件内的 local** ⇒
  ① 断言必须与真源码**拼进同一个 chunk**；② 拼法 = `return (function() <真源码> return (function() <断言> end)() end)()`
  —— **Lua 的 chunk 不会隐式返回最后一个表达式的值**（写成 `(function()…end)()()` 会静默丢掉返回值，
  本次当场踩过：JS 侧拿到 nil、`to_jsstring` 抛 `expects a Uint8Array`）；
  ③ 断言里读写真值只能走**全局** `EH_REALISTICMAP_CFG`（`ERM_CFG` 是代理，跨 chunk 看不见）；
  ④ Lua 片段里**不许出现反引号**（会截断 JS 模板字面量 ⇒ `node tmp/check_backticks.js` 守着）。
