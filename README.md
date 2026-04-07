# SAE Extractor

将临床文档中的严重不良事件（SAE）信息抽取为结构化 JSON，并批量导出到 Excel。

支持输入格式：

- PDF（文本层优先，必要时自动 OCR 回退）
- TXT
- DOCX（支持 `--fast-docx` 极速模式）
- Excel（`xls/xlsx`，按 Sheet 合并文本）

输出核心字段：

- `sae_term`
- `onset_date`
- `resolution_date`
- `severity_grade`
- `causality`
- `action_taken`
- `outcome`
- `source_file`（批处理自动添加）

---

## 1. 环境要求

- Windows 10/11
- Python 3.9+
- Tesseract OCR（可选但推荐，用于扫描版 PDF）
- Poppler（可选但推荐，用于 PDF OCR 流程）
- 可访问的 OpenAI 兼容网关（本项目默认走本地转发地址）

## 2. 安装

```powershell
cd "E:\Cursor Project\Sae-Extractor"
python -m venv .venv
.venv\Scripts\activate
python -m pip install --upgrade pip
pip install -r requirements.txt
```

## 3. 配置环境变量

最少需要配置 Token：

```powershell
$env:SAE_API_TOKEN="你的Token"
```

常用可选项：

```powershell
$env:SAE_API_BASE_URL="http://127.0.0.1:10984"
$env:SAE_MODEL_ID="doubao-seed-2-0-pro-260215"
$env:SAE_INPUT_DIR="E:\Cursor Project\Sae-Extractor\input_clinical_texts"
$env:SAE_OUTPUT_DIR="E:\Cursor Project\Sae-Extractor\outputs"
```

OCR 工具可选配置：

```powershell
$env:TESSERACT_CMD="C:\Program Files\Tesseract-OCR\tesseract.exe"
$env:POPPLER_PATH="D:\poppler\Library\bin"
```

如果网关在远端，可先开隧道（保持窗口不关闭）：

```powershell
ssh -N -L 10984:127.0.0.1:10984 root@43.156.240.177
```

或使用脚本：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\start_tunnel.ps1
```

## 4. 自检

```powershell
python cli.py self-check
```

或：

```powershell
python test.py
```

## 5. 运行方式

多格式批处理：

```powershell
python cli.py batch
```

仅 PDF 批处理：

```powershell
python cli.py pdf-batch
```

常用参数示例：

```powershell
python cli.py batch --fast-docx --input-dir ".\input_clinical_texts" --output ".\outputs\SAE_Omni_Listing.xlsx"
python cli.py pdf-batch --input-dir ".\input_clinical_texts" --output ".\outputs\SAE_PDF_Listing.xlsx"
```

单条测试（内置样本文本）：

```powershell
python sae_extractor.py
```

## 6. 默认目录

- 输入目录：`input_clinical_texts/`
- 输出目录：`outputs/`

程序会自动创建缺失目录。

## 7. 常见问题

- 未设置 `SAE_API_TOKEN`
  - 先在当前终端设置环境变量后再运行。
- `pdftoppm` 不可用 / Poppler 报错
  - 将 Poppler `bin` 目录加入 `PATH`，或设置 `POPPLER_PATH`。
- `tesseract` 不可用
  - 将 Tesseract 加入 `PATH`，或设置 `TESSERACT_CMD`。
- Excel 导出失败
  - 确认 `openpyxl` 已安装且目标文件未被占用。

## 8. 安全与合规

- 不要将 `SAE_API_TOKEN` 写入代码或提交到仓库。
- 建议对输入文件做脱敏后再处理。

## 9. License

本项目采用 MIT License，详见 `LICENSE` 文件。

## 10. 防误提交（敏感信息保护）

项目已内置 `pre-commit` 配置和本地敏感信息扫描器，会在提交前检测：

- `SAE_API_TOKEN="..."`
- `Bearer ...`
- `sk-...` 类密钥
- 常见 `api_key/token/secret` 明文赋值

启用方式：

```powershell
pip install -r requirements.txt
pre-commit install
```

手动全量扫描：

```powershell
pre-commit run --all-files
```

若检测到疑似密钥，提交会被拒绝。请改为使用环境变量，不要把 Token 写入代码或文档。

