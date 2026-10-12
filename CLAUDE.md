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
| `MDQ.BUILD` = 宿主版本 | **`MDQ.BUILD` = `0.2.22`**（== 本目录 `.toc` 的 `## Version`），与宿主版本**解耦** |

> ★★★**2026-10-11 新增「图层彩绘」与「原始图」（三档并列可切换；**现行状态 = 只留区域实景**，见 §6 与 §7）** —— 这一档是**新东西**，不在搬迁映射表里：
> 用户原话「**新建个图层类型:图层彩绘,和实景图层并列可切换**」。素材/数据/生成器/闸门见 §3 与 §4；
> **几何口径与验收**见本文件 §6。

## 6. 三档图层（区域实景 / 图层彩绘 / 原始图）—— 口径 · 锚点 · 验收

> ★★**现状（0.2.20 起）：「区域实景」+「图层彩绘」两档在用**，只关「原始图」（`MDQ.LAYER_OFF = { [MDQ.LAYER_ART] = true }`）——
> **代码 / 素材 / 基表 / 生成器一个字节都没删**，恢复清单见 §7。下面各档口径仍然有效（放回来就按它跑）。

- **三档各是什么 / 素材在哪**：① **区域实景** = `MDQ.LAYER_JPG`（`media\WorldMapJpg\<图>_re.jpg`，**60 张 = 52 张 AI 地形实景 + 8 个主城键**（0.2.22：`ThunderBluff`/`Darnassis`/`Darnassus` 用**原实景主城图**（500~834 px，上采样偏软）；`Stormwind`/`Ogrimmar`＋`Orgrimmar`/`Ironforge`/`Undercity` 用**彩绘图的同名副本** ⇒ 这 4 座在实景档显示彩绘图，**副本改动要跟着重生成**）；**本地/仓库就是 jpg**，出包时才转 tga）；② **图层彩绘** = `MDQ.LAYER_PAINT`（`media\WorldMapPaint\<图>_cn.jpg`，**49 张、全部 1500×1000**（主城那 8 个键 0.2.22 起统一规格）= 41 区域图（派生自 UnrealMap 的 HD 地图：12 块基础瓦片打底 + 区域块叠加）+ 8 个主城键**（0.2.21；6 张主城图 + `Ogrimmar/Orgrimmar`、`Darnassis/Darnassus` 两组别名副本；母版 PNG 在 `_city\` 不发货））；③ **原始图** = `MDQ.LAYER_ART`（0.2.11 起 = **逐区域逐块**：`MapOverlayData.lua` 定位 + `MapOverlayOffset.lua` / 存档补偿 + `media\WorldMap\<图>\<区域><块号>`，**自带优先 → 客户端 `Interface\WorldMap`**；`frameMode()` 对它为 false ⇒ 走 `MDQ.render` 而不是 `jpgRender`）。三档都铺满 `WorldMapDetailFrame`（**1002×668**）、都写 **`OVERLAY`** 绘制层（同组内优先级最高）、各自独立保存编辑补偿。
- ★★★**素材口径（0.2.20 用户修正，以这条为准）**：**本地开发 / 仓库 = `.jpg`**（客户端能吃 jpg，用户实测）· **分发包 = TGA type-10 RLE**（启动器丢 jpg ⇒ 只有 TGA 能到玩家手上）· **散装 BLP 不可用**：
  · **依据（三组对照，同批 52 张图、同一台机）**：`A` TGA **type-2 未压缩** ⇒ **不出图**（与宿主 1.75.62 的「大图会画成斜条纹」一致）· `B` **TGA type-10 RLE** ⇒ **出图**（杜隆塔尔实景照片）· `C` **BLP2 DXT5** ⇒ **不出图**（52 区全灭，含 256×256 pow2「客户端自带切片重编」的对照组 ⇒ 不是尺寸也不是内容问题）。
  · **真根因（0.2.20 修正）**：**启动器安装时按白名单丢 `.jpg`** ⇒ 包里有、玩家机器上没有 ⇒ `probeTrust` 判「没有」⇒ **不接管** ⇒ 永远看到客户端默认图。★0.2.18 在这里写过「客户端只能解 BLP/TGA、jpg 读不出来」——**那句是错的**（用户本地实测 jpg 能载入；当时安装目录里根本没有那些图，把「文件不在」错读成「格式不支持」）。★同批被推翻的还有宿主记忆体里「插件目录的散装 `.blp` 确实能被载入」（依据是同血统 `templates.xml`；本插件实测 **52 区三组全灭**）。
  · **`.jpg` 的定位 = 只作原始素材**（转换源，**不进包**，留在 `media\WorldMapJpg\` 顶层）；产物 `<图>_re.tga` = 逐张**原生尺寸、不缩放不裁切**（1500×~1000），TGA `24bpp · imageType=10 · 描述符 0x20（top-left）· 像素 BGR`。
  · **生成器 = `tmp/erm_tga_gen.js`**（两步：`tmp\erm_test_decode.ps1` 出 BGRA → 本脚本出 TGA）；**自证 = 独立解码器解回逐字节等于源图**（RLE 无损 ⇒ 不许只拿 PSNR 糊过去），52/52 通过。★**尺寸代价如实 = 197.6 MB**（未压缩 223.2 MB ⇒ RLE 只到 **89%**）。
  · ★★**换素材协议**：本客户端**贴图跨 `/reload` 存活**（文件删了都照旧画）⇒ 换过素材必须**重启客户端**再判，`/reload` 不够。
- **三档图层锚点清单一处列全**：`MDQ.LAYER_ART / LAYER_JPG / LAYER_PAINT` · `MDQ.layerMode()`（**白名单式**：只认这三个 + 旧 id 兼容，其余按 jpg）· `MDQ.layerOn(mode)` · `jpgMode()` / `paintMode()` / `srcMode()` / **`artMode()`** / `frameMode()`（**行为闸门**）· 五个分派口 `MDQ.frameBase` / `MDQ.framePath` / `MDQ.frameSrcOf` / `MDQ.frameArea` / `MDQ.frameTile` · 文案口 `frameTblName / frameSrcName / frameLabel` / `layerNameKey(mode)`（**档名三处同源**：面板行名 / 按钮文案 / 按钮提示）· 伪区域名 `MDQ.JPG_AREA = "_JPG"` / `MDQ.PAINT_AREA = "_PAINT"` / `MDQ.SRC_AREA` / `MDQ.SRC_TILE` · 档后缀 **`MDQ.JPG_SUF = "_re"` / `MDQ.PAINT_SUF = "_cn"` / `MDQ.SRC_SUF = "_src"`** · 路径口 `MDQ.jpgPath` / `MDQ.paintPath` / `MDQ.srcPath`（+ `srcPfx` / `srcTbl` / `srcBase`）· 基表 `EVAL_MAP_OVERLAY_JPG_DATA` / `EVAL_MAP_OVERLAY_PAINT_DATA` / `EVAL_MAP_OVERLAY_SOURCE_DATA` · 补偿根 `MDQ.EDIT_ROOT_JPG = "editJpg"` / `EDIT_ROOT_PAINT` / `EDIT_ROOT_SRC = "editSrc"` · 文件基线 `EVAL_MAP_OVERLAY_OFFSET_JPG` / `_PAINT` / `_SOURCE` · 写口 `MDQ.layerSet(mode, quiet)` · 编辑器根 `MDQ.editTbl` / `MDQ.editFileTbl`（**两个口必须一起改**，否则「存档读 A、文件读 B」= 补偿串味）。
- ★★★**三档素材的**文件名必须带档后缀**（0.2.7；用户定：「将所有纹理名称重命名一下后缀加一个 _cn 代表中文纹理. 实景后缀 _re」）：运行期路径**只在三处**拼（`jpgPath` / `paintPath` / `srcPath`），写进 `SetTexture` 的路径**不带扩展名**。★**理由**：本客户端**贴图缓存按名存活** —— 两档原本同名不同目录（`WorldMapJpg\Elwynn` 与 `WorldMapPaint\Elwynn` 逐字相同）⇒ 画面一动不动；改名后**真机验收「功能正常了」**（0.2.6 那条「同对象二次 `SetTexture` 不重传图像」**已作废、别再当定案引用**）。★**改档后缀要一起改四处**：两个 Lua 常量 · 生成器里的 `SUF` · 两个闸门的正则 · 出图脚本的产物名；★生成器与闸门都把「文件名必须带档后缀」做成判据（不带 ⇒ 打印文件名 + `exit 1`，绝不生成一张与文件对不上的表）。
- ★★★**几何口径 = 客户端自己的 FrameXML**（`tmp/mpq_out/Interface/FrameXML/WorldMapFrame.lua:58-167`，**唯一权威，不是猜的**）：基础层 `WorldMapDetailTile1..12` ← `Interface\WorldMap\<图>\<图><i>`，每块 256×256、从帧 TOPLEFT **1:1** 铺成 4×3 = 1024×768（右下被裁 22 / 100）；区域层 `GetMapOverlayInfo(i)` 给 (name,w,h,ox,oy) 按 256 网格切块、`SetTexCoord(0, 像素/2的幂, …)` —— **分母与文件实际尺寸无关** ⇒ 高清包唯一的不变量 = **分数区不变**（逐块：算 (pw,ph,pwFile,phFile) → 裁 HD 的 `(pw/pwFile, ph/phFile)` 分数区 → 缩放到 2×pw × 2×ph → 贴到 2× 帧空间）。⇒ 出图 1500×1000（比例恰 = 1002:668）⇒ 与实景**共用同一条基线** `{1002,668,0,0}`，逐像素对齐。★**验收判据** = 「基础层」与「区域块层」两套**互相独立**的来源在**水系 / 山脉 / 湖泊 / 地名标注**上逐特征对齐 ⇒ 证明用的就是客户端在跑的那套 UV 口径。★★**离线的数值判据不适用**：UnrealMap 是**重绘**（不是放大），与客户端自带美术的逐像素 NCC ≈ 0.1 ⇒ 「对齐」只能靠**层间自洽**与目视（`tmp/unrealmap_piece_cmp.js` 只能证明「哪种映射不是它」，**不能当验收**）。
- ★★★**「区域地图」出图（2026-10-12 全量重出 41 张，`media\WorldMapPaint\*.jpg` 已换代）—— 六条硬事实，全部现读自证，别再猜**：
  ① **叠层块是「带 alpha 形状」的贴图**（实测 Elwynn 的 Stormwind 块 26.4% 全透明 + 20.0% 半透明、Goldshire 块 45.5% + 35.6%；41 图叠层平均透明率 30~86%）⇒ 必须**按 alpha 混合**到基础瓦片上，直接覆盖会把透明区画成黑块；基础瓦片那 12 块**全不透明**（alpha 恒 255）。
  ② **几何表只能用游戏那份** `<AddOns>\unrealMap\MapOverlayData.lua`（pfUI `pfMapOverlayData` 血统，41 张 ⇒ 与彩绘表**逐键相同**）；子插件自带的 `MapOverlayData.lua`（`EVAL_MAP_OVERLAY_DATA`，Mozz `LibMapOverlayData` 血统，53 张）**数值不同**（Elwynn `EASTVALELOGGINGCAMP` 237×190 vs 256×210）⇒ **两份绝不可互换，也不许拿 B 当 A 的退路**。自证 = 按 A 表出图时 41 张的块清单与包里文件**逐块吻合（0 缺件）**、每块文件尺寸 = **2×2^ceil(log2(逻辑))** 全中；按 B 表算则大批判尺寸/缺件。
  ③ 块号 **行优先**（piece = 行×wide + 列 + 1；实测反推：横切那块「窄而高」`DeadmansCrossing2 = 256×512`、竖切那块「宽而扁」`…3 = 512×256`）；取 HD 文件**左上角** (2×逻辑) 像素贴到 2 倍帧空间 (2×偏移) 处 —— **不缩放**（分数 UV = 逻辑/2的幂，与文件实际尺寸无关）。
  ④ 包里的 BLP = **BLP2 · comp=2 · alphaDepth=8 ⇒ DXT5（16 字节/块）**，但 **mip0 数据起点 = 1172 而不是 148**（1470 个文件实测全如此）⇒ 解码一律读 `mipOffsets[0]`（偏移 20），**不许写死 148**。
  ⑤ `Battlegrounds\AlteracValley` 那 8 个叠层块**尺寸不按 2×2^ceil(log2) 口径、且 alpha 全 0（空占位）** ⇒ 只记 NOTE、不当缺件（AV 实际 = 12 块基础瓦片）。
  ⑥ 出图口径 = 2 倍帧空间 **2004×1336 → 1500×1000**（比例恰 = 1002:668）⇒ 铺满帧 @0,0，基线仍 `{1002,668,0,0}`（`MapOverlayPaintData.lua` 一个字都不用改）。
  判据 = `node tmp/gen_mappaint.js --dry` ⇒ **41 张全 ✔（基础 12/12 · 0 缺件 · 0 尺寸异常）**；`node tmp/img_dim_check.js` ⇒「41 张全 1500×1000 + 命名带 `_cn` + 无子目录」（**不许用 `$x = & magick identify …` 这类「抓原生命令输出」的写法核对 —— 本会话实测在那个沙箱里会静默拿到空串**，一律让 node 自己读文件头，或让 magick 直接写文件）。★与 0.2.x 那批旧图**只差锐度**（内容与位置逐特征一致：平移搜索最优解 = (0,0)、Durotar 均差 3.4%）—— 旧图偏软（同内容降到 375×250 再比仍差 6.7% ⇒ 不是纯重采样噪声）⇒ 新一批按文档口径保留 2 倍细节，**更锐是有意的**。
  ★★**本地直接用这批 `.jpg`**（0.2.20：客户端能吃 jpg）· **出包时才转 TGA type-10 RLE 并只把 TGA 打进 zip**（启动器丢 jpg ⇒ 只有 TGA 能到玩家手上）—— 见本文件「素材口径」那条；转换在 `tmp/pack_subaddons.ps1` 里跑（`--out=%TEMP%`，仓库不动）。
- ★★★**代码结构（动它先看这条）**：三档**共用同一套**渲染 / 编辑 / 接管守护 / 写后自证代码，只在**四个口**按模式分派 —— **基表 · 贴图前缀 · 补偿根 · 伪区域名**。★**行为闸门一律读 `MDQ.frameMode()`，绝不读 `jpgMode()`**（后者只表示实景那一档）—— harness 有一条**反向钉**守着。★**切换写口 = `MDQ.layerSet(mode, quiet)`（唯一）**，四条纪律缺一不可（**顺序即判据**）：① **先 `release` 再换真值**（反了 = 旧档几何留在池位上 = 「切了没反应」）② 会话态清零（选中集 / 逐块隐藏 / 悬停 / 闪光 / 数量缓存 / 渲染账 / 每图一次播报门）③ 不新增常驻（`beatSync` 按需）④ **立刻刷一拍**（`editViewApply`，当场生效不用 `/reload`）。**补偿数据一个字不动**（各档各有各的根）。
- **入口三处（同一个写口）**：① `/erm` 面板里**并列单选勾**（`ermUI.marks[3]` 实景 · `[4]` 彩绘 · `[5]` 原始图；勾态每次由 `cfgPanelRefresh` **按真值重画**，点已勾着的那颗 = 忽略）② 命令 `/erm 图层 实景|彩绘|原始图`（别名 `layer art` / `图层 彩图` / `图层 原图`）③ **世界地图顶栏快捷按钮**（★0.2.20 起 = **三态**：关着 ⇒ 开启实景 · 实景 ⇄ 彩绘）。★**面板高度是派生量**（`ERM_PW, ERM_PH = 430, 374`）—— 加行必须一起加，否则底部文字与关闭按钮重叠。
- ★★★**顶栏快捷按钮（0.2.1 建 · 0.2.2 收口）六条口径**：① **样式 = 客户端模板**（`CreateFrame("Button", "ERM_MAPBTN", 宿主, "UIPanelButtonTemplate")` —— 它就是 `WorldMapZoomOutButton` 的 `inherits` ⇒ 逐像素同款、一张贴图都不用自己带；模板拿不到 ⇒ 退回裸按钮 + `ermFont` 字体串，fail-open）② **宿主 = `WorldMapFrame`、锚点 = `WorldMapZoomOutButton`**（**绝不挂 `UIParent`** —— 在案：开全屏地图会隐藏它 ⇒ 挂它的帧开着地图时一个像素都不渲染）；位置 `SetPoint("LEFT", zoom, "RIGHT", 10, 0)`、尺寸 **110×22**（与「缩小」同）③ ★★**显隐 = 只跟「缩小」显示着**（★0.2.19 改：**不叠加总开关** —— 关着时它还负责「开启实景」，收起来用户就开不回来了）（`MDQ.mapBtnHook` 包住「缩小」的 `OnShow`/`OnHide`：**先存旧的处理体、调用时先原样调它**再 `mapBtnSync`；`MDQ.mapBtnZoomOK()` 判不出 ⇒ 返回 true 不拦 = fail-open）④ ★★★**文案 = 「点一下会发生什么」= 三态**（★0.2.20 用户「WorldMapPaint 将图层切换功能增加回去.支持 WorldMapPaint WorldMapJpg 这两种图层切换」：总开关关着 ⇒「开启实景」· 实景 ⇒「切换到彩绘」· 彩绘 ⇒「切换到实景」；`MDQ.mapBtnWant()` 返 **(动作, 目标)** / `MDQ.mapBtnLabel` / `MDQ.mapBtnTip`；真值只有 `MDQ.swm()` 与 `MDQ.layerMode()` 两处 ⇒ **唯一重画口 `MDQ.mapBtnSync()`**，调用点四处 = 载入期 VLA / `layerSet` / `fogSet` / 「缩小」的 OnShow·OnHide）⑤ ★★★**点 = 两条动作各走各的唯一写口**（`"fog"` ⇒ `MDQ.fogSet(true)`，沿用它的播报 + 「需要 /reload」确认窗 = 1.75.59c 用户点名要的；`"layer"` ⇒ `MDQ.layerSet(mode)`，自 0.2.17 起不打档名播报）—— **绝不直接写 `ERM_CFG`**）⑥ **拿不到就如实降级**（`MDQ.mapBtnEnsure()` 返回 nil、**不报错**，下次 `layerSet`/`fogSet` 再试 = 自愈；只读自证 = `MDQ.mapBtnLine()` 出现在 `/erm 状态` 的「顶栏快捷按钮=… ｜ 文案=… ｜ 缩小按钮=…」）。★**实现纪律**：**不新增文件级 local**（句柄与口全挂 `MDQ`）；★**对象守卫一律 `MDQ.mapBtnObj`（type 为 table/userdata），绝不写 `~= nil`**。
- ★★★**「顶栏按钮点了没反应」这一族 = 四条固定收口**（**全是静默失败**：一条都不会报错、`luacheck` 一个字不报）：① **渲染抛错绝不许被 `pcall` 吞** —— `MDQ.tick` 的两拍与 `MDQ.editViewApply` 都要接住 err 并调 `MDQ.renderErrSay(err)`；口径 = **同一条错误只出声一次**（`MDQ.renderErrSeen` 去重）+ 走**不门控**的 `EVAL_SAY_FORCE`（被「调试日志」挡下就成「地图卡住且不吭声」）② **「本图两档都不接管」必须说出来**（唯一判据 `MDQ.mapBtnMapIn(mode)`：true / false / **nil = 判不出**；点击回显按同一判据 append `ERM_MAPBTN_NOMAP` 一行；★行数组里**不许有 nil**）③ **按钮必须抬到地图件之上**（`MDQ.mapBtnRaise`：`SetFrameLevel(host:GetFrameLevel() + 30)`，**由 `mapBtnSync` 每次重抬一遍** —— 客户端给地图件的层级是**动态值**，写死常数会被压住；在案症状 = 「看得见却点不到」）④ **点击回显** = 开总开关时走 `fogSet` 那两行播报、切档时 `layerSet` 不出声（0.2.17 起）+ 必要时那一行 NOMAP；要看完整账请敲 **`/erm 图层 自证`**（只读、你问它答），**不再每次点击都跑 `selfProbe()`**（旧版每点一次都要写哨兵 alpha + 枚举一遍 region）。
- ★★★**「我们写的那个纹理到底上屏了没」= 只读探针 `/erm 图层 自证`**（唯一实现 **`MDQ.selfProbe()`**，与点击回显**共用同一份**）：判法 = **哨兵 alpha**（往我们那一拍的句柄写哨兵 ⇒ 逐条读 `WorldMapDetailFrame:GetRegions()` 的 alpha ⇒ **跟着变的那几条 = 与我们共享同一张底层纹理 = 屏幕上那一个** ⇒ **立刻还原基线**）。★**三种结论分档**：已上屏 / **根本没上屏** / 判不出。★两条如实边界：`GetTexture` 读回在本客户端**常常读不到**（只当线索）、**透明度 < 1 时 alpha 读回会被缩放**（也只当线索）。★**只读硬约束**：探针段里不许出现 `SetTexture` / `.Hide` / `.Show` / `.SetPoint`（**反向钉**守着）。★新增累计计数 `MDQ.madeN`（本会话建过几个对象）。
- ★★★**「切图层 = 同一个纹理对象、只换贴图」三条口径（0.2.3）**：① **`MDQ.release` 只 `Hide`，绝不清 `MDQ.own[k]` / `MDQ.ownSet[t]`** —— 1.12 没有销毁纹理的 API；句柄丢了只能按名字找，而**这个客户端里按名字找纹理不可靠** ⇒ 找不到就 `CreateTexture` 再建一个常驻对象，找回来则 `origGrab` **把我们自己的纹理当成客户端的池位抓原值**；**反向钉**守着「`release` 里不许再出现清句柄 / 清身份账那两行」。② **写后自证「贴图真的换了」**：写完读回 `tex:GetTexture()`，必须含**本档**的目录标记（唯一来源 `MDQ.framePathMark()`：`WorldMapJpg` / `WorldMapPaint` / …）；**读不到 ⇒ 判不出 ⇒ 一个字节都不动**；**读到了却是另一档** ⇒ 这次 `SetTexture` 没生效 ⇒ **丢旧对象、换新对象重写一次** + 出声一次（带读回原文）。★**只对 `how ~= "existing"`（我们自建的对象）动手**，客户端的池位一个字都不许碰。计数 `MDQ.texSwapBad` / `MDQ.texSwapFixed`。③ 判据 = `tmp/erm_layer_harness.js` L 组（收层后句柄/身份账还在 · 切档 `newN == 0` 且同一个对象 · 自建对象不进原值账 · 正常路径 `texSwapBad == 0` · 塞一个「`SetTexture` 无效」的假对象 ⇒ **必须抓到并自愈**）。
- ★★★**「越切越卡 / 堆损坏」三修（0.2.13 A · 0.2.14 F · 0.2.15 G）—— ★代码里在，真机从未验证**：
  · **A（0.2.13）** = `layerSet` 不再调 `MDQ.dropOwnForSwitch`（新常量 **`MDQ.SWAP_OBJ_ON_SWITCH = false`**；**函数本体保留**）—— 旧写法每切一次丢 N 个句柄 + 身份账 + 全局名（只 `Hide`）⇒ 下一拍 `texAt` 只能重建 N 个全新对象（N = 本图块数，「原始图」档几十个，如 Barrens 84 块），而 1.12 **没有销毁纹理的 API** ⇒ 旧对象永远留在 `WorldMapDetailFrame` 下、**仍在 `GetRegions()` 枚举里** ⇒ 越切越卡。★**改 `true` = 一个字回退**。
  · **F（0.2.14）** = `MDQ.texAt` 建对象改**匿名优先**（旧写法 `CreateTexture(fr, "WorldMapOverlay<n>", …)` 用的是**客户端自己也用的池位名** ⇒ 名字撞车；现在一律匿名建、只靠 `MDQ.own[n]` / `ownSet[t]` 按序号 + 对象身份记账，**不占任何全局名**；匿名建不出来才退回具名 = fail-open）+ **撤掉 `rawset(_G, nm, nil)`**（它抹掉的正是**客户端自己也用的池位名**；现在那里只 `Hide` 我们自己的对象，**一个全局名都不动**）。
  · **G（0.2.15）** = `MDQ.texAt` **不再复用客户端对象**（删掉 `return t, "existing"` —— 旧写法把客户端自己的纹理交给我们写，而它会自己重建/销毁那批对象 ⇒ 我们随后拿旧句柄写 = **use-after-free**；针对真机 `FMallocBinned3 Attempt to free an unrecognized small block` 那条堆损坏）+ **写前复核句柄**（写之前读一次宽高，读不到 ⇒ 丢掉记账、重取一次）+ `dupKill` 的哨兵 alpha **优先写我们自己的对象**。
  · ★**仍未动**：B（每拍枚举 / 原生藏账随访问过的图累积）· C（`dupKill` 随块数放大）· D（爆发窗整批重写）。★**真机取证（0.2.13 当轮，只读）**：`/erm perf` 两拍 **0.0 ms**（写 1 / 写 0 跳过 1）、`perfGuard=false`、`/erm 图层 自证` 报**本会话新建对象 4 个** ⇒ 实景档**无泄漏**（A 只在多块档放大）；护守 `枚举 33 / 已隐藏 32 / 显示中 1（我们的）/ 活句柄 29 / 在枚举里 0 / 盲=否`（★自证报「枚举 68 / 显示中非我们 35 条」= 底图瓦片等，**两个枚举口径不同，不是矛盾**）。★**待真机验收**：切到「原始图」档、换 3~5 张多块图，再看「本会话新建对象」（应**不再**每切一次跳一批）。★**崩溃取证（只读）**：`Crashes\UECC-…C1FCDBCA…_0000`（16:39:21，0.2.11 时代）= `EXCEPTION_ACCESS_VIOLATION`、**访问类型 = 执行**、故障地址**不在任何模块内**、`bIsOOM=0`，其前 4 帧与 **2026-10-08 那三条历史崩溃逐帧相同**（而那时「原始图」档还不存在）⇒ 该族**先于本功能存在**，证据不足以归因本插件。
- **工具链**：`tmp/gen_mappaint.js`（彩绘拼图 / `--all` 出全部 / `--dry` 只报覆盖率）· `tmp/gen_mappaintdata.js`（彩绘基线表，源 = **磁盘上的 JPG** ⇒ 表与素材永不失配）· `tmp/unrealmap_coverage.js`（纯读：哪些图有货、基础瓦片齐不齐）· `tmp/verify_paintdata.js`（41↔41 闸门）· `tmp/gen_mapjpgdata.js` + `tmp/verify_jpgdata.js`（实景 52↔52）· `tmp/gen_mappaint.js` 的基线生成 · `tmp/gen_mapoffset.js --jpg` / `--src`（补偿库）· `tmp/wmsrc_base_tiles.js`（按**补丁优先级**抽底图/区域块）· `tmp/gen_worldmapsource.js`（合成 / `--trace` 逐块对照 / `--audit` 配对基准审计 / `--nocomp` A/B / `--base-only`）· `tmp/gen_worldmapsourcedata.js` + `tmp/verify_worldsourcedata.js`（53↔53）· `tmp/wmsrc_ab_diff.js`（A/B 量化）· `tmp/blp_alphadepth_survey.js`。★另有 `tmp/gen_worldmapsource.js --dry` 的覆盖率体检与 `tmp/gen_mapjpgdata.js` 的「主城 4 图不进表」口径。
  ★★**本机（2026-10-12）已重建的这套**（上面那些 `--all` / `unrealmap_coverage` / `verify_paintdata` / `blp2png` 本机**仍然缺**，在另一台机器上）：`tmp/gen_mappaint.js`（**现行口径**：`--dry` 体检 · `--only A,B` · `--big` · `--mode alpha|opaque`，**默认 alpha**，驱动清单 = `MapOverlayPaintData.lua` 现读、几何 = 游戏那份 `unrealMap\MapOverlayData.lua` 现读）· `tmp/gen_mappaint_jpg.ps1`（PNG→JPG，`-quality 86 -sampling-factor 1x2`，**默认先备份**旧 41 张到 `tmp\_mappaint_bak_<时间戳>\`）· 只读核对 `tmp/img_dim_check.js`（规格/命名/子目录三条腿）· 比对 `tmp/img_diff.js` / `tmp/img_align.js`（平移搜索）· 取证探针 `tmp/umap_blp_scan.js` / `umap_blp_head.js` / `umap_zone_dump.js` / `umap_alpha_probe.js` / `umap_tbl_cmp.js`（最后这个 = A/B 两份几何表的逐条差异，**它就是「两份表不可互换」的机器判据**）。
- ★★★**BLP 解码器的 `alphaDepth` 映射（踩过坑，别改回去）**：`tmp/blp2png.js` 原先把 `alphaDepth=1` 当成 **DXT3** ⇒ 按 16B/块读会越界（报 `Received 32776`）⇒ **12 块底图整块解不出来**（症状 = 底图只贴上 6/12，另 6 块**静默**算作「缺块」）。**正确映射：`0/1 ⇒ DXT1`（8B/块，1 = 带 1-bit alpha）· `4 ⇒ DXT3` · `8 ⇒ DXT5`**；判据脚本 = `node tmp/blp_alphadepth_survey.js`（**`mip0 长度 ÷ 块数` 反推真实块大小**；1043 个 BLP 实测：1019 个 alphaDepth8/16B + 12×alphaDepth0/8B + 12×alphaDepth1/8B）。
- ★★★**归档优先级 = 硬判据**：TurtleWoW 的美术分散在 `Data1\{interface,patch,patch-2…patch-9,patch-Z}.mpq`，**后面的覆盖前面的**（客户端就这么加载）⇒ 抽素材必须取**优先级最高**那个归档里的那一份。自证 = `node tmp/wmsrc_base_tiles.js --plan`（实测：底图 53 张全 12/12 = patch-9 474 + patch-Z 162；区域块 1019/1019 = patch-Z 656 + patch-9 363；★patch-Z 那 656 块与 interface 版**逐字节全不同** ⇒ 用 interface 那版画出来就不是客户端实际显示的那一张）。
- ★**彩绘覆盖范围如实**：**41 张区域图 + 6 张主城（8 键）**（0.2.21 起）；UnrealMap 没有的那 11 张自定义图（Hyjal / Lapidis / Gillijim / TelAbim / Gilneas / Icepoint / BlackstoneIsland / ThalassianHighlands / GrimReaches / Northwind / Moonwhisper）**回落到客户端自己的地图**（`paintBase` = nil ⇒ 本图不接管，同一条「表里没有这张图 ⇒ 一个字节都不碰」）；**大陆图仍不接管**；★**主城两档都接管**（0.2.22 起：实景档 8 主城键 —— 雷霆崖/达纳苏斯用实景图、其余 4 座用彩绘图副本；彩绘档 8 主城键用彩绘图）。
- ★**「原始图」的补偿基线 = 空表（有意）**：`MapOverlayOffsetSource.lua` 是**空基线占位**（读口拿到空表 = 与另两档同形状，一处也不用特判）—— 合成整区那套的补偿**已烘进图像素**（用的就是 `MapOverlayOffset.lua`）；`--audit` 实测**补偿配对基准与现表逐条相符 632/632、0 不符**（这条同时是「偏移量的基准就是 `MapOverlayData`」的机器判据）。★**欠账**：`gen_mapoffset.js --src` **尚未实现**（在那之前这一档只有活增量、没有可发出去的基线）。

## 7. 临时关档机制 + 当前状态（0.2.10 建 · 0.2.11 / 0.2.12 / 0.2.16 收敛）

- 用户三句原话：「图层切换功能**只保留实景**，其他两个功能**临时关闭**。**保留功能**」→「**WorldMapSource 这个先不要对接**(这个数据不准). 原始图面就是你上面刚完成恢复的数据集贴图」→「**先关闭原始图功能.不调试了.** 然后子插件打包的时候记得**不要将没使用的图层数据打包进去**」。
- ★★★**唯一开关 = `MDQ.LAYER_OFF`**（`EH_RealisticMap.lua`，就在 `MDQ.srcMode` 那一行下面）：现在 = `{ [MDQ.LAYER_ART] = true }` ⇒ **「区域实景」+「图层彩绘」两档在用**（0.2.20 用户：「WorldMapPaint 将图层切换功能增加回去」）。**删掉它 / 改成 `{}` = 三档全放回来**（代码一字未删）。判据口 = **`MDQ.layerOn(mode)`**（实景恒 true；表里点名 = 关）。
- **三处配套，缺一条就是「关不干净」或「静默降级」**：① `MDQ.layerMode()` 对被关的档**按实景走**（读口兜底 ⇒ 存档里存着 `paint`/`art` 的老用户不会卡在半状态）② `MDQ.layerSet()` 排在白名单之后、比档之前**如实拒绝**（打印 `ERM_LAYER_OFF` 带档名，**绝不静默降级** —— 静默降级正是本项目最怕的那类失效）③ ★★★**顶栏按钮 = 三态**（0.2.19 建「开启/关闭实景」→ 0.2.20 扩成「开总开关 / 实景⇄彩绘」）：关着 ⇒ `fogSet(true)`；开着 ⇒ `layerSet(另一档)`。★按钮**关着也显示**（`mapBtnSync` 只跟「缩小」走）—— 否则关掉之后再也开不回来。
- **面板那三行不用另外动**：`MDQ.cfgPanelRefresh` 的勾态**每次按 `MDQ.layerMode()` 真值重画**（`marks[3..5]`），被关的档永远不是当前档 ⇒ **自动收起**（这是「勾选状态由数据重算」那条 idiom 换来的收益）。
- ★★★**恢复清单**：删 `MDQ.LAYER_OFF` ⇒ 读口 / 写口 / 面板三行**同时**回来；★**顶栏按钮的语义要重新定一次**（0.2.19 起它是**实景开关**、不再循环 —— 三档回来时「开关 ↔ 循环」二选一，别沿用旧代码）；三语两键（`ERM_LAYER_OFF` / `ERM_MAPBTN_OFF`）可以留着（不再被引用，无副作用）。★另两档的**素材与表**要各补一步：**彩绘** = 去掉 `media/WorldMapPaint` 的不发货项；**原始图** = `.toc` 加回 `MapOverlayData.lua` / `MapOverlayOffset.lua` 两行 + 去掉 `media/WorldMap` 的不发货项。
- ★★★**打包口径（0.2.20 定）**：`tmp/pack_subaddons.ps1` 在**打包这一刻**把两档的 `.jpg` 转成 `.tga`（跑 `tmp\erm_test_decode.ps1` + `tmp\erm_paint_decode.ps1` 出 BGRA，再 `node tmp/erm_tga_gen.js --set=jpg|paint --out=%TEMP%\erm_pkg_tga\…`），**TGA 进包、jpg 不进包**，**仓库一个字节不动**；TGA 数量不足 ⇒ `fail++`（绝不静默发一个没贴图的包）。
  ★**不发货清单** = `_v` / `Textures` / **`WorldMap`**（原始图，1020 .blp / 44.8 MB）/ **`WorldMapSource`**（22.6 MB）/ `WorldMapJpg\_city`（4 张实景主城图）/ **`WorldMapPaint\_city`**（0.2.21 起：6 张主城 PNG 母版）⇒ **两个在用档的顶层素材都进包**（打包时 `*.jpg` → TGA）。★**打包脚本必须逐字节 ASCII**（一个中文注释就让 Windows PowerShell 5.1 按 GBK 读成乱码、赋值行被吃掉 —— 症状 = `Join-Path : Cannot bind argument to parameter 'Path' because it is null.`）。
- ★**`.toc` 现列 8 项**：`Locales\{zhCN,enUS,ruRU}.lua` + `MapOverlayJPGData.lua` + `MapOverlayOffsetJPG.lua` + **`MapOverlayPaintData.lua` + `MapOverlayOffsetPaint.lua`** + `EH_RealisticMap.lua`；另两份（`MapOverlayData` / `MapOverlayOffset`「原始图」那族）**文件都在磁盘上、只是不载入**。★**可逆**：放回 = toc 加回那两行 + `MDQ.LAYER_OFF` 里去掉 `[MDQ.LAYER_ART]`。
- ★★**0.2.9 的 `"src"`（合成整区 JPG）已并入 `"art"`**：读口/写口**双口就地归一** + VLA 一次性迁移（老存档 `"src"` ⇒ `"art"`）**并如实出声一次**（行为改变必须出声）；三语 `TB_SM_LAYER_SRC_TIP1` 已改口（旧文案还在说「合成整区图」= 会误导）。★`media\WorldMapSource\`（53 张 / 22.6 MB）与 `MapOverlaySourceData.lua` / `MapOverlayOffsetSource.lua` **一个字节没删**。

## 1. 本插件是什么

- **世界迷雾（S_WorldMap 表驱动全渲染）** + **接管守护**（原生探索层全藏 + 按表自绘 + 每拍查数量/存在性）
  + **残留图层清理**（切到没有探索层数据的图 ⇒ 把上一张图的 `WorldMapOverlay*` 全藏，切回来再全还）
  + **三档整区图层（2026-10-11 起；★0.2.20 起「区域实景 + 图层彩绘」两档在用**，只关「原始图」）：**区域实景**（`media\WorldMapJpg\`，**60 张**（52 区 + 8 主城键，0.2.22）· **在用**）与
    **图层彩绘**（`media\WorldMapPaint\`，**49 张**（41 区域图 + 6 张主城/8 键）· **在用**）/ **原始图**（逐区域逐块 `media\WorldMap\`）—— 只后者**临时关闭**（`MDQ.LAYER_OFF`，代码素材一字未删，见 §6/§7），
    顶栏按钮在两档之间切换（0.2.20）；
    三档都铺满 1002×668 帧、都写 `OVERLAY` 绘制层；默认档 = **开 + 区域实景**
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

- `ADDON_NAME = "EH_RealisticMap"` · `ADDON_TAG` · `MDQ.BUILD = "0.2.22"` —— 版本号**只此一处**（+ `.toc`）。
- **顶栏快捷切换按钮的锚点（0.2.1 建 · 0.2.2 收口）**：句柄 `MDQ.mapBtn` · 口 `MDQ.mapBtnWant /
  mapBtnLabel / mapBtnTip / mapBtnMapIn / mapBtnZoomOK / mapBtnHook / mapBtnRaise / mapBtnEnsure /
  mapBtnSync / mapBtnLine` · 渲染错误出口 `MDQ.renderErrSay` · 帧名 `ERM_MAPBTN` · 模板
  `UIPanelButtonTemplate` · 宿主 `WorldMapFrame` / 锚点 `WorldMapZoomOutButton` · 三语键 `ERM_MAPBTN_*`（**11 个**；0.2.20 新增 `TURN_ON`）。
- **三档图层的锚点（2026-10-11）**：`MDQ.LAYER_ART / LAYER_JPG / LAYER_PAINT = "art" / "jpg" / "paint"` ·
  `MDQ.layerMode()`（**白名单式**：只认 art/jpg/paint + 旧 id `src` 兼容，其余按 jpg）· `MDQ.jpgMode()` / `MDQ.paintMode()` / **`MDQ.srcMode()`** /
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
- ★★★**0.2.8「日志整族已删除」**：
  **删掉了** `fogLog` / `fogSay` / `fogSayV` / `chatGateOn` / `verboseOn` / `ERM_TRACE_MAX`、全部**自动上屏的播报**（12 处）、
  以及五个有界落盘环（`trace` / `staleLog` / `editLog` / `perfProbe` / `fitDiag`）与只服务它们的口
  （`staleLogPut/Get` · `editLogPut/N` · `fitDiagPut` · `MDQ.fitBattery` · `objLine` · `/erm 自检` · `/erm 详细 on|off` · 面板 `[详细]` 按钮）。
  **保留**：命令/按钮回显（`say` + `ECHO_AT` 窗口）· **`renderErrSay` 一行**（走不门控的 `EVAL_SAY_FORCE`，真实故障必须出声）·
  全部**只读探针命令**（残留/检查/贴图/图层/重复/alpha/编辑/状态/perf）。
  ★**存档死键一次性清理** = 载入期 `ERM_CFG.logCleared28` 块（清 `trace`/`staleLog`/`editLog`/`perfProbe`/`fitDiag`）。
- 默认档归一 / 一次性导入 / 清账 = **`VARIABLES_LOADED` 块**（`ERM_CLEAN` 帧）：
  ★**顺序铁律 = 先 `importHostCfg()` 再「默认档归一」**。
- 面板：`MDQ.cfgPanel{Build,Show,Hide,Shown,Refresh,ChromeLine}` + `ERM_EDITLIST`；
  **边框走项目唯一配方**（§三.10：tooltip 圆角 + `GetBackdrop` 读回自证 + flat 时四边描边 + **圆角时收起自建方底**）。
- 命令：`SLASH_ERM1 = "/erm"` + `SlashCmdList["ERM"]` ⇒ 空/`ui`/`面板`/`状态` 打状态行，其余**原样交给 `MDQ.cmd`**
  （与宿主期 `/ehm mapfit <子命令>` 逐字同义）。未知子命令**如实报 + 摊开用法**，绝不静默。

## 4. 常驻闸门（**只在「统一推送」那轮跑**）

`node luacheck.js` · `node probe_localorder.js`（**本文件已在默认清单里**）· `node scan_dangling.js` ·
`node tmp/subaddon_isolation_probe.js` · `node tmp/subaddon_naming_probe.js` · `node tmp/mem_sep_probe.js`
（豁免 = `importHostCfg` 那一处**纯读**，写点必须 0）· `node tmp/toc_savedvars_check.js` ·
`node tmp/glyph_minus_scan.js`（非注释行 U+2212 一个都不许有）· `node tmp/verify_jpgdata.js`（**0.2.22 起 = 60 键 ↔ 60 张顶层 JPG**（52 区 + 8 主城键），
主城 8 键**必须**在表里（当年那条「主城 4 键不许在表里」的反向断言**已作废**））· ★**`node tmp/verify_paintdata.js`**（**0.2.21 起 = 49 键 ↔ 49 张顶层 JPG**（41 区域 + 8 主城键；主城那两组别名是有意的）· 基线恒 `1002,668,0,0` ·
键集合 ⊆ 实景表 · 不许有子目录；`exit 1` = 有失配）· ★**`node tmp/verify_worldsourcedata.js`**（第三档「原始图」：53 键 ↔ 53 张 `<图>_src.jpg` · 基线恒 `1002,668,0,0` ·
文件名必须带 `_src` · 覆盖 ⊇ 实景 52 ⊇ 彩绘 41）· ★**`node tmp/erm_layer_harness.js`**（两档图层 + 顶栏快捷按钮的行为 + 接线：
**181 条 Lua 行为断言 + 55 条源码钉**，含 14 条反向钉：闸门不许退回 `jpgMode` · 面板不许退回只读标签 ·
按钮不许挂 `UIParent` · 按钮不许自己造节拍 · OnClick 不许绕过唯一写口 `layerSet` · **渲染那两拍不许退回裸 pcall 吞错** · **`release` 不许再清自建纹理的句柄/身份账** · **图层自证必须只读**）· `node sync_game.js` + `node tmp/verify_sync.js`。

## 5. 欠账（搬迁当轮如实记，统一推送时重指）

- ★★★**0.2.18 / 0.2.19 新增欠账（★本机 `tmp/` 是陈旧的 —— 闸门在另一台机器上）**：① `tmp/erm_layer_harness.js` 里那条**反向钉「OnClick 不许绕过唯一写口 `layerSet`」已过期** —— 0.2.19/0.2.20 起按钮：**`MDQ.mapBtnTarget` 已删除** ⇒ **`MDQ.mapBtnWant()` 返 (动作, 目标) 两个值**（`"fog"` ⇒ `fogSet(true)` / `"layer"` ⇒ `layerSet(mode)`）⇒ 统一推送那轮必须重指：删掉旧的「三档循环」「只剩实景时停在实景」「总开关关着就收起」三条断言，改成「三态文案」「关着也显示」「两条动作各走唯一写口」；**另需补「彩绘档在用」那组**（`LAYER_OFF` 只关 art · toc 含彩绘两表 · `layerSet(paint)` 生效）。② 本机**没有** `tmp/erm_layer_harness.js` · `tmp/verify_jpgdata.js` · `tmp/gen_mapjpgdata.js` · `tmp/verify_paintdata.js` · `tmp/gen_mappaintdata.js`（都在另一台机器上；★0.2.21/0.2.22 起：`verify_paintdata.js` 按 **49** 键核、`verify_jpgdata.js` 按 **60** 键核且**主城 8 键必须在表里**（断言方向与旧版相反）、`gen_mappaintdata.js` 与 `gen_mapjpgdata.js`（后者要去掉 `CITY_OFF`）都要能保住那 8 个主城键，否则重跑会把它们冲掉）⇒ 涉及它们口径的改动本机只能做「就地保留素材、不破坏既有 glob」这一档。③ 0.2.18 转 TGA 后，若在另一台机器重跑 `tmp/gen_mapjpgdata.js` / `verify_jpgdata.js`：`.jpg` 原始素材**仍在原地**（所以 `*.jpg` 口径不会失配），但**运行期产物扩展名已是 `.tga`**。

- ★★★**0.2.8~0.2.17 本轮新增欠账（2026-10-11）**：① **「越切越卡 / 堆损坏」三修（A/F/G）在代码里但真机从未验证**（`buildTag` 一直停在 `0.2.12`；用户定「不调试了」⇒ **未结案**，下次要调先 `/reload` 看 `build=` 再测）；② `tmp/erm_layer_harness.js` **未覆盖第三档**「原始图」，且**没有配套 `*_mutate.js`**；③ `gen_mapoffset.js` 的**存档源**仍是宿主时代的 `EvalHelp.lua` 的 `worldFogCfg.edit`（产物路径已改对）；④ 打包口径见 §7「打包口径（0.2.20 定）」那条（TGA 在打包时转、jpg 不进包）。

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
