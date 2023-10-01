# Delete backup and log files older 7 days
$DBdir = '\\srv-backup.local\srv-postgre.local\DB_NAME'
$Filter = '*.dump'

$count = (Get-ChildItem -File $DBdir -Filter $Filter | Measure-Object).Count

## If backup files more then 7 delete DB backups
if ($count -ge 8){
Get-ChildItem -Path $DBdir | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-7)} | Remove-Item
}

## Delete Schemas backups
$schemadirs = Get-ChildItem -Path $DBdir -Recurse -Directory -Force -ErrorAction SilentlyContinue | Select-Object FullName
foreach ($schemadir in $schemadirs){
$schemacount = (Get-ChildItem -File $schemadir.Fullname -Filter $Filter | Measure-Object).Count
if ($schemacount -ge 22){
Get-ChildItem -Path $schemadir.Fullname | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-7)} | Remove-Item
}}

