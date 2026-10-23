# 一键配置脚本：把修复配置应用到已解压的 IPTV-API GUI
# 用法: powershell -ExecutionPolicy Bypass -File apply_fixes.ps1 [-Target <IPTV-API-GUI解压目录>]
param(
    [string]$Target = ""
)

$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not $Target) {
    # 自动在常见位置查找
    $candidates = @(
        (Get-ChildItem "C:\IPTV" -Directory -Filter "IPTV-API-GUI*" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName),
        (Get-ChildItem "$env:USERPROFILE\Desktop" -Directory -Filter "IPTV-API-GUI*" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName),
        (Get-ChildItem "$env:USERPROFILE\Downloads" -Directory -Filter "IPTV-API-GUI*" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName)
    ) | Where-Object { $_ }
    if (-not $candidates) {
        Write-Host "未找到 IPTV-API-GUI 解压目录，请先从 https://github.com/Guovin/iptv-api/releases 下载并解压，然后用 -Target 参数指定目录。" -ForegroundColor Yellow
        exit 1
    }
    $Target = $candidates
}

Write-Host "目标目录: $Target"

# 备份原配置
$cfgDir = Join-Path $Target "config"
if (Test-Path $cfgDir) {
    $backup = Join-Path $Target ("config_backup_" + (Get-Date -Format "yyyyMMdd_HHmmss"))
    Copy-Item $cfgDir $backup -Recurse
    Write-Host "原配置已备份到: $backup"
} else {
    New-Item -ItemType Directory -Force -Path $cfgDir | Out-Null
}

# 应用修复配置
Copy-Item (Join-Path $here "config\*") $cfgDir -Force
Write-Host "已应用修复配置: config.ini / subscribe.txt / epg.txt" -ForegroundColor Green

# 复制启动脚本
Copy-Item (Join-Path $here "scripts\start_gui.ps1") $Target -Force
Write-Host "已复制启动脚本 start_gui.ps1" -ForegroundColor Green

Write-Host ""
Write-Host "完成！运行 start_gui.ps1 启动程序，点击「立即更新」即可。" -ForegroundColor Cyan
Write-Host "更新完成后，播放器播放列表地址: http://127.0.0.1:5180/m3u"
