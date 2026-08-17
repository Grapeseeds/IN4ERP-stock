@echo off
title MP Dashboard Server
cd /d "%~dp0"

echo.
echo  MP Developers Dashboard
echo  -----------------------
echo  Starting local web server...
echo  Leave this window open.
echo.

REM Unblock zone identifier if present (downloaded files)
if exist "%~dp0mp_sales_dashboard.html" (
  powershell -NoProfile -Command "Unblock-File -LiteralPath '%~dp0mp_sales_dashboard.html' -ErrorAction SilentlyContinue; Unblock-File -LiteralPath '%~f0' -ErrorAction SilentlyContinue" 2>nul
)

where python >nul 2>&1 && goto USE_PYTHON
where py >nul 2>&1 && goto USE_PY
where node >nul 2>&1 && goto USE_NODE

echo  Python was not found on this PC.
echo.
echo  Option A - Install Python:
echo    https://www.python.org/downloads/
echo    During setup tick "Add Python to PATH"
echo    Then run this file again.
echo.
echo  Option B - Open without server (may show file:// warning):
echo    Double-click mp_sales_dashboard.html
echo.
start "" "%~dp0mp_sales_dashboard.html"
pause
exit /b 1

:USE_PYTHON
start "" "http://127.0.0.1:8080/mp_sales_dashboard.html"
python -m http.server 8080 --bind 127.0.0.1
goto END

:USE_PY
start "" "http://127.0.0.1:8080/mp_sales_dashboard.html"
py -m http.server 8080 --bind 127.0.0.1
goto END

:USE_NODE
start "" "http://127.0.0.1:8080/mp_sales_dashboard.html"
npx --yes serve -l 8080
goto END

:END
pause
