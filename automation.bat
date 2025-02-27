@echo off
setlocal enabledelayedexpansion

REM Change to the correct directory
cd /d "C:\Users\ragha\EnergiBridge\target\release"

REM Set the path to EnergiBridge executable
set "ENERGIBRIDGE_PATH=C:\Users\ragha\EnergiBridge\target\release\energibridge.exe"

REM Set the paths for Notepad++, Vim, and Neovim
set "NOTEPADPP_PATH=C:\Program Files\Notepad++\notepad++.exe"
set "VIM_PATH=C:\Program Files\Vim\vim91\gvim.exe"
set "NEOVIM_PATH=C:\Program Files\Neovim\bin\nvim.exe"

REM Array of editors to iterate over
set editors[0]=%NOTEPADPP_PATH%
set editors[1]=%VIM_PATH%
set editors[2]=%NEOVIM_PATH%

REM Array to hold editor names for easy identification
set editor_names[0]=Notepad++
set editor_names[1]=Vim
set editor_names[2]=Neovim

REM Create a temporary typing script for SendKeys with editor-specific handling
echo WScript.Sleep 100 > typing_script.vbs
echo Set WshShell = WScript.CreateObject("WScript.Shell") >> typing_script.vbs
echo Set objArgs = WScript.Arguments >> typing_script.vbs
echo editorName = objArgs(0) >> typing_script.vbs
echo WshShell.AppActivate editorName >> typing_script.vbs
echo WScript.Sleep 100 >> typing_script.vbs

REM Add editor-specific preparation - for Vim, enter insert mode first
echo If editorName = "Vim" OR editorName = "Neovim" Then >> typing_script.vbs
echo   WshShell.SendKeys "i" >> typing_script.vbs
echo   WScript.Sleep 100 >> typing_script.vbs
echo End If >> typing_script.vbs

REM Add text that will be typed into the editors - no saving needed
echo WshShell.SendKeys "This is a test of energy consumption while typing in different text editors." >> typing_script.vbs
echo WScript.Sleep 500 >> typing_script.vbs
echo WshShell.SendKeys "{ENTER}{ENTER}" >> typing_script.vbs
echo WScript.Sleep 500 >> typing_script.vbs
echo WshShell.SendKeys "We are measuring how much power is used when actively typing text." >> typing_script.vbs
echo WScript.Sleep 500 >> typing_script.vbs
echo WshShell.SendKeys "{ENTER}The text being typed simulates a user working with the editor." >> typing_script.vbs
echo WScript.Sleep 500 >> typing_script.vbs
echo WshShell.SendKeys "{ENTER}We're typing longer sentences to simulate real usage patterns." >> typing_script.vbs
echo WScript.Sleep 500 >> typing_script.vbs
echo WshShell.SendKeys "{ENTER}Each editor might handle text rendering and processing differently." >> typing_script.vbs
echo WScript.Sleep 500 >> typing_script.vbs
echo WshShell.SendKeys "{ENTER}This could lead to different energy consumption profiles." >> typing_script.vbs
echo WScript.Sleep 500 >> typing_script.vbs
echo WshShell.SendKeys "{ENTER}We're not saving any files, just measuring typing energy usage." >> typing_script.vbs
echo WScript.Sleep 500 >> typing_script.vbs

REM Create close script with commands to just close each editor without saving
echo Set objArgs = WScript.Arguments > close_editor.vbs
echo editorName = objArgs(0) >> close_editor.vbs
echo WScript.Sleep 500 >> close_editor.vbs
echo Set WshShell = WScript.CreateObject("WScript.Shell") >> close_editor.vbs
echo WshShell.AppActivate editorName >> close_editor.vbs
echo WScript.Sleep 500 >> close_editor.vbs
echo If editorName = "Notepad++" Then >> close_editor.vbs
echo   WshShell.SendKeys "%{F4}" >> close_editor.vbs
echo   WScript.Sleep 500 >> close_editor.vbs
echo   WshShell.SendKeys "n" >> close_editor.vbs
echo ElseIf editorName = "Vim" Then >> close_editor.vbs
echo   WshShell.SendKeys "{ESC}" >> close_editor.vbs
echo   WScript.Sleep 500 >> close_editor.vbs
echo   WshShell.SendKeys ":q!{ENTER}" >> close_editor.vbs
echo ElseIf editorName = "Neovim" Then >> close_editor.vbs
echo   WshShell.SendKeys "{ESC}" >> close_editor.vbs
echo   WScript.Sleep 500 >> close_editor.vbs
echo   WshShell.SendKeys ":q!{ENTER}" >> close_editor.vbs
echo End If >> close_editor.vbs

REM Iterate over each editor
for /L %%j in (0,1,2) do (
    REM Get the editor path and name
    set "EDITOR_PATH=!editors[%%j]!"
    set "EDITOR_NAME=!editor_names[%%j]!"
    
    REM Print the editor name
    echo.
    echo Testing with !EDITOR_NAME!...
    
    REM Run the test for each editor n times
    for /L %%i in (1,1,30) do (
        echo.
        echo Starting iteration %%i of 30 for !EDITOR_NAME!...
        
        REM Start EnergiBridge for the iteration - only save summary files
        echo Starting EnergiBridge...
        start /B "" "%ENERGIBRIDGE_PATH%" -o "results%%j%%i.csv" --summary timeout 10 > energibridge_!EDITOR_NAME!_%%i.log 2>&1
        
        timeout /t 1 /nobreak > nul
        
        REM Open the editor
        echo Opening !EDITOR_NAME!...
        start "" "!EDITOR_PATH!"
        
        timeout /t 2 /nobreak > nul
        
        REM Run the typing script with the editor name parameter
        echo Typing text in !EDITOR_NAME!...
        cscript //nologo typing_script.vbs "!EDITOR_NAME!"
        
        REM Close the editor without saving
        echo Closing !EDITOR_NAME! without saving...
        cscript //nologo close_editor.vbs "!EDITOR_NAME!"
        
        timeout /t 2 /nobreak > nul
        
        REM Make sure the editor is closed (failsafe)
        echo Ensuring !EDITOR_NAME! is closed...
        if "!EDITOR_NAME!"=="Neovim" (
            taskkill /F /IM nvim.exe > nul 2>&1
        ) else if "!EDITOR_NAME!"=="Notepad++" (
            taskkill /F /IM notepad++.exe > nul 2>&1
        ) else if "!EDITOR_NAME!"=="Vim" (
            taskkill /F /IM gvim.exe > nul 2>&1
        )
        
        REM Brief pause between iterations
        if %%i neq 3 (
            echo Waiting before next iteration...
            timeout /t 3 /nobreak
        )
    )
)

REM Clean up temporary scripts
del typing_script.vbs
del close_editor.vbs

REM Display where the summaries are saved
echo.
echo All iterations completed for all editors.
pause