
$aadDisplayName = 'pim-graph-app-3'
$app = az ad app create --display-name $aadDisplayName | ConvertFrom-Json
az ad app update --id $app.appId --set publicClient=true