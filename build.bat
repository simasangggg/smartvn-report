@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set TEMPLATE=template.docx
set OUTPUT=bao-cao.docx

:: ============================================================
:: BƯỚC 1: CHỌN FILE .MD
:: ============================================================
echo.
echo ╔══════════════════════════════════════════════╗
echo ║         PANDOC MD → DOCX CONVERTER          ║
echo ╚══════════════════════════════════════════════╝
echo.

:: Liệt kê các file .md cùng thư mục
echo 📄 Các file .md trong thư mục hiện tại:
echo.
set idx=0
for %%f in (*.md) do (
    set /a idx+=1
    set "file_!idx!=%%f"
    echo   [!idx!] %%f
)

if %idx%==0 (
    echo ❌ Không tìm thấy file .md nào trong thư mục này.
    pause
    exit /b 1
)

echo.
set /p CHOICE="👉 Nhập số thứ tự hoặc tên file (vd: bao_cao.md): "

:: Kiểm tra nếu nhập tên file trực tiếp
if exist "%CHOICE%" (
    set INPUT=%CHOICE%
    goto :start_build
)

:: Kiểm tra nếu nhập số
set "INPUT=!file_%CHOICE%!"
if "!INPUT!"=="" (
    echo ❌ Lựa chọn không hợp lệ.
    pause
    exit /b 1
)

:start_build
if not exist "%INPUT%" (
    echo ❌ Không tìm thấy file: %INPUT%
    pause
    exit /b 1
)

:: Tạo tên output từ tên input (thay .md → .docx)
set "OUTPUT=%INPUT:.md=.docx%"

echo.
echo ▶ File input  : %INPUT%
echo ▶ File output : %OUTPUT%
echo ▶ Template    : %TEMPLATE%
echo.

:: ============================================================
:: BƯỚC 2: PANDOC CONVERT
:: ============================================================
echo 🔄 Đang chuyển đổi với pandoc...

if exist "%TEMPLATE%" (
    pandoc "%INPUT%" -o "%OUTPUT%" ^
      --filter pandoc-crossref.exe ^
      --toc ^
      --toc-depth=3 ^
      --reference-doc="%TEMPLATE%" ^
      --highlight-style=tango ^
      -M tables=true
) else (
    echo ⚠️  Không tìm thấy template.docx, dùng style mặc định.
    pandoc "%INPUT%" -o "%OUTPUT%" ^
      --filter pandoc-crossref.exe ^
      --toc ^
      --toc-depth=3 ^
      --highlight-style=tango ^
      -M tables=true
)

if not %errorlevel%==0 (
    echo ❌ Pandoc lỗi! Kiểm tra lại file .md.
    pause
    exit /b 1
)

echo ✅ Pandoc hoàn thành!

:: ============================================================
:: BƯỚC 3: FIX CAPTION STYLES bằng Python
:: ============================================================
echo 🎨 Đang áp dụng Figure Caption và Table Caption styles...

python fix_caption.py "%OUTPUT%"

if %errorlevel%==0 (
    echo ✅ Caption styles đã được cập nhật!
) else (
    echo ⚠️  Bỏ qua fix caption (Python hoặc python-docx chưa cài).
    echo    Chạy: pip install python-docx
)

:: ============================================================
:: KẾT QUẢ
:: ============================================================
echo.
echo ══════════════════════════════════════════════
for %%A in ("%OUTPUT%") do echo ✅ Hoàn thành! Kích thước: %%~zA bytes
echo 📂 File: %OUTPUT%
echo ══════════════════════════════════════════════
echo.

set /p OPEN="📖 Mở file ngay? (y/n): "
if /i "%OPEN%"=="y" start "" "%OUTPUT%"

endlocal