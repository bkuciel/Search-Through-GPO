#Specify domain
$Domain = "domainA.contoso.local"

#If domain not specified ask for domain
if ($Domain -eq "domainA.contoso.local")
{
  $Domain = Read-Host "Type domain name: "
}

$String = Read-Host "What are we looking for?: "

$NearestDC = (Get-ADDomainController -Discover -NextClosestSite).Name
 
#Get a list of GPOs from the domain
$GPOs = Get-GPO -All -Domain $Domain -Server $NearestDC | sort DisplayName

$matchingGPOs = $null 
#Go through each Object and check its XML against $String
Foreach ($GPO in $GPOs)  
{
  
  Write-Host "Working on $($GPO.DisplayName)"
  
  #Get Current GPO Report (XML)
  $CurrentGPOReport = Get-GPOReport -Guid $GPO.Id -ReportType Xml -Domain $Domain -Server $NearestDC
  
  If ($CurrentGPOReport -match $String)  {
	Write-Host "A Group Policy matching ""$($String)"" has been found:" -Foregroundcolor Green
	Write-Host "-  GPO Name: $($GPO.DisplayName)" -Foregroundcolor Green
	Write-Host "-  GPO Id: $($GPO.Id)" -Foregroundcolor Green
	Write-Host "-  GPO Status: $($GPO.GpoStatus)" -Foregroundcolor Green
    $matchingGPOs += $GPO.DisplayName + "`n"
  }
  
}

Write-Host "Matching GPOs:" -ForegroundColor Yellow
Write-Host $matchingGPOs -ForegroundColor yellow