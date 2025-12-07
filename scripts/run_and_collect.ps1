<#
Run this from project root (PowerShell). It starts flutter run and captures logs to logs.txt.
Usage: .\scripts\run_and_collect.ps1
#>
param(
    [string]$DeviceId = 'emulator-5554',
    [string]$LogFile = 'logs.txt'
)

Write-Host "Starting flutter on device $DeviceId and logging to $LogFile"
Set-Location -Path (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent) -ErrorAction SilentlyContinue
# ensure running from repo root
Set-Location '..' 2>$null

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Host 'flutter not found in PATH. Please ensure Flutter SDK is installed and on PATH.' -ForegroundColor Yellow
}

Write-Host "Running: flutter run -d $DeviceId | Tee-Object -FilePath $LogFile"
flutter run -d $DeviceId | Tee-Object -FilePath $LogFile

Write-Host "Done. Logs saved to $LogFile"
