# Backup Postgre DB/Pre-data/Data/Post-Data from powershell
```powershell
cd "C:\Program Files\pgAdmin 4\v6\runtime\"
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
```
## --->GLOBAL VARIABLES<--- ##
```powershell
[string]$dir="SQLBackup.local\SQLBackup"
[string]$host="srv-postgre.domain.local"
[string]$port="5432"
[string]$username="postgres"
[string]$userpass="postgres"
[string]$dbname="DD_NAME"
[string]$dburl="postgresql://"+$username+":"+$userpass+"@"+$host+":"+$port+"/"+$dbname

SET PGPASSWORD=$userpass
SET PGUSER=$username
[string]$rights="GRANT CONNECT ON DATABASE ""LR_BUDGET"" TO "+$username+"; "+
    "ALTER USER "+$username+" WITH SUPERUSER; ALTER ROLE;"
    "GRANT SELECT ON ALL TABLES IN SCHEMA public TO "+$username+"; "+
    "GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO "+$username+";" | psql --csv $dburl

New-item -Force –itemtype Directory -Path $dir -Name $host | Out-null
[string]$dir=$dir+'\'+$host
New-item -Force –itemtype Directory -Path $dir -Name $dbname | Out-null
[string]$dir=$dir+'\'+$dbname
```
## --->FULL BACKUP VARIABLES<--- ##
```powershell
[string]$date=Get-Date -Format "yyMMdd"
[string]$time=Get-Date -Format "hhmmss"
[string]$file_full=$dir+"\"+$dbname+"_full"+"_"+$date+"_"+$time+".dump"
[string]$db_log=$dir+"\"+$dbname+"_full"+"_"+$date+"_"+$time+".log"

echo $file_full > $db_log
pg_dump.exe --file $file_full --format=c --blobs --no-unlogged-table-data --lock-wait-timeout=10  $dburl 2>> $db_log #--exclude-table=table
```
## --->SCHEMA VARIABLES<--- ##
```powershell
$schemas="SELECT nspname FROM pg_catalog.pg_namespace" | psql --csv $dburl | ConvertFrom-Csv
foreach ($nspname in $schemas){
  [string]$schema=$nspname.nspname
    if ($schema -notlike "*temp*"){
      [string]$date=Get-Date -Format "yyMMdd"
      [string]$time=Get-Date -Format "hhmmss"

      New-item -Force –itemtype Directory -Path $dir -Name $schema | Out-null
      [string]$file_predata=$dir+'\'+$schema+"\"+$schema+"_pre-data"+"_"+$date+"_"+$time+'.dump'
      [string]$file_data=$dir+'\'+$schema+"\"+$schema+"_data"+"_"+$date+"_"+$time+'.dump'
      [string]$file_postdata=$dir+'\'+$schema+"\"+$schema+"_post-data"+"_"+$date+"_"+$time+'.dump'
      [string]$schema_log=$dir+'\'+$schema+"\"+$schema+"_"+$date+"_"+$time+'.log'

      echo $file_predata > $schema_log
      pg_dump.exe --file $file_predata --format=c --no-blobs --schema=$schema --section=pre-data $dburl 2>> $schema_log
      
      echo $file_data >>  $schema_log
      pg_dump.exe --file $file_data --format=c --no-blobs --schema=$schema --section=data $dburl 2>> $schema_log
      echo $file_postdata >> $schema_log
      pg_dump.exe --file $file_postdata --format=c --no-blobs --schema=$schema --section=post-data $dburl 2>> $schema_log
      #pause
    }
}
```
