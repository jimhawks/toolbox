Get-Process `
   | Where-Object { $_.Path -match "WINDOWS" } `
   | Sort-Object -Property StartTime `
   |  Format-Table -Property Name,Id,Path `
   | Out-String -Width 200;
pause;