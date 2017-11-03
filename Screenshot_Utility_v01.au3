#include <ScreenCapture.au3>
#include <Date.au3>
#include <TrayConstants.au3> ; Required for the $TRAY_ICONSTATE_SHOW constant.
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
Tray()
Func Tray()
    Local $idExit = TrayCreateItem("Exit")
    Local $idScreenshot = TrayCreateItem("Screenshot")
	Local $idSelectScreenshot = TrayCreateItem("Select Screenshot")
    TraySetState($TRAY_ICONSTATE_HIDE) ; Show the tray menu.

    While 1
Sleep(100)
        Switch TrayGetMsg()
            Case $idExit ; Exit the loop.
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

Func TakingScreenShot()
$desktopPath = @DesktopDir&"\"&$folderPath_put
ConsoleWrite("Sciezka Pulpit: "&$desktopPath&@CRLF)
$data = _NowDate ( ) ; data do nazwy pliku
;ConsoleWrite($data&@CRLF)
$data_reg_exp = StringRegExpReplace($data,"-","_",0)
;ConsoleWrite($data_reg_exp&@CRLF)
$czas = _NowTime() ; czas do nazwy pliku
ConsoleWrite("Data zrobienia zrzutu ekranu: "&$czas&@CRLF)
$czasRegExpR = StringRegExpReplace($czas,":","_",0)
;ConsoleWrite($czasRegExpR&@CRLF)
Global $nazwa_pliku = "Scr_" & $data_reg_exp & "___" &$czasRegExpR & ".jpg" ; cala nazwa pliku string
ConsoleWrite("Nazwa pliku: "&$nazwa_pliku&@CRLF)
_ScreenCapture_Capture($desktopPath & $nazwa_pliku, "-1", "-1", "-1", "-1") ; pobieram zrzut
#comments-start
$cmd_run = "mspaint "&$sciezkaPulpit&$nazwa_pliku ; uruchamiam cmd
Run(@ComSpec & " /c " & $cmd_run ,@TempDir, @SW_HIDE) ;ukryte cmd
Global $nazwa_pliku_win_wait = StringRegExpReplace($nazwa_pliku,".jpg","",0); string dotyczy oczekiwania na okno
Loading()
WinWait("[CLASS:MSPaintApp;TITLE:"&$nazwa_pliku_win_wait&"]","",0)
WinSetState($nazwa_pliku_win_wait,"",@SW_MAXIMIZE) ;maksymalizuje okno painta
#comments-end
;Screenshot_History() ;kopia zapas zrzutow ekranu do folderu
ConsoleWrite("Koniec"&@CRLF)
EndFunc

Func TakingSelectScreenshot()
$desktopPath = @DesktopDir&"\"&$folderPath_put
ConsoleWrite("Sciezka Pulpit: "&$desktopPath&@CRLF)
$x_box = 120
$x = @DesktopWidth - $x_box - 7
$y = @DesktopHeight - 69
Sleep(250)
SplashTextOn("KLIK - OD", "", $x_box, 0, $x, $y, $DLG_TEXTLEFT, "", 24)
Do
$t = 1
If _IsPressed("90", $dll) Then
   $MousePos1 = MouseGetPos()
   ConsoleWrite("Mouse Button Pressed" & @CR & "X=" & $MousePos1[0] & @CR & "Y=" & $MousePos1[1]&@CRLF)
   $t = 0
EndIf
Until $t = 0
SplashTextOn("KLIK - DO", "", $x_box, 0, $x, $y, $DLG_TEXTLEFT, "", 24)
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
$data = _NowDate ( )
;ConsoleWrite($data&@CRLF)
$data_reg_exp = StringRegExpReplace($data,"-","_",0)
;ConsoleWrite($data_reg_exp&@CRLF)
$czas = _NowTime()
ConsoleWrite("Data/time capture: "&$czas&@CRLF)
$czasRegExpR = StringRegExpReplace($czas,":","_",0)
;ConsoleWrite($czasRegExpR&@CRLF)
Global $nazwa_pliku = "Scr_" & $data_reg_exp & "___" &$czasRegExpR & ".jpg"
ConsoleWrite("Nazwa pliku: "&$nazwa_pliku&@CRLF)
_ScreenCapture_Capture($desktopPath & $nazwa_pliku, $MousePos1[0], $MousePos1[1], $MousePos2[0], $MousePos2[1])
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

Func Screenshot_History();wylaczona funkcja nie dziala
$nazwa_folderu = "02_Screenshot_History"
$sciezka_1 = "\Users\bj372851"
ConsoleWrite("Sciezka @HomePath :  "&$sciezka_1&@CRLF)
$sciezka_dokumentow = "C:"&$sciezka_1&"\Documents\"&$nazwa_folderu
ConsoleWrite("Sciezka do kopii zapasowej zrzutow ekranu: "&$sciezka_dokumentow&@CRLF)
If Not FileExists($sciezka_dokumentow) Then ;tworze folder jezeli nie istnieje
ConsoleWrite("Konieczne utworzenie folderu o nazwie: "&$nazwa_folderu&@CRLF)
DirCreate($sciezka_dokumentow)
EndIf
FileCopy($sciezkaPulpit & $nazwa_pliku,$sciezka_dokumentow)
ConsoleWrite("Kopia zapasowa zrzutu ekranu zakonczona"&@CRLF)
EndFunc
