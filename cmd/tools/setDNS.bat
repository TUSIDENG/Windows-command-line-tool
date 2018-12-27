::=============================================================
:: 一键设置dns
@echo off
title 一键设置dns
::=============================================================
:: 定义首先dns，备用dns
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
::=============================================================
echo 获得网络名称:
netsh interface show interface | findstr "已连接" >network.txt

for /f "tokens=4,5 usebackq" %%a in ("network.txt") do (
    set NetConnection=%%a%%b
)
echo %NetConnection%
del network.txt 2>nul 1>nul
echo 网络名称获取完成...
::=============================================================
:: 菜单
:choice
echo ============选择方法:============
echo ============ 1:设置114dns =============
echo ============ 2:自动获取dns =============
echo ============ Q:程序退出 =============

set /P var=":"
if %var%==1 goto dnsstatic
if %var%==2 goto dnsdhcp
if %var%==q  exit

::=============================================================
:: 设置114dns
:dnsstatic
echo 设置DNS...
:: 设置首选DNS
netsh interface ip set dns name=%NetConnection% source=static addr=%Net_dnsPra% 1>nul 2>nul
:: 设置备用DNS
netsh interface ip add dns %NetConnection% %Net_dnsOrder% index=2 1>nul 2>nul

echo **DNS设置为：%Net_dnsPra%，设置成功**
echo =============================================================
goto choice


::=============================================================
:: 自动获取dns
:dnsdhcp
netsh interface ip delete dns %NetConnection% all >nul
ipconfig /flushdns >nul
echo **dns自动获取成功**
echo  =============================================================
goto choice