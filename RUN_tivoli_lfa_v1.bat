@echo off
cd /d "C:\github-pages-work\GitHub Pages Research Publisher"
powershell -NoProfile -ExecutionPolicy Bypass -File ".\publish_tivoli_lfa_v1_auto.ps1"
echo.
echo Done. Press any key.
pause
