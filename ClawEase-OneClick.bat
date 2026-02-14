@echo off
title ClawEase Auto Installer
echo -------------------------------------------------------
echo 🕶️  ClawEase: Preparing your AI Agent...
echo -------------------------------------------------------
powershell -ExecutionPolicy Bypass -Command "iwr -useb https://u88zero.github.io/clawease/install.ps1 | iex"
echo -------------------------------------------------------
echo Press any key to exit...
pause >nul
