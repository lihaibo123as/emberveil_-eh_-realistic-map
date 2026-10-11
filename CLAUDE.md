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
| `MDQ.BUILD` = 宿主版本 | **`MDQ.BUILD` = `0.2.7`**（== 本目录 `.toc` 的 `## Version`），与宿主版本**解耦** |

> ★★★**2026-10-11 新增「图层彩绘」（两档并列可切换）** —— 这一档是**新东西**，不在搬迁映射表里：
> 用户原话「**新建个图层类型:图层彩绘,和实景图层并列可切换**」。素材/数据/生成器/闸门见 §3 与 §4；
> **几何口径与验收**见本文件 §6。

## 6. 图层彩绘（`MDQ.LAYER_PAINT`）—— 口径、生成器、验收（2026-10-11）

- **它是什么**：与「区域实景」并列的第二档整区图层 —— 素材 = `media\WorldMapPaint\<图>_cn.jpg`（**41 张**），
  内容 = **UnrealMap**（外部镜像的高清地图包）那套**游戏重绘风格**贴图拼出来的整区图。
- ★★★**两档素材的**文件名必须带档后缀**（0.2.7；用户定：「将所有纹理名称重命名一下后缀加一个 _cn 代表中文纹理.
  实景后缀 _re」）** —— 实景 = `<图>_re.jpg`、彩绘 = `<图>_cn.jpg`；运行期路径**只在两处**拼
  （`MDQ.jpgPath` / `MDQ.paintPath`，常量 `MDQ.JPG_SUF = "_re"` / `MDQ.PAINT_SUF = "_cn"`）。
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
     `renderErrSay` 口径 = **同一条错误只出声一次**（`MDQ.renderErrSeen` 去重，不刷屏）+ 进有界取证环。
  ② ★★★**「本图两档都不接管」必须说出来**（唯一判据 `MDQ.mapBtnMapIn(mode)`：true / false / **nil = 判不出**）：
     大陆图 / 主城图 / UnrealMap 没有的那 11 张自定义图，切图层**画面一个像素都不会变**（有意为之）。
     ⇒ 点击回显**追加一行** `ERM_MAPBTN_NOMAP`（`mapBtnTip` 里按同一判据 append 一行；
     ★行数组里**不许有 nil**，只在确定 `== false` 时才 append）。
     ★依据 = 本项目「看不懂的现象必须出声」：不说这一句，「本来就不会变」与「按钮坏了」无从分辨。
  ③ ★★★**按钮必须抬到地图件之上**（`MDQ.mapBtnRaise`：`SetFrameLevel(host:GetFrameLevel() + 30)`，
     **由 `mapBtnSync` 每次重抬一遍** —— 客户端给地图件的层级是**动态值**，写死绝对常数会被压住；
     在案症状 = 「看得见却点不到」，范式 = 宿主 `DataSearch` 的 `dsMapIconRaise`）。
  ④ ★★★**点击必须留一行可判读的回显**（项目 1.75.60r 那条尺子）：`顶栏按钮：点击 ⇒ 目标=… ｜ 切换前=… ｜
     已切换 / 没切换（写口拒绝）/ 出错 ｜ 现在=… ｜ 上一拍渲染：<图> ｜ N 块 ｜ why` —— 一句话分出三种情形
     （点击没进来 / 写口拒绝 / 渲染没画出来）。★它**落在 `wfEcho()` 窗口内** ⇒「调试日志」关着也看得见。
  ★**未结案**：上面四条是「点了没反应」这一族**已证实的缺陷面**；真凶仍待真机那三行回显确认
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
- ★★★**「写没写 / 写的哪个对象 / 它在不在屏幕上」= 点击回显第二行（0.2.5）** —— 用户追问「难道没记住实景的这个图层吗?」，
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

- `ADDON_NAME = "EH_RealisticMap"` · `ADDON_TAG` · `MDQ.BUILD = "0.2.7"` —— 版本号**只此一处**（+ `.toc`）。
- **顶栏快捷切换按钮的锚点（0.2.1 建 · 0.2.2 收口）**：句柄 `MDQ.mapBtn` · 口 `MDQ.mapBtnTarget /
  mapBtnLabel / mapBtnTip / mapBtnMapIn / mapBtnZoomOK / mapBtnHook / mapBtnRaise / mapBtnEnsure /
  mapBtnSync / mapBtnLine` · 渲染错误出口 `MDQ.renderErrSay` · 帧名 `ERM_MAPBTN` · 模板
  `UIPanelButtonTemplate` · 宿主 `WorldMapFrame` / 锚点 `WorldMapZoomOutButton` · 三语键 `ERM_MAPBTN_*`（8 个）。
