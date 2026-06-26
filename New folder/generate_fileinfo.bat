@echo off
setlocal enabledelayedexpansion

echo -----------------------------------------
echo  🔍 Generating fileInfo.txt from .bin files
echo -----------------------------------------

REM ✅ Check if Python is available
where python >nul 2>&1
if errorlevel 1 (
    echo ❌ Python is not installed or not in PATH.
    echo Please install Python from https://www.python.org/downloads/
    goto END
)

REM 🐍 Create a temporary Python script
set PYTMP=%temp%\gen_fileinfo.py
echo import os > "%PYTMP%"
echo output_file = "fileInfo.txt" >> "%PYTMP%"
echo bin_files = [f for f in os.listdir() if f.lower().endswith((".bin", ".icl"))] >> "%PYTMP%"
echo bin_files.sort() >> "%PYTMP%"
echo if not bin_files: >> "%PYTMP%"
echo ^    print("⚠️ No .bin files found in this folder.") >> "%PYTMP%"
echo else: >> "%PYTMP%"
echo ^    lines = ["FileName,Size(bytes)"] >> "%PYTMP%"
echo ^    for f in bin_files: >> "%PYTMP%"
echo ^        size = os.path.getsize(f) >> "%PYTMP%"
echo ^        lines.append(f"{f},{size}") >> "%PYTMP%"
echo ^    with open(output_file, "w") as file: >> "%PYTMP%"
echo ^        file.write("\n".join(lines)) >> "%PYTMP%"
echo ^    print(f"\n✅ Generated {output_file} with {len(bin_files)} files:\n") >> "%PYTMP%"
echo ^    for line in lines: >> "%PYTMP%"
echo ^        print(line) >> "%PYTMP%"

REM ▶️ Run the Python script
echo Running Python script...
python "%PYTMP%"
if errorlevel 1 (
    echo ❌ Python script failed to run. Check for syntax or environment issues.
)

:END
echo.
echo -----------------------------------------
echo ✅ Script finished. Check above for results.
echo -----------------------------------------
pause
endlocal
