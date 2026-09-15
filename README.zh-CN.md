# karting-tools-notes

**Kart Data** 的设计文档与界面截图。Kart Data 是一个本地优先、移动端优先的卡丁车赛道现场记录工具，
本仓库同时收录其 **Track Map Notebook** 功能模块的设计。

*[English](README.md)*

> **本仓库不包含应用程序代码。**
> 应用本体在
> [karting-data-recording-website](https://github.com/AlexLiaoooo/karting-data-recording-website)，
> 由 `main` 分支部署到 <https://karting-data-recording-website.vercel.app>。
> Track Map Notebook 模块位于该仓库的 `components/track-map/`。

本仓库的作用，是把设计工作与参考截图备份在一处并便于回看，既不依赖应用仓库，也不依赖某一台本地电脑。

<p align="center">
  <img src="screenshots/2026-09/pfi-map-mobile.png" width="270" alt="PF International 参考赛道图：T1 至 T15 弯角标签、分段图例、起点线与行驶方向箭头">
  &nbsp;&nbsp;
  <img src="screenshots/2026-09/built-in-circuits-mobile.png" width="270" alt="内置赛道选择器，列出 PF International、Whilton Mill、Kart Silverstone、Buckmore Park 与 Clay Pigeon Raceway">
</p>
<p align="center"><em>PF International 参考赛道图，以及内置赛道选择器。截取于 2026-09-10；完整截图清单见下文。</em></p>

## 内容

### `docs/` — 设计笔记

| 文件 | 内容 |
| --- | --- |
| [Track Map Notebook - Architecture.md](docs/Track%20Map%20Notebook%20-%20Architecture.md) | **历史记录，已于 2026-09-09 标记为过时**，见下方「当前状态」。这是 2026-08-15 确认的 Track Map Notebook 设计：产品模型（Track → Layout → marker → visit）、数据模型与 TypeScript 类型、IndexedDB 存储结构与迁移规则、marker 类型、图片处理、备份与恢复、MVP 范围与后续阶段。 |
| [Karting Tools - Idea Backlog.md](docs/Karting%20Tools%20-%20Idea%20Backlog.md) | 当初一并考虑过的另外十二个卡丁车工具构想，含价值与难度评估、明确排除的方向，以及建议的开发顺序。 |

这两份笔记从一个 Obsidian vault 镜像而来，vault 始终是唯一的事实来源。参见[保持文档同步](#保持文档同步)。

**为什么放在这里，而不是放进应用仓库。** 架构笔记描述的是 Kart Data 内部的一个功能模块，放在那份代码旁边本来也说得通；
但 idea backlog 不行——它涵盖十二个彼此独立的工具构想，其中多数与 Kart Data 无关，还包括卡丁车之外的延伸工具。
那是产品层面的规划，不是应用文档。两份笔记之间还互相链接，拆开会让双向的 wikilink 失效。
因此两份都留在这里；本仓库是整个卡丁车工具系列的设计与规划存档，而不只服务于 Kart Data。

### 截图

按拍摄日期归档，而不是直接覆盖。图片本身不带日期，而一张界面已经改过的旧截图，看上去和当前截图并无分别。

#### `screenshots/2026-09/` — 当前

2026-09-10 从线上站点拍摄，移动端视口 390x844，深色主题。

| 文件 | 内容 |
| --- | --- |
| [`home-dark-mobile.png`](screenshots/2026-09/home-dark-mobile.png) | 主页空状态，含语言切换按钮与 Track Library 入口。 |
| [`create-event-modal-mobile.png`](screenshots/2026-09/create-event-modal-mobile.png) | 新建 Event，含已保存的 Track Layout 选择器与 Open-Meteo 气温获取。 |
| [`built-in-circuits-mobile.png`](screenshots/2026-09/built-in-circuits-mobile.png) | 内置赛道选择：PF International、Whilton Mill、Kart Silverstone、Buckmore Park、Clay Pigeon Raceway。 |
| [`pfi-map-mobile.png`](screenshots/2026-09/pfi-map-mobile.png) | PF International 参考赛道图，含 T1–T15 弯角编号、分段图例、起点线、行车方向箭头与中心线长度。 |
| [`map-edit-mode-mobile.png`](screenshots/2026-09/map-edit-mode-mobile.png) | 编辑赛道图模式与 marker 类型选择。编辑与查看是两个独立模式，避免误触移动 marker。 |
| [`interface-chinese-mobile.png`](screenshots/2026-09/interface-chinese-mobile.png) | 简体中文界面。按 `DESIGN.md` 的约定，Event、Session、Run、Track Library 等名词保留英文，外围行文用中文。 |

#### `screenshots/2026-08/` — 历史

2026 年 8 月 14 至 15 日拍摄，即 MVP 上线时的样子。**这些是历史记录，不是当前应用的文档。**
在两组截图之间，应用新增了四条内置赛道、弯角编号与简体中文界面，并重建了 PF International 的赛道图。

| 文件 | 内容 |
| --- | --- |
| [`pfi-default-map.png`](screenshots/2026-08/pfi-default-map.png) | 最初生成的 PF International 赛道图。该图在 2026-08-31 被重建，原因是横向画宽了 1.65 倍，因此这张图上的几何形状应用已不再生成。 |
| [`track-map-session-mobile.png`](screenshots/2026-08/track-map-session-mobile.png) | Session 赛道笔记：上方只读显示永久参考笔记，下方是该 Session 的观察记录与 Better/Same/Worse 结果。图中 marker 的类型是 `CORNER`，该类型现已不存在；赛道图区域仍是占位图，早于正式示意图。 |
| [`theme-dark-mobile.png`](screenshots/2026-08/theme-dark-mobile.png) | 主页深色空状态，早于语言切换按钮与 Track Library 入口。 |
| [`theme-dark-modal-mobile.png`](screenshots/2026-08/theme-dark-modal-mobile.png) | 新建 Event 弹窗，深色主题。 |
| [`theme-light-modal-mobile.png`](screenshots/2026-08/theme-light-modal-mobile.png) | 新建 Event 弹窗，浅色主题。 |
| [`ambient-temperature-mobile.png`](screenshots/2026-08/ambient-temperature-mobile.png) | 新建 Event 时，通过设备定位与 Open-Meteo 自动填入环境温度。 |

## 当前状态

Track Map Notebook 的 MVP 于 2026-08-15 上线，此后该模块持续开发。截至 2026-08-31 的代码，
它已包含五条内置赛道（PF International、Whilton Mill International、Kart Silverstone Grand Prix、
Buckmore Park、Clay Pigeon Raceway）、由赛道几何推导的弯角编号、以弯角阶段与油门刹车输入为主的
marker 分类、完整的简体中文界面、含双指缩放的缩放与平移、Session 叠加层、离线本地存储，
以及包含赛道图片的备份与恢复。

Next Run focus 是被取消，而不是延后：`TrackVisit` 中没有 `focusMarkerIds`，`MarkerObservation`
既没有 `runId` 也没有 `promoteToReference`。Run 级别的观察记录、行车线、GPS 与遥测叠加层均未开发。

> **本仓库中的架构笔记是历史记录，不是当前文档。** 它描述的是 2026-08-15 确认的设计，
> 而实现此后已经变化，最明显的是 marker 类型被整体替换。真正在维护的设计文档，是应用仓库中的
> [`DESIGN.md`](https://github.com/AlexLiaoooo/karting-data-recording-website/blob/main/DESIGN.md)，
> 其中带有变更日志。两者不一致时，以该文档为准。保留这份笔记，是为了记录当初决策的理由；
> 其中的存储设计部分至今仍然准确。

## 保持文档同步

Obsidian vault 是唯一的事实来源。`docs/` 中的副本与 vault 逐字节一致；`.gitattributes` 将
`*.md` 固定为 LF 换行，以免 `core.autocrlf` 在检出时将其改写成 CRLF 而破坏这种一致性。

在 Obsidian 中修改笔记后，提交之前先同步过来：

```powershell
.\scripts\sync-docs.ps1
```

若只想检查 `docs/` 是否已经过时而不改动任何文件（过时则以 `1` 退出，因此可用作提交前检查）：

```powershell
.\scripts\sync-docs.ps1 -Check
```

该脚本只会从 vault 复制到仓库，绝不反向写回，也不会自动提交。若 vault 位置变动，
用 `-VaultPath '<folder>'` 指定新路径。

退出码：`0` 已是最新，`1` 已过时，`2` 未找到 vault。

### 强制执行

[`.githooks/pre-commit`](.githooks/pre-commit) 中有一个纳入版本管理的 pre-commit hook，
它会运行上述检查，并在 `docs/` 落后于 vault 时拒绝提交，使镜像不会因为忘记同步而悄悄偏离。
每个克隆启用一次：

```powershell
git config core.hooksPath .githooks
```

该 hook 只在退出码为 `1` 时阻止提交。如果检查根本无法运行——本机没有 vault、没有 PowerShell、
脚本缺失——它会给出警告并跳过，让提交继续，因为一个仅仅是「用不了」的检查不应当卡住整个仓库。
如需刻意跳过：

```powershell
git commit --no-verify
```

由于笔记是逐字节镜像的，`[[Karting Tools - Idea Backlog]]` 这类 Obsidian wikilink 在 GitHub 上
会显示为纯文本而不是链接。这是刻意的取舍：它让两份副本保持完全一致，同步也就只是一次普通的文件复制。

## 许可

© 2026 Alex Liao。本仓库的全部内容 — 设计笔记、截图以及两个辅助脚本 — 均以
[知识共享 署名 4.0 国际](LICENSE)（CC BY 4.0）许可发布。可自由使用，但须署名。

PF International 的截图中包含由 OpenStreetMap 数据派生的赛道几何，其数据版权归
© OpenStreetMap 贡献者所有，采用 [Open Database License 1.0](https://opendatacommons.org/licenses/odbl/1-0/)。
署名信息已包含在图片本身之中。
