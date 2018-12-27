::=============================================================
:: 一键设置ip
@echo off
title 一键设置IP
::=============================================================
:: 定义IP地址，子网掩码，网关，首先dns，备用dns
set IP=10.10.76.241
set Net_mask=255.255.255.0
set Net_gateway=10.10.76.254
set Net_dnsPra=114.114.114.114
set Net_dnsOrder=8.8.8.8
::=============================================================
:: Get Administrator Rights
fltmc 1>nul 2>nul || (
  cd /d "%~dp0"
  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0", "", "runas", 1 > "%temp%\GetAdmin.vbs"
  "%temp%\GetAdmin.vbs"
  del /f /q "%temp%\GetAdmin.vbs" 1>nul 2>nul
  exit
)

call :getNetwork
call :setip
pause
exit
::=============================================================
:getNetwork
echo 获得网络名称:
netsh interface show interface | findstr "已连接" >network.txt

for /f "tokens=4,5 usebackq" %%a in ("network.txt") do (
    set NetConnection=%%a%%b
)
echo %NetConnection%
del network.txt 2>nul 1>nul
echo 网络名称获取完成...
goto :EOF
::=============================================================
:setip
echo 设置IP...
netsh interface ip set address name=%NetConnection% source=static addr=%IP% mask=%Net_mask% gateway=%Net_gateway% >nul
echo 设置DNS...
:: 设置首先DNS
netsh interface ip set dns name=%NetConnection% source=static addr=%Net_dnsPra% 1>nul 2>nul
:: 设置备用DNS
netsh interface ip add dns %NetConnection% %Net_dnsOrder% index=2 1>nul 2>nul

echo **IP设置为%IP%，设置成功**
ping -n 1 127.1>nul
goto :EOF