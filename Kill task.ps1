$servers=@("srv01.medved.local"
,"srv02.medved.local"
)

foreach ($server in $servers){
  echo $server
  Invoke-Command -ComputerName $server -ScriptBlock {
    $service="$('AOS60$01')"
    $id=(Get-WmiObject -Class Win32_Service | Where {$_.Name –eq $service}).ProcessID
    echo $id
    Stop-Process  $id -Force
  }
}
