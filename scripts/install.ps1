
$cabbageUrl= "https://github.com/senny/cabbage.git"
$cabbageDir = [IO.Path]::GetFullPath("$env:HOME/cabbage")
$templateDir = [IO.Path]::GetFullPath("$cabbageDir/templates")
$confDir = [IO.Path]::GetFullPath("$env:APPDATA/.emacs.d")
$cabbageInit = $False

function SafeExec ($command)
{
	&$command
	if (!($?)) { exit 2 }
}

Write-Host
Write-Host -ForegroundColor Green "Welcome to the cabbage installation wizard."
Write-Host

if (-not (Get-Command git -errorAction SilentlyContinue))
{
	Write-Host -ForegroundColor Red "Unable to locate git"
	Write-Host -ForegroundColor Red "Please install git first (http://git-scm.com/) or make git accessible in your PATH"
	exit 1;
}

$isFileInvocation = ![System.String]::IsNullOrEmpty($MyInvocation.InvocationName)
if ($isFileInvocation)
{
	if (Split-Path -IsAbsolute $MyInvocation.InvocationName)
	{ $scriptPath = $MyInvocation.InvocationName }
	else
	{ $scriptPath = (Resolve-Path (Join-Path $pwd.Path $MyInvocation.InvocationName)).Path }
	# the install script is located at $cabbageDir/scripts/install.ps1
	# so two steps up is the cabbage directory
	$cabbageDir = Split-Path -Parent (Split-Path -Parent $scriptPath)
	Write-Host "Cabbage already present"
	Write-Host -ForegroundColor Green "Cabbage directory is $cabbageDir"
}
else
{
	Write-Host -ForegroundColor Green "Cabbage will be downloaded to $cabbageDir"
	$cabbageInit = $True
}

Write-Host -ForegroundColor Green "Your personal configuration files will be created at"
Write-Host -ForegroundColor Green "  $confDir"
Write-Host -ForegroundColor Green "  existing files will be backed up"
Write-Host
Write-Host -ForegroundColor Green "Press enter to continue, CTRL + C to cancel"
Read-Host

if ($cabbageInit)
{
	Write-Host -ForegroundColor Green "Cloning Cabbage repository"
	SafeExec {git clone $cabbageUrl $cabbageDir}
	Push-Location $cabbageDir
	SafeExec {git submodule init}
	SafeExec {git submodule update}
	Pop-Location
	Write-Host -ForegroundColor Green "Cabbage repository initialized successfully"
}

if (Test-Path -Path $confDir)
{
	$backupDir = "$env:APPDATA/.emacs.d.bak." + [System.DateTime]::Now.ToString("yyyyMMdd-HHmmss")
	Write-Host -ForegroundColor Green "Backing up current configuration to $backupDir"
	Move-Item "$confDir" "$backupDir"
}

$translatedDir = $cabbageDir -replace "\\", "/"
New-Item $confDir -Type directory
Get-Content "$templateDir/init.el" | ForEach-Object {$_ -replace "CABBAGE-DIR", "$translatedDir"} > "$confDir/init.el"
Copy-Item "$templateDir/emacs.d/*" "$confDir"

$username=$env:USERNAME
Write-Host $username
New-Item "$confDir/users" -Type directory
Copy-Item "$templateDir/username.el" "$confDir/users/$username.el"

$hostname=hostname
New-Item "$confDir/machines" -Type directory
Copy-Item "$templateDir/machine.el" "$confDir/machines/$hostname.el"

#New-Item "$confDir/bin"
#Write-Output "$cabbageDir/scripts/update.ps1" > "$confDir/bin/update-cabbage"

Write-Host -ForegroundColor Green "Your Cabbage directory is: $cabbageDir"


