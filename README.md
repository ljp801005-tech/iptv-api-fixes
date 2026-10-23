# IPTV-API 修复优化包（Windows GUI 版）

基于开源项目 [Guovin/iptv-api](https://github.com/Guovin/iptv-api)（MIT License）的 Windows GUI 版本（v3.1.0），针对国内 Windows 环境修复了三个常见问题，并内置开箱即用的国内直播源配置。

> 免责声明：本项目不提供任何媒体内容，所有直播源均来自网络公开订阅地址，由第三方提供。请仅用于观看有授权的公开频道。

## 修复了什么

| # | 问题 | 原因 | 修复方式 |
|---|------|------|----------|
| 1 | 测速结果永远为 0 | GUI 版开启了"分辨率过滤"但需要 FFmpeg，未安装时所有接口被误过滤 | `open_filter_resolution = False` |
| 2 | 更新到测速阶段程序崩溃退出 | 中文 Windows 控制台 GBK 编码无法打印 ❌ 等 Unicode 字符，触发 `'gbk' codec can't encode` 致命错误 | 启动脚本注入 `PYTHONUTF8=1`、`PYTHONIOENCODING=utf-8` |
| 3 | EPG 电子节目单拉取失败 | 默认 EPG 源 `e.erw.cc` 已失效 | 更换为两个实测可用的 EPG 源 |

## 内置优化配置

- **5 个实测可用的国内订阅源**（范明明 Live、vbskycn/iptv 双栈、ssili126 酒店源、suxuang/myIPTV），GitHub 访问走 ghfast.top 加速
- `open_unmatch_category = True`：未匹配模板的频道接口不再丢弃，直接输出（大幅增加频道数）
- `open_full_speed_test = True`：每个频道测试所有候选线路
- `min_speed = 0.2`：放宽速率门槛，配合 `open_supply = True` 补偿机制，避免结果为空
- `update_startup = True` + `update_interval = 12`：启动即更新，之后每 12 小时自动更新
- 配套 `start_gui.ps1`：带 UTF-8 环境启动，可注册为开机自启

## 快速开始

1. 从 [iptv-api Releases](https://github.com/Guovin/iptv-api/releases) 下载 `IPTV-API-GUI-Windows-X64-*.zip` 并解压（例如 `C:\IPTV\iptv-api\`）
2. 把本仓库 `config/` 下的 3 个文件复制到解压目录的 `config/` 文件夹，**覆盖同名文件**
3. 双击运行主程序（或用 `scripts/start_gui.ps1` 启动），点击「立即更新」
4. 等待采集+测速完成（10~30 分钟），播放器中添加播放列表地址：
   - M3U：`http://127.0.0.1:5180/m3u`
   - TXT：`http://127.0.0.1:5180/txt`
5. 推荐播放器：[IPTVnator](https://github.com/4gray/iptvnator)、PotPlayer、VLC。在 IPTVnator 中勾选"启动时自动更新"即可每次打开拿到最新频道

### 开机自启（可选）

以管理员 PowerShell 运行：

```powershell
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File <解压路径>\scripts\start_gui.ps1"
Register-ScheduledTask -TaskName "IPTV_API_GUI" -Action $action -Trigger (New-ScheduledTaskTrigger -AtLogOn) -Force
```

## 目录结构

```
├── README.md          # 本文件
├── config/
│   ├── config.ini     # 修复+优化后的主配置
│   ├── subscribe.txt  # 国内订阅源列表
│   └── epg.txt        # 可用 EPG 源
└── scripts/
    └── start_gui.ps1  # UTF-8 环境启动脚本
```

## 致谢

- [Guovin/iptv-api](https://github.com/Guovin/iptv-api) — 核心工具（MIT）
- [iptv-org](https://github.com/iptv-org/iptv)、[vbskycn/iptv](https://github.com/vbskycn/iptv)、[fanmingming/live](https://github.com/fanmingming/live)、[suxuang/myIPTV](https://github.com/suxuang/myIPTV)、[ssili126/tv](https://github.com/ssili126/tv) — 公开直播源
- [4gray/iptvnator](https://github.com/4gray/iptvnator) — 推荐播放器（MIT）
