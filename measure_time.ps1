param (
    [Parameter(Mandatory=$true)]
    [string]$ProgramPath,
    
    [Parameter(Mandatory=$true)]
    [string]$Arguments
)

$result = Measure-Command {$process = Start-Process -FilePath $ProgramPath -ArgumentList $Arguments -PassThru -NoNewWindow -Wait}

$userTime   = $process.UserProcessorTime
$systemTime = $process.PrivilegedProcessorTime
$realTime   = $result.TotalSeconds

Write-Host "User Time:    $($userTime.TotalSeconds) seconds"
Write-Host "System Time:  $($systemTime.TotalSeconds) seconds"
Write-Host "Real Time:    $realTime seconds"
Write-Host "`n"

$cpuTime = $userTime.TotalSeconds + $systemTime.TotalSeconds

if ($realTime -gt 0) {
    $cpuToRealRatio = $cpuTime / $realTime
    Write-Host "Cores used:   $cpuToRealRatio"
} else {
    Write-Host "Cores used: N/A (Real Time too small to measure)"
}