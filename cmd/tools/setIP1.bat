::=============================================================
:: ����ip
:: 1.���þ�̬IP 2.�Զ���ȡIP
@echo off

title һ��IP
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
echo ============ 1:���þ�̬IP =============
echo ============ 2:�Զ���ȡip =============
echo ============ Q:�����˳� =============

set /P var=":"
if %var%==1 goto ipstatic
if %var%==2 goto ipdhcp
if %var%==q  exit
::=============================================================
:: ���þ�̬IP
:ipstatic
SET /P IP="����IP:"
echo ����IP...
netsh interface ip set address name=%NetConnection% source=static addr=%IP% mask=%Net_mask% gateway=%Net_gateway%
echo ����DNS...
:: ������ѡDNS
netsh interface ip set dns name=%NetConnection% source=static addr=%Net_dnsPra% 1>nul 2>nul
:: ���ñ���DNS
netsh interface ip add dns %NetConnection% %Net_dnsOrder% index=2 1>nul 2>nul

echo **IP����Ϊ��%IP%�����óɹ�**
echo ^-^   ^-^  ^-^  ^-^  ^-^   ^-^  ^-^  ^-^
ping -n 1 127.1>nul 
goto choice
::=============================================================
:: �Զ���ȡIP
:ipdhcp
netsh interface ip set address name=%NetConnection% source=dhcp >nul
netsh interface ip delete dns %NetConnection% all >nul
ipconfig /flushdns >nul
echo **IP�Զ���ȡ�ɹ�**
echo  =============================================================
ping -n 1 127.1>nul 
goto choice