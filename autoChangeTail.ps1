Param(
    [string]$path = $pwd,
    [string]$filter = "*.*",
    [switch]$quiet
)

if( ! $quiet )
{
    Clear-Host
    Write-Host " ["$MyInvocation.MyCommand.Name"] ディレクトリ内で作成日付の新しいファイルを tail -f する。新しくファイルが作成されると自動で切り替える。"
}

$ErrorActionPreference="Stop"

$ScanNewerFile = {
    $file = ""
    $files = Get-ChildItem -Path $targeDir -Filter $filter | Where-Object { ! $_.PSIsContainer } | Sort-Object CreationTimeUtc -Descending
    if( 0 -lt $files.Count ) # a < b
    {
        $file = Split-Path $files[0] -Leaf
    }

    if([string]::IsNullOrEmpty($file))
    {
        $script:lastReadPosition = 0
        if( ! $quiet ) { Write-Host "該当ファイルが見つかりませんでした。" }
        if( ! $quiet ) { Write-Host "ディレクトリで該当ファイルが作成されるのを監視します。" }
    }
    else 
    {
        $script:lastReadPosition = $(Get-ChildItem -Path $targeDir $file ).Length
        if( ! $quiet ) { Write-Host "該当ファイル [ $file ]" }
        if( ! $quiet ) { Write-Host "ファイルを監視し、標準出力へ出力します。" }
    }

    $file
}

try 
{
    $targeDir = $path

    if( ! $quiet ) { Write-Host "作成日付が最新のファイルを特定します。（ディレクトリ [ $targeDir ], ファイル名パターン [ $filter ]）" }

    $targetFileName = & $ScanNewerFile

    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = $targeDir
    $watcher.Filter = $filter
    $watcher.IncludeSubdirectories = $false
    $watcher.EnableRaisingEvents = $false
    
    if( ! $quiet ) { Write-Host "待機中...（Cntl + c で終了）" }
    while( $true )
    {
        # 1秒間隔のチェックで問題ないと思われる
        $changedInfo= $watcher.WaitForChanged([IO.WatcherChangeTypes]::All, 1000)
        
        # Createdイベントが来ない場合があるのでここでチェックする
        if( $changedInfo.TimedOut )
        {
            $files = Get-ChildItem -Path $targeDir -Filter $filter | Where-Object { ! $_.PSIsContainer } | Sort-Object CreationTimeUtc -Descending
            if( 0 -lt $files.Count ) # a < b
            {
                $file = Split-Path $files[0] -Leaf
                if( $targetFileName -ne $file)
                {
                    $script:lastReadPosition = $(Get-ChildItem -Path $targeDir $file ).Length
                    $targetFileName = $file
                    if( ! $quiet ) { Write-Host "新しい該当ファイル [ $file ]" }
                    if( ! $quiet ) { Write-Host "ファイルを監視し、標準出力へ出力します。" }
                }
            }
        }

        # tail -f しているファイルのイベントかどうか
        $targetChanged = $false
        if(
            ( ! $changedInfo.TimedOut ) -and
            ( ! [string]::IsNullOrEmpty($targetFileName)) -and
            (( $changedInfo.Name -eq $targetFileName) -Or ( $changedInfo.OldName -eq $targetFileName))
        )
        {
            $targetChanged = $true
        }

        switch( $changedInfo.ChangeType )
        {
            <# Createdイベントが来ない場合があるのでここでの処理はしない
            Created
            {
                # tail -f しているファイルではなかった場合
                if( ! $targetChanged ) {
                    # tail -f する対象を最新のファイルへ変更
                    $targetFileName = & $ScanNewerFile 
                }
            }
            #>
            Deleted
            {
                # tail -f しているファイルだった場合
                if( $targetChanged ) {
                    # tail -f を止めて、ファイル作成を監視する状態に戻す
                    $targetFileName = ""
                    if( ! $quiet ) { Write-Host "該当ファイルが削除されました。" }
                    if( ! $quiet ) { Write-Host "ディレクトリ監視状態に戻ります。" }
                }
            }
#            Changed { } # Changedだけだと必ずしも正しいタイミングで検出できるとは限らない
            Renamed
            {
                # tail -f しているファイルだった場合
                if( $targetChanged ) {
                    # そのファイルの tail -f を続ける
                    $targetFileName = $changedInfo.Name
                }
            }
       }

       if([string]::IsNullOrEmpty($targetFileName))
       {
           continue
       }

        # 前回の終了位置から末尾を取り出して標準出力する
        $filePath = Join-Path $targeDir $targetFileName -Resolve
        try
        {
            # [System.IO.FileShare]::ReadWrite フラグを指定する必要がることに注意
            $fs = New-Object System.IO.FileStream($filePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
            try
            {
                if( $lastReadPosition -lt $fs.Length ) # a < b
                {
                    $fs.Position = $lastReadPosition
                    $sr = New-Object System.IO.StreamReader($fs)
                    try
                    {
                        $readData = $sr.ReadToEnd()
                        $lastReadPosition = $fs.Position
                        Write-Output $readData
                    }
                    catch
                    {
                        throw
                    }
                    finally 
                    {
                        $sr.Close()
                    }
                }
                else {
                    $lastReadPosition = $fs.Length
                }
            }
            catch
            {
                throw
            }
            finally 
            {
                $fs.Close()
            }
        }
        catch [Exception]
        {
            # tail -f を止めて、ファイル作成を監視する状態に戻す
            $targetFileName = ""
            if( ! $quiet ) { Write-Host "例外が発生しました。ディレクトリ監視状態に戻ります。" }

            #if( ! $quiet ) { Write-Host "例外が発生しました。（スキップして監視は続行）" }
            if( ! $quiet ) { Write-Host $_.Exception }
        }
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
