:: This script was used to download all images from the Nutrition5k dataset and store them appropriately.

@echo off
setlocal

:: This defines the bucket that we fetch data from
set "BUCKET=gs://nutrition5k_dataset/nutrition5k_dataset/imagery/realsense_overhead"
set "DEST_DIR=%~dp0data\images"

if not exist "%DEST_DIR%" mkdir "%DEST_DIR%"

:: List every rgb.png, extract the 6th field as dish_ID, then download if missing
for /f "delims=" %%G in ('gsutil ls "%BUCKET%/**/rgb.png"') do (
    for /f "tokens=6 delims=/" %%D in ("%%G") do (
        if exist "%DEST_DIR%\%%D.png" (
            echo Skipping %%D - already downloaded
        ) else (
            echo Downloading %%G → "%DEST_DIR%\%%D.png"
            gsutil cp "%%G" "%DEST_DIR%\%%D.png"
        )
    )
)

endlocal