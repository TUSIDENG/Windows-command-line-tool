::=============================================================
:: һ������dns
@echo off
title һ������dns
::=============================================================
:: ��������dns������dns
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
echo �����������:
netsh interface show interface | findstr "������" >network.txt

for /f "tokens=4,5 usebackq" %%a in ("network.txt") do (
    set NetConnection=%%a%%b
)
echo %NetConnection%
del network.txt 2>nul 1>nul
echo �������ƻ�ȡ���...
::=============================================================
:: �˵�
:choice
echo ============ѡ�񷽷�:============
echo ============ 1:����114dns =============
echo ============ 2:�Զ���ȡdns =============
echo ============ Q:�����˳� =============

set /P var=":"
if %var%==1 goto dnsstatic
if %var%==2 goto dnsdhcp
if %var%==q  exit

::=============================================================
:: ����114dns
:dnsstatic
echo ����DNS...
:: ������ѡDNS
netsh interface ip set dns name=%NetConnection% source=static addr=%Net_dnsPra% 1>nul 2>nul
:: ���ñ���DNS
netsh interface ip add dns %NetConnection% %Net_dnsOrder% index=2 1>nul 2>nul

echo **DNS����Ϊ��%Net_dnsPra%�����óɹ�**
echo =============================================================
goto choice


::=============================================================
:: �Զ���ȡdns
:dnsdhcp
netsh interface ip delete dns %NetConnection% all >nul
ipconfig /flushdns >nul
echo **dns�Զ���ȡ�ɹ�**
echo  =============================================================
goto choice