$php = "D:\php\php.exe"
$hostAddr = "127.0.0.1:8081"
$sitePath = Resolve-Path "$PSScriptRoot\..\Site"

function Start-Server {
    Write-Host "Starting PHP server on http://$hostAddr"
    return Start-Process -FilePath $php `
        -ArgumentList "-S $hostAddr -t `"$sitePath`"" `
        -NoNewWindow `
        -PassThru
}

$server = Start-Server

while ($true) {
    $cmd = Read-Host

    if ($cmd -eq "reload") {
        Write-Host "Reloading PHP server..."
        try {
            Stop-Process -Id $server.Id -Force
        } catch {}
        $server = Start-Server
    }
    elseif ($cmd -eq "exit") {
        Write-Host "Stopping server..."
        Stop-Process -Id $server.Id -Force
        break
    }
}
