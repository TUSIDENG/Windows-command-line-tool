::=============================================================
:: һ������ip
@echo off
title һ������IP
::=============================================================
:: ����IP��ַ���������룬���أ�����dns������dns
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
echo �����������:
netsh interface show interface | findstr "������" >network.txt

for /f "tokens=4,5 usebackq" %%a in ("network.txt") do (
    set NetConnection=%%a%%b
)
echo %NetConnection%
del network.txt 2>nul 1>nul
echo �������ƻ�ȡ���...
goto :EOF
::=============================================================
:setip
echo ����IP...
netsh interface ip set address name=%NetConnection% source=static addr=%IP% mask=%Net_mask% gateway=%Net_gateway% >nul
echo ����DNS...
:: ��������DNS
netsh interface ip set dns name=%NetConnection% source=static addr=%Net_dnsPra% 1>nul 2>nul
:: ���ñ���DNS
netsh interface ip add dns %NetConnection% %Net_dnsOrder% index=2 1>nul 2>nul

echo **IP����Ϊ%IP%�����óɹ�**
ping -n 1 127.1>nul
goto :EOF