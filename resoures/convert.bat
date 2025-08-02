@echo off
setlocal enabledelayedexpansion

:: ===== 配置部分 =====
set "source_dir=F:\github\cats-tea\resoures\ToBeConverted"
set "target_dir=F:\github\cats-tea\resoures\Converted"
:: 支持的扩展名（不区分大小写）
set "extensions=.bmp .jpg .jpeg .gif .tif .tiff .webp .ico .png"
:: ====================

echo 当前源文件夹路径: "%source_dir%"
echo 支持的扩展名: %extensions%
echo.

:: 检查源文件夹是否存在
if not exist "%source_dir%" (
    echo [ERROR] 文件夹不存在: "%source_dir%"
    pause
    exit /b 1
)

:: 检查目标文件夹是否存在
if not exist "%target_dir%" (
    echo 创建目标文件夹: "%target_dir%"
    mkdir "%target_dir%"
)

:: 使用 dir /b /s 查找文件（更可靠）
set "file_count=0"
for /f "delims=" %%f in ('dir /b /s /a-d "%source_dir%\*.*" ^| findstr /i "\.bmp$ \.jpg$ \.jpeg$ \.gif$ \.tif$ \.tiff$ \.webp$ \.ico$ \.png$"') do (
    set /a "file_count+=1"
    echo [!file_count!] 找到文件: %%f
)

if %file_count% equ 0 (
    echo [ERROR] 没有找到匹配的文件！
    echo 请检查:
    echo 1. "%source_dir%" 是否有图片文件？
    echo 2. 文件扩展名是否匹配: %extensions%?
    pause
    exit /b 1
)

echo.
echo 找到 %file_count% 个文件，开始转换...
echo.

set "success_count=0"
for /f "delims=" %%f in ('dir /b /s /a-d "%source_dir%\*.*" ^| findstr /i "\.bmp$ \.jpg$ \.jpeg$ \.gif$ \.tif$ \.tiff$ \.webp$ \.ico$ \.png$"') do (
    set "filename=%%~nf"
    set "output_path=%target_dir%\!filename!.png"

    echo 正在转换: "%%~nxf" → "!output_path!"
    ffmpeg -err_detect aggressive -hide_banner -loglevel error -i "%%f" "!output_path!"

    if !errorlevel! equ 0 (
        echo [成功] 转换完成
        set /a "success_count+=1"
    ) else (
        echo [失败] 转换出错
    )
    echo.
)

echo.
echo 转换完成！
echo 成功: %success_count% / 总数: %file_count%
pause