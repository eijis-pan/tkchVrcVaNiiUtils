Param(
    [switch]$quiet
)

if( ! $quiet )
{
    Clear-Host
    Write-Host " ["$MyInvocation.MyCommand.Name"] 標準入力から条件を満たす行を標準出力するプログラムです。"
}

$ErrorActionPreference="Stop"

try 
{
    while ($true)
    {
        if( ! $quiet ) { Write-Host "標準入力から入力待ち... （Cntl + c で終了）" }

        $readLine = [System.Console]::In.ReadLine()
        if ([string]::IsNullOrEmpty($readLine)) { continue }

        $writeLine = ""
        if(
            $readLine -match "\s+(?<PlayerName>\S+?) received (?<EventName>Avatar change?)" -Or        # アバター変更
            $readLine -match "\[NetworkManager\] (?<EventName>OnPlayerLeft?) (?<PlayerName>\S+?)\s*$" -Or  # インスタンス退出
            $readLine -match "\[Spawn\] (?<EventName>Spawning?) (?<PlayerName>\S+?) at location"  # リスポーン
            )
        {
            if( ! $quiet ) { Write-Host "イベント [ "$Matches.EventName" ], プレイヤー名 [ "$Matches.PlayerName" ]" }
            $writeLine = "イベント [ " + $Matches.EventName + " ], プレイヤー名 [ " + $Matches.PlayerName + " ]"
#            $writeLine = $readLine
        }

        if([string]::IsNullOrEmpty($writeLine)) { continue }

        if( ! $quiet ) { Write-Host "出力内容 [ $writeLine ]" }
        Write-Output $writeLine
    }        
}
catch [Exception]
{
   [System.Console]::Error.WriteLine("例外が発生しました。")
   [System.Console]::Error.WriteLine($_.Exception)
}
finally
{
    if( ! $quiet ) { Write-Host " ["$MyInvocation.MyCommand.Name"]処理を終了します。" }
}
