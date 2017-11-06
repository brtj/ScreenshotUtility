#include <ScreenCapture.au3>
#include <Date.au3>
#include <TrayConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <SendMessage.au3>
#include <AutoItConstants.au3>
#Include <Misc.au3>
Opt("TrayOnEventMode", 1)
Global $dll = DllOpen("user32.dll")
HotKeySet("{PRINTSCREEN}","TakingScreenShot")
HotKeySet("#{NUMLOCK}","TakingSelectScreenshot")
ReadINI()
Global $desktopPath = @DesktopDir&"\"&$folderPath_put
Tray()
Func Tray()
    Local $idExit = TrayCreateItem("Exit")
    Local $idScreenshot = TrayCreateItem("Screenshot")
	Local $idSelectScreenshot = TrayCreateItem("Select Screenshot")
    TraySetState($TRAY_ICONSTATE_HIDE)
    While 1
Sleep(100)
        Switch TrayGetMsg()
            Case $idExit
                ExitLoop
			 Case $idScreenshot
				TakingScreenshot()
			 Case $idScreenshot
				Mysz()
			 Case $idSelectScreenshot
				TakingSelectScreenshot()
        EndSwitch
    WEnd
EndFunc

Func get_date_n($data)
$data_reg_exp = StringRegExpReplace($data,"-","_",0)
$time_n = _NowTime()
ConsoleWrite("Screenshot made at: "&$time_n&@CRLF)
$timeRegExpR = StringRegExpReplace($time_n,":","_",0)
Global $name_file = "Scr_" & $data_reg_exp & "___" &$timeRegExpR & ".jpg"
ConsoleWrite("File name: "&$name_file&@CRLF)
Return $name_file
EndFunc

Func TakingScreenShot()
ConsoleWrite("Pulpit path: "&$desktopPath&@CRLF)
$name_file = get_date_n(_NowDate ( ))
_ScreenCapture_Capture($desktopPath & $name_file, "-1", "-1", "-1", "-1") ; pobieram zrzut
ConsoleWrite("Screenshot done."&@CRLF)
EndFunc

Func TakingSelectScreenshot()
ConsoleWrite("Pulpit path: "&$desktopPath&@CRLF)
$x_box = 150
$x = @DesktopWidth - $x_box - 7
$y = @DesktopHeight - 69
Sleep(250)
SplashTextOn("FROM - PRESS NUMLOCK", "", $x_box, 0, $x, $y, $DLG_TEXTLEFT, "", 24)
Do
$t = 1
If _IsPressed("90", $dll) Then
   $MousePos1 = MouseGetPos()
   ConsoleWrite("Mouse Button Pressed" & @CR & "X=" & $MousePos1[0] & @CR & "Y=" & $MousePos1[1]&@CRLF)
   $t = 0
EndIf
Until $t = 0
SplashTextOn("TO - PRESS NUMLOCK", "", $x_box, 0, $x, $y, $DLG_TEXTLEFT, "", 24)
Sleep(250)
Do
$t = 1
If _IsPressed("90", $dll) Then
   $MousePos2 = MouseGetPos()
   ConsoleWrite("Mouse Button Pressed" & @CR & "X=" & $MousePos2[0] & @CR & "Y=" & $MousePos2[1]&@CRLF)
   $t = 0
EndIf
Until $t = 0
SplashOff()
$name_file = get_date_n(_NowDate ( ))
_ScreenCapture_Capture($desktopPath & $name_file, $MousePos1[0], $MousePos1[1], $MousePos2[0], $MousePos2[1])
EndFunc

Func ReadINI()
$FilePath = @ScriptDir&'\'&'Screenshot_Utility_v01.ini'
ConsoleWrite($FilePath&@CRLF)
Global $DesktopFolder = IniReadSection($FilePath, "DesktopFolderName")
For $i = 1 To $DesktopFolder[0][0]
  ConsoleWrite("Service number: " & $DesktopFolder[$i][0]& ', ' & "Service name: " & $DesktopFolder[$i][1]&@CRLF)
Next
Global $folderPath_put = $DesktopFolder[1][1]
ConsoleWrite($folderPath_put&@CRLF)
EndFunc