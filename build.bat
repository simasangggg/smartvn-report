@echo off
setlocal

set INPUT=pthttm.md
set OUTPUT=bao-cao.docx
set TEMPLATE=template.docx

if not exist "%INPUT%" (
    echo ❌ Không tìm thấy file %INPUT%
    exit /b 1
)

echo 🔄 Đang chuyển đổi %INPUT% → %OUTPUT%...

if exist "%TEMPLATE%" (
    pandoc "%INPUT%" -o "%OUTPUT%" ^
      --filter pandoc-crossref.exe ^
      --toc ^
      --toc-depth=3 ^
      --reference-doc="%TEMPLATE%" ^
      --highlight-style=tango ^
      -M tables=true
) else (
    pandoc "%INPUT%" -o "%OUTPUT%" ^
      --filter pandoc-crossref.exe ^
      --toc ^
      --toc-depth=3 ^
      --highlight-style=tango ^
      -M tables=true
)

if %errorlevel% equ 0 (
    echo ✅ Đã tạo %OUTPUT% thành công!
    for %%A in ("%OUTPUT%") do echo 📊 Kích thước: %%~zA bytes
) else (
    echo ❌ Có lỗi xảy ra!
    exit /b 1
)

endlocal