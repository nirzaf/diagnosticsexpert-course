param (
  [Parameter(Mandatory = $True, Position = 0)][String]
  $DumpPath,
  [Parameter(Mandatory = $True, Position = 1)][String]
  $StacksPath
)

$stacks = Get-Content $StacksPath | ConvertFrom-Csv -Delimiter ','
$tmp = Join-Path $env:TEMP "out.txt"

$stacks | % {
    if ($_.Module -eq "<unknown>") {
        Start-Process -RedirectStandardOutput $tmp -FilePath "dotnet-dump" `
            -ArgumentList @("analyze", $DumpPath, "-c", "`"ip2md $($_.Address)`"", "-c", "q") -Wait
        $method = Get-Content $tmp | Select-Object -First 5 | Select-Object -Last 1
        Remove-Item $tmp
        $method
    } else {
        $_.Module + "!" + $_.Location
    }
}
