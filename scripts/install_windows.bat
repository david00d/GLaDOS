@echo off
REM Download and install the required dependencies for the project on Windows

echo Creating Virtual Environment...
pip install uv
uv self update
uv venv --python 3.12.8
call  .venv\Scripts\activate

echo Installing Dependencies...
nvcc --version >nul 2>&1
if %ERRORLEVEL%==0 (
    echo CUDA is available. Installing requirements-cuda.txt...
    uv pip install -r requirements_cuda.txt
) else (
    echo CUDA is not available. Installing requirements.txt...
    UV pip install -r requirements.txt
)

echo Downloading Models...

:: Enable delayed expansion for working with variables inside loops
setlocal enabledelayedexpansion

:: Define the list of files with their URLs and local paths
:: Removed quotes around the entire string and fixed paths
set "files[0]=https://github.com/dnhkng/GlaDOS/releases/download/0.1/glados.onnx;models/glados.onnx"
set "files[1]=https://github.com/dnhkng/GlaDOS/releases/download/0.1/nemo-parakeet_tdt_ctc_110m.onnx;models/nemo-parakeet_tdt_ctc_110m.onnx"
set "files[2]=https://github.com/dnhkng/GlaDOS/releases/download/0.1/phomenizer_en.onnx;models/phomenizer_en.onnx"
set "files[3]=https://github.com/dnhkng/GlaDOS/releases/download/0.1/silero_vad.onnx;models/silero_vad.onnx"

:: Loop through the list
for /l %%i in (0,1,3) do (
    for /f "tokens=1,2 delims=;" %%a in ("!files[%%i]!") do (
        set "url=%%a"
        set "file=%%b"
        
        echo Checking file: !file!
        
        if exist "!file!" (
            echo File "!file!" already exists.
        ) else (
            echo Downloading !file!...
            curl -L "!url!" --create-dirs -o "!file!"
            
            if exist "!file!" (
                echo Download successful.
            ) else (
                echo Download failed for !file!
                echo URL: !url!
            )
        )
    )
)

echo Installation Complete!
pause