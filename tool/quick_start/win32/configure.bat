@echo off
title Ryzom Core Configuration
powershell ";"
echo -------
echo --- Ryzom Core Configuration
echo -------
echo(
echo This script will set up the buildsite configuration, and create needed directories.
echo(
goto :config
:baddir
echo ERROR: Do not run this script from R:
echo(
pause
exit
:config
if exist .nel\path_config.bat call .nel\path_config.bat
mkdir .nel > nul 2> nul
set RC_ROOT_TEMP=%CD%
if /I "%RC_ROOT_TEMP%"=="R:" goto :baddir
set RC_ROOT=%RC_ROOT_TEMP%
for /f "delims=" %%A in ('cd') do (
set RC_ROOT_NAME=%%~nxA
)
if not exist %RC_ROOT%\external\python27\python.exe goto :userpython27
set RC_PYTHON27_DIR=%RC_ROOT%\external\python27
goto :checkpython3
:userpython27
echo To use the defaults, simply hit ENTER, else type in the new value.
echo Use -- if you need to insert an empty value.
set RC_PYTHON27_DIR_TEMP=
set /p RC_PYTHON27_DIR_TEMP=Python 2.7 (%RC_PYTHON27_DIR%): 
if /I "%RC_PYTHON27_DIR_TEMP%"=="" set RC_PYTHON27_DIR_TEMP=%RC_PYTHON27_DIR%
if /I "%RC_PYTHON27_DIR_TEMP%"=="--" set RC_PYTHON27_DIR_TEMP=
set RC_PYTHON27_DIR=%RC_PYTHON27_DIR_TEMP%
if not exist %RC_PYTHON27_DIR%\python.exe goto :config
echo(
:checkpython3
if not exist %RC_ROOT%\external\python3\python.exe goto :userpython3
set RC_PYTHON3_DIR=%RC_ROOT%\external\python3
goto :apply
:userpython3
echo To use the defaults, simply hit ENTER, else type in the new value.
echo Use -- if you need to insert an empty value.
set RC_PYTHON3_DIR_TEMP=
set /p RC_PYTHON3_DIR_TEMP=Python 3 (%RC_PYTHON3_DIR%): 
if /I "%RC_PYTHON3_DIR_TEMP%"=="" set RC_PYTHON3_DIR_TEMP=%RC_PYTHON3_DIR%
if /I "%RC_PYTHON3_DIR_TEMP%"=="--" set RC_PYTHON3_DIR_TEMP=
set RC_PYTHON3_DIR=%RC_PYTHON3_DIR_TEMP%
if not exist %RC_PYTHON3_DIR%\python.exe goto :config
echo(
:apply
set RC_ORIG_PATH=%PATH%
set PATH=%RC_PYTHON3_DIR%;%RC_ORIG_PATH%
cd /d %RC_ROOT%\code\tool\quick_start
python configure_toolchains.py
if %errorlevel% neq 0 pause
python configure_targets.py
if %errorlevel% neq 0 pause
python print_summary.py
if %errorlevel% neq 0 pause
cd /d %RC_ROOT%
call .nel\path_config.bat
echo Mounting %RC_ROOT% as R:
call _r_check.bat
cd /d R:\
:lookfortoolsstock
set PATH=%RC_TOOLS_DIRS_STOCK%;%RC_ORIG_PATH%
where /q ryzom_patchman_service
if %errorlevel% neq 0 goto :notoolsstock
where /q sheets_packer_shard
if %errorlevel% neq 0 goto :notoolsstock
where /q panoply_maker
if %errorlevel% neq 0 goto :notoolsstock
:hastoolsstock
set RC_TOOLS_DIRS=%RC_TOOLS_DIRS_STOCK%
goto :lookfortoolsbuild
:notoolsstock
:lookfortoolsbuild
set PATH=%RC_TOOLS_DIRS_RELEASE%;%RC_ORIG_PATH%
where /q ryzom_patchman_service
if %errorlevel% neq 0 goto :notoolsbuild
where /q sheets_packer_shard
if %errorlevel% neq 0 goto :notoolsbuild
where /q panoply_maker
if %errorlevel% neq 0 goto :notoolsbuild
:hastoolsbuild
echo Using locally built tools
set RC_TOOLS_DIRS=%RC_TOOLS_DIRS_RELEASE%
:notoolsbuild
if not defined RC_TOOLS_DIRS (
echo ERROR: Tools not found. Run `code_configure_rebuild_all` to build everything, and re-run the configuration script.
pause
exit
)
echo | set /p=Updating references
rem powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%RC_ROOT%\tile_edit.lnk');$s.TargetPath='%RC_ROOT%\distribution\nel_tools_win_x64\tile_edit.exe';$s.WorkingDirectory='%RC_ROOT%\distribution\nel_tools_win_x64\';$s.Save()"
rem echo | set /p=.
rem powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%RC_ROOT%\object_viewer.lnk');$s.TargetPath='%RC_ROOT%\distribution\nel_tools_win_x64\object_viewer.exe';$s.WorkingDirectory='%RC_ROOT%\distribution\nel_tools_win_x64\';$s.Save()"
rem echo | set /p=.
rem powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%RC_ROOT%\georges.lnk');$s.TargetPath='%RC_ROOT%\distribution\ryzom_tools_win_x64\georges.exe';$s.WorkingDirectory='%RC_ROOT%\distribution\ryzom_tools_win_x64\';$s.Save()"
rem echo | set /p=.
rem powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%RC_ROOT%\world_editor.lnk');$s.TargetPath='%RC_ROOT%\distribution\ryzom_tools_win_x64\world_editor.exe';$s.WorkingDirectory='%RC_ROOT%\distribution\ryzom_tools_win_x64\';$s.Save()"
rem echo | set /p=.
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%RC_ROOT%\build_gamedata.lnk');$s.TargetPath='%RC_ROOT%\code\nel\tools\build_gamedata';$s.Save()"
echo | set /p=.
rem powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%RC_ROOT%\client_install_playing.lnk');$s.TargetPath='%RC_ROOT%\pipeline\client_install_playing';$s.Save()"
rem echo | set /p=.
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%RC_ROOT%\%RC_ROOT_NAME%.lnk');$s.TargetPath='%RC_ROOT%\';$s.Save()"
echo | set /p=.
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%RC_ROOT%\R.lnk');$s.TargetPath='R:\';$s.Save()"
echo .
echo(
set PATH=%RC_PYTHON27_DIR%;%RC_ORIG_PATH%
cd /d %RC_ROOT%\code\nel\tools\build_gamedata
python 0_setup.py -p
if %errorlevel% neq 0 pause
rem if exist %RC_ROOT%\pipeline\install\data_leveldesign\sheet_id.bin goto :skipbuild
rem python a1_worldedit_data.py
rem if %errorlevel% neq 0 pause
rem python 1_export.py -ipj common/gamedev common/data_common common/sound common/leveldesign common/exedll shard/data_language shard/data_leveldesign shard/data_shard
rem if %errorlevel% neq 0 pause
rem python 2_build.py -ipj common/gamedev common/data_common common/sound common/leveldesign common/exedll shard/data_language shard/data_leveldesign shard/data_shard
rem if %errorlevel% neq 0 pause
rem cd /d %RC_ROOT%
rem call copy_dds_to_interfaces.bat
rem cd /d %RC_ROOT%\code\nel\tools\build_gamedata
rem python 3_install.py
rem if %errorlevel% neq 0 pause
rem :skipbuild
rem python b1_client_dev.py
rem if %errorlevel% neq 0 pause
rem python b2_shard_data.py
rem if %errorlevel% neq 0 pause
rem python b3_shard_dev.py
rem if %errorlevel% neq 0 pause
echo(
title Ryzom Core Configuration: Ready
echo Ready
pause
