::=============================================================
:: 设置ip
:: 1.设置静态IP 2.自动获取IP
@echo off

title 一键IP
set Net_mask=255.255.255.0
set Net_gateway=10.10.71.254
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
echo ============ 1:设置静态IP =============
echo ============ 2:自动获取ip =============
echo ============ Q:程序退出 =============

set /P var=":"
if %var%==1 goto ipstatic
if %var%==2 goto ipdhcp
if %var%==q  exit
::=============================================================
:: 设置静态IP
:ipstatic
SET /P IP="输入IP:"
echo 设置IP...
netsh interface ip set address name=%NetConnection% source=static addr=%IP% mask=%Net_mask% gateway=%Net_gateway%
echo 设置DNS...
:: 设置首选DNS
netsh interface ip set dns name=%NetConnection% source=static addr=%Net_dnsPra% 1>nul 2>nul
:: 设置备用DNS
netsh interface ip add dns %NetConnection% %Net_dnsOrder% index=2 1>nul 2>nul

echo **IP设置为：%IP%，设置成功**
echo ^-^   ^-^  ^-^  ^-^  ^-^   ^-^  ^-^  ^-^
ping -n 1 127.1>nul 
goto choice
::=============================================================
:: 自动获取IP
:ipdhcp
netsh interface ip set address name=%NetConnection% source=dhcp >nul
netsh interface ip delete dns %NetConnection% all >nul
ipconfig /flushdns >nul
echo **IP自动获取成功**
echo  =============================================================
ping -n 1 127.1>nul 
goto choice