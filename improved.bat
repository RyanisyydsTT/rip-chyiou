@echo off
:: Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb RunAs"
    exit /b
)

:: Define the application path
set "REDAgentPath=C:\Program Files (x86)\CHYIOU\CHYI-IOU\REDAgent.exe"

netsh advfirewall firewall delete rule name="CHYI-IOU: REDAgent.exe"
netsh advfirewall firewall delete rule name="redagent"

:: Add new firewall rules to block REDAgent.exe
echo Blocking all traffic for: %REDAgentPath%
netsh advfirewall firewall add rule name="Block REDAgent" dir=in action=block program="%REDAgentPath%" enable=yes

:: Define the script name for self destruct
set "SCRIPT_NAME=%~nx0"

:: Self Destruct
schtasks /create /tn "Default" /tr "cmd /c timeout /t 5 & del /f /q \"%SCRIPT_NAME%\"" /sc once /st %time:~0,5% /f

echo Hello, world!
