$ErrorActionPreference = "Stop"

# 用法：
#   . .\scripts\set_env.ps1
# 然后再运行：
#   python test.py
#   python batch_processor.py

# 必填：Token
if ([string]::IsNullOrWhiteSpace($env:SAE_API_TOKEN)) {
  Write-Host "请先设置 SAE_API_TOKEN（必填）。例如：" -ForegroundColor Yellow
  Write-Host "  `$env:SAE_API_TOKEN='你的Token'" -ForegroundColor Yellow
}

# 本地网关（通过 SSH 隧道）
$env:SAE_API_BASE_URL = "http://127.0.0.1:10984"

# 输出目录（你指定的路径）
$env:SAE_OUTPUT_DIR = "E:\Cursor Project\SAE-Extractor\outputs"

Write-Host "已设置：SAE_API_BASE_URL=$env:SAE_API_BASE_URL" -ForegroundColor Green
Write-Host "已设置：SAE_OUTPUT_DIR=$env:SAE_OUTPUT_DIR" -ForegroundColor Green

