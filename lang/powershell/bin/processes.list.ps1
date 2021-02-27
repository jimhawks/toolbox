#vars - global
$save_list = @( 'a', 'b' );
$process_list = @( 'a', 'b' );
$diff_list = @( 'a', 'b' );

# init
Clear-Host;

#| Where-Object { $_.Path -cmatch "WINDOWS" } `

# while forever - monitor processes
while ( $true )
{
   $process_list = Get-Process `
      | Where-Object { $_.Name.Length -gt 0 } `
      | Sort-Object -Property StartTime;

   # check for null list.  if so, assign emtpy array
   if ( !$process_list )
   {
      $process_list = @( );
   }

   # compare lists
   $diff_list = Compare-Object $process_list $save_list;

   # if lists are different, output the new list
   if ( $diff_list.Length -gt 0 )
   {
      Write-Host "";
      Write-Host "";
      $process_list `
         | Format-Table -Property StartTime,Name,Id,Path -Autosize `
         | Out-String -Width 200;
      $save_list = $process_list;
   }

   Start-Sleep -Seconds 3;
}