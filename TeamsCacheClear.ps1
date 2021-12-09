#TeamsCacheClear - Made by Andrea Robertsen

#Check if Teams process exists or is closed
$teamsProcess = Get-Process -Name "Teams" -ErrorAction SilentlyContinue
if ($teamsProcess)
{
    Write-Host "Teams is running, closing now."  -ForegroundColor Red
    Stop-Process -InputObject $teamsProcess 
}
elseif ($teamsProcess -eq $null)
{
    Write-Host "Teams is not running" -ForegroundColor Green
}


#Check if Outlook process exists or is closed
$outlookProcess = Get-Process -Name "Outlook" -ErrorAction SilentlyContinue
if ($outlookProcess)
{
    Write-Host "Outlook is running, closing now."  -ForegroundColor Red
    Stop-Process -InputObject $outlookProcess 
}
elseif ($outlookProcess -eq $null)
{
    Write-Host "Outlook is not running" -ForegroundColor Green
}

if (Get-Process | Where-Object {($teamsProcess.HasExited -or $outlookProcess.HasExited) -or ($teamsProcess -eq $null -or $outlookProcess -eq $null)})
{
    Get-ChildItem "C:\Users\*\AppData\Roaming\Microsoft\Teams\*" -directory | Where name -in ('blob_storage','databases','GPUCache','IndexedDB','Local Storage','tmp','Cache','Local Storage','Code Cache') | ForEach{Remove-Item $_.FullName -Recurse -Force -WhatIf}
    Write-Host "Teams Cache Cleaned" -ForegroundColor Green
    Write-Host "Teams and Outlook starting" -ForegroundColor Green
    start outlook
    Start-Process -File "$($env:USERProfile)\AppData\Local\Microsoft\Teams\Update.exe" -ArgumentList '--processStart "Teams.exe"'
    Write-Host "Teams and Outlook started" -ForegroundColor Green
}
else
{
    Write-Host "One or more conditions are not met, Teams cache not deleted" -ForegroundColor Red
}