- **两档图层的锚点（2026-10-11）**：`MDQ.LAYER_ART / LAYER_JPG / LAYER_PAINT = "art" / "jpg" / "paint"` ·
  `MDQ.layerMode()`（**白名单式**：只认 paint/jpg，其余按 jpg）· `MDQ.jpgMode()` / `MDQ.paintMode()` /
  `MDQ.frameMode()`（**行为闸门**）· 五个分派口 `frameBase / framePath / frameSrcOf / frameArea / frameTile` +
  三个文案口 `frameTblName / frameSrcName / frameLabel` · 伪区域名 `MDQ.JPG_AREA = "_JPG"` / `MDQ.PAINT_AREA = "_PAINT"` ·
  档后缀 **`MDQ.JPG_SUF = "_re"`**（实景）/ **`MDQ.PAINT_SUF = "_cn"`**（彩绘）—— **只在** `MDQ.jpgPath` / `MDQ.paintPath` 两处拼 · 切换写口 `MDQ.layerSet(mode, quiet)` · 基表 `EVAL_MAP_OVERLAY_JPG_DATA` / `EVAL_MAP_OVERLAY_PAINT_DATA` ·
  补偿根 `MDQ.EDIT_ROOT_JPG = "editJpg"` / `MDQ.EDIT_ROOT_PAINT = "editPaint"` ·
  文件基线 `EVAL_MAP_OVERLAY_OFFSET_JPG` / `EVAL_MAP_OVERLAY_OFFSET_PAINT`。
- 存档代理：`cfgLive()` / `ERM_CFG` → `EH_REALISTICMAP_CFG`；键 = `importedV1` / `swmOverlay` / `staleClean` /
  `layerMode` / `editMode` / `edit` / `editJpg` / **`editPaint`** / `editLog` / `staleLog` / `trace` / `perfProbe` / `fitDiag` /
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
主城 4 键**不许**在表里）· ★**`node tmp/verify_paintdata.js`**（41 键 ↔ 41 张顶层 JPG · 基线恒 `1002,668,0,0` ·
键集合 ⊆ 实景表 · 不许有子目录；`exit 1` = 有失配）· ★**`node tmp/erm_layer_harness.js`**（两档图层 + 顶栏快捷按钮的行为 + 接线：
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
- `tmp/ver_check.js` / `tmp/ver3_check.js` / `tmp/verify_version3.js` 三个旧版本脚本也指着 `tools/WorldFog.lua`
  （现行版本闸门 = `tmp/rel_version_check.js`：**宿主两处 + 每个子插件 toc ↔ 源码 build 常量**）。
- ★**契约 ① 的第 5 处（judged harness）已补上（2026-10-11）**：`tmp/erm_layer_harness.js` =
  本插件第一个 harness（两档图层 + 顶栏快捷按钮：**181 条 Lua 行为断言 + 55 条源码钉**，真源码 + 真语言包 + 真数据表 + 保真桩）。
  ★**欠账**：这个 harness **没有配套的 `*_mutate.js`**（本项目「闸门要自证不是装饰」那条）⇒ 统一推送那轮补一个变异套件。
  ★它的**写法铁律**（下次扩它必读）：`MDQ` / `ERM_CFG` 都是**模块文件内的 local** ⇒
  ① 断言必须与真源码**拼进同一个 chunk**；② 拼法 = `return (function() <真源码> return (function() <断言> end)() end)()`
  —— **Lua 的 chunk 不会隐式返回最后一个表达式的值**（写成 `(function()…end)()()` 会静默丢掉返回值，
  本次当场踩过：JS 侧拿到 nil、`to_jsstring` 抛 `expects a Uint8Array`）；
  ③ 断言里读写真值只能走**全局** `EH_REALISTICMAP_CFG`（`ERM_CFG` 是代理，跨 chunk 看不见）；
  ④ Lua 片段里**不许出现反引号**（会截断 JS 模板字面量 ⇒ `node tmp/check_backticks.js` 守着）。
