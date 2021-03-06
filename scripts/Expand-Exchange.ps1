[CmdletBinding()]
param(

    [Parameter(Mandatory=$true)]
    [string]
    $ExchangeServerVersion,

    [Parameter(Mandatory=$true)]
    [string]
    $ExchangeDownloadLink

)

try {
    Start-Transcript -Path C:\cfn\log\Expand-Exchange.ps1.txt -Append
    $ErrorActionPreference = "Stop"
    $Path = "C:\Exchangeinstall"
    $filename = $ExchangeDownloadLink.Substring($ExchangeDownloadLink.LastIndexOf("/") + 1)
    
    if($ExchangeServerVersion -eq "2013") {
        Invoke-Command -ScriptBlock {Start-Process cmd.exe "/c cd $Path && $Path\$filename /extract:$Path /quiet" -NoNewWindow -Wait}
    }
    elseif ($ExchangeServerVersion -eq "2016") {
        $isoPath = $Path + "\" + $filename
        Mount-DiskImage -ImagePath $isoPath
        $driveLetter = (Get-DiskImage $isoPath | Get-Volume).DriveLetter
        Copy-Item -Path "${driveLetter}:\*" -Destination $Path -Recurse
    }
}
catch {
   # $_ | Write-AWSQuickStartException
}
