Set sh = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
folder = fso.GetParentFolderName(WScript.ScriptFullName)
html = folder & "\mp_sales_dashboard.html"

' Prefer starting a local server if Python exists
Set env = sh.Environment("PROCESS")
path = env("PATH")

hasPython = False
On Error Resume Next
rc = sh.Run("cmd /c where python >nul 2>&1", 0, True)
If rc = 0 Then hasPython = True
If Not hasPython Then
  rc = sh.Run("cmd /c where py >nul 2>&1", 0, True)
  If rc = 0 Then hasPython = True
End If
On Error GoTo 0

If hasPython Then
  ' Start server minimized, then open browser
  sh.Run "cmd /c cd /d """ & folder & """ && (python -m http.server 8080 --bind 127.0.0.1 || py -m http.server 8080 --bind 127.0.0.1)", 1, False
  WScript.Sleep 1200
  sh.Run "http://127.0.0.1:8080/mp_sales_dashboard.html", 1, False
  MsgBox "Dashboard server started." & vbCrLf & vbCrLf & "Browser should open at:" & vbCrLf & "http://127.0.0.1:8080/mp_sales_dashboard.html" & vbCrLf & vbCrLf & "Leave the black command window open while using the dashboard." & vbCrLf & "Close that window when finished.", 64, "MP Developers Dashboard"
Else
  ' No Python: open HTML directly
  sh.Run """" & html & """", 1, False
  MsgBox "Python not found, so the file was opened directly." & vbCrLf & vbCrLf & "If upload does not work, install Python from:" & vbCrLf & "https://www.python.org/downloads/" & vbCrLf & "(tick Add Python to PATH)" & vbCrLf & vbCrLf & "Then run this launcher again.", 48, "MP Developers Dashboard"
End If
