$servers=@("srv01.medved.local"
,"srv02.medved.local"
)
$i=0
cls

while ($true) {
  foreach ($server in $servers){
    $service="$('AOS60$01')"
    $properties=(Get-service -ComputerName $server | Where {$_.Name –eq "$service"} | Select-Object *)
    
    if ($properties.Status  -eq "Running") {Write-Host $properties.MachineName $properties.ServiceName $properties.Status $properties.StartType -ForegroundColor Green}
    elseif ($properties.Status  -eq "Stopped") {Write-Host $properties.MachineName $properties.ServiceName $properties.Status $properties.StartType -ForegroundColor Red}
    else {Write-Host $properties.MachineName $properties.ServiceName $properties.Status $properties.StartType -ForegroundColor Yellow}
    
    if ($i -ne $servers.Count){
      $i+=1
      Start-Sleep -Seconds 2
    }else{
      cls
      $i=0
      start-sleep -m 250
    }
  }
}
