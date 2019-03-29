Param(
    [string]$targetIpAddr = "127.0.0.1",
    [int]$targetUdpPort = 39972,
    [string]$oscAddr = "/VaNiiMenu/Alert"
)

#Clear-Host
Write-Host " ["$MyInvocation.MyCommand.Name"] 標準入力をOSC送信するプログラムです。"
Write-Host "Rug.Osc ライブラリを使用しています。（Copyright (C) 2013 Phill Tew (peatew@gmail.com)　https://bitbucket.org/rugcode/rug.osc）"

$ErrorActionPreference="Ignore"
[Reflection.Assembly]::LoadFrom("Rug.Osc.dll")

$ErrorActionPreference="Stop"

try 
{
    Write-Host "送信先IPアドレス $targetIpAddr 送信先UDPポート番号 $targetUdpPort OSCアドレス $oscAddr"
    Write-Host("")

    $sendAddress = [System.Net.IPAddress]::Parse($targetIpAddr)
    $oscSender = New-Object Rug.Osc.OscSender($sendAddress, 0 , $targetUdpPort)
    $oscSender.Connect()

    while ($true)
    {
        Write-Host "標準入力から入力待ち... （Cntl + c で終了）"
        $readLine = [System.Console]::In.ReadLine()
        if ([string]::IsNullOrEmpty($readLine)) { continue } else { $oscString = $readLine }

        Write-Host "OSCアドレス [ $oscAddr ], OSC-string [ $oscString ]"
        Write-Host "送信内容 [ $oscAddr $oscString ]"
        
        $oscMessage = New-Object Rug.Osc.OscMessage($oscAddr, $oscString)
        $oscSender.Send( $oscMessage )
    }        
}
catch [Exception]
{
    [System.Console]::Error.WriteLine("例外が発生しました。")
    [System.Console]::Error.WriteLine($_.Exception)
 }
finally
{
    if( $oscSender ) { $oscSender.Close() }
    Write-Host " ["$MyInvocation.MyCommand.Name"]処理を終了します。"
}
