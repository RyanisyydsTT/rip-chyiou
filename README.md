# 碁優多媒體教室學生機脫離控制實作
## Education Purpose Only.

## 以下是碁優控制學生機的方式
### 控制端透過(連接阜(Port) 10049 (目前推測))存取學生機
### 控制端的檢測學生是否下線的方式是: Ping學生端(推測)
## 以下是已知的資訊
### 首先，根據碁優官方說明書寫道「而在學生機上，有 1 個程式需要設置為“允許存取”，它是 ``REDAgent.exe``。」。 
### 碁優在安裝過程中會自動新增4個允許的輸入規則(TCP, UDP, 公用, 私人)，應用於``REDAgent.exe``，名為``CHYI-IOU: REDAgent.exe``。 
### 碁優會在當``REDAgent.exe``關閉後自動重啟時，檢查規則是否依然存在。 若不存在，``REDAgent.exe``會主動重新新增規則，名為``redagent``。
### 碁優使用Ping學生端的方式檢測學生是否離線或異常斷開。因此，當我們對``REDAgent.exe``的規則進行更改時，控制端不會收到任何訊息。
## 以下是綜合上述所有資訊做成的.bat程式碼
```bat
@echo off
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb RunAs"
    exit /b
)

set "REDAgentPath=C:\Program Files (x86)\CHYIOU\CHYI-IOU\REDAgent.exe"

netsh advfirewall firewall delete rule name="CHYI-IOU: REDAgent.exe"
netsh advfirewall firewall delete rule name="redagent"

echo Blocking all traffic for: %REDAgentPath%
netsh advfirewall firewall add rule name="Block REDAgent" dir=in action=block program="%REDAgentPath%" enable=yes

echo Firewall rules updated.
pause

```
1. 當檢測該腳本不是使用管理員權限開啟時，主動要求提高權限。
2. 設定``REDAgent.exe``的路徑。
3. 刪除所有碁優設定的防火牆規則。
4. 建立新的「阻止」``REDAgent.exe``規則。
## 結論
碁優在設計軟體上有一點點缺陷，希望開發者看到這篇時，可以改進～
另外，這個腳本可以直接從 https://fuck.ryanisyyds.xyz/ 下載
