$ErrorActionPreference = "Stop"

# SAE 网关 SSH 隧道（本地 10984 -> 远端 127.0.0.1:10984）
# 用法：
#   powershell -ExecutionPolicy Bypass -File .\scripts\start_tunnel.ps1

$LocalPort = $env:SAE_TUNNEL_LOCAL_PORT
if ([string]::IsNullOrWhiteSpace($LocalPort)) { $LocalPort = "10984" }

$RemoteHost = $env:SAE_TUNNEL_SSH_HOST
if ([string]::IsNullOrWhiteSpace($RemoteHost)) { $RemoteHost = "43.156.240.177" }

$RemoteUser = $env:SAE_TUNNEL_SSH_USER
if ([string]::IsNullOrWhiteSpace($RemoteUser)) { $RemoteUser = "root" }

$RemoteBind = $env:SAE_TUNNEL_REMOTE_BIND
if ([string]::IsNullOrWhiteSpace($RemoteBind)) { $RemoteBind = "127.0.0.1:10984" }

Write-Host "启动 SSH 隧道: 127.0.0.1:$LocalPort  ->  $RemoteHost ($RemoteBind)" -ForegroundColor Cyan
Write-Host "提示：保持此窗口不关闭；要退出请按 Ctrl+C。" -ForegroundColor Yellow

ssh -N -L "$LocalPort`:$RemoteBind" "$RemoteUser@$RemoteHost"

