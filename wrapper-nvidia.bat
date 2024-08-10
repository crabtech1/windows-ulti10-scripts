@echo off
REM This batch file runs a PowerShell script with Bypass execution policy

REM Define the path to your PowerShell script
set "psScript=C:\Users\Admin\Downloads\Drivers"

REM Run the PowerShell script with Bypass execution policy
powershell -ExecutionPolicy Bypass -File "%psScript%"

REM Pause to view output
pause
