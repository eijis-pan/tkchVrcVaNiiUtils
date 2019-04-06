Param(
    [string]$path = $pwd,
    [string]$filter = "*.*",
    [switch]$quiet
)

if( ! $quiet )
{
    Clear-Host
    Write-Host " ["$MyInvocation.MyCommand.Name"] �f�B���N�g�����ō쐬���t�̐V�����t�@�C���� tail -f ����B�V�����t�@�C�����쐬�����Ǝ����Ő؂�ւ���B"
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
        if( ! $quiet ) { Write-Host "�Y���t�@�C����������܂���ł����B" }
        if( ! $quiet ) { Write-Host "�f�B���N�g���ŊY���t�@�C�����쐬�����̂��Ď����܂��B" }
    }
    else 
    {
        $script:lastReadPosition = $(Get-ChildItem -Path $targeDir $file ).Length
        if( ! $quiet ) { Write-Host "�Y���t�@�C�� [ $file ]" }
        if( ! $quiet ) { Write-Host "�t�@�C�����Ď����A�W���o�͂֏o�͂��܂��B" }
    }

    $file
}

try 
{
    $targeDir = $path

    if( ! $quiet ) { Write-Host "�쐬���t���ŐV�̃t�@�C������肵�܂��B�i�f�B���N�g�� [ $targeDir ], �t�@�C�����p�^�[�� [ $filter ]�j" }

    $targetFileName = & $ScanNewerFile

    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = $targeDir
    $watcher.Filter = $filter
    $watcher.IncludeSubdirectories = $false
    $watcher.EnableRaisingEvents = $false
    
    if( ! $quiet ) { Write-Host "�ҋ@��...�iCntl + c �ŏI���j" }
    while( $true )
    {
        # 1�b�Ԋu�̃`�F�b�N�Ŗ��Ȃ��Ǝv����
        $changedInfo= $watcher.WaitForChanged([IO.WatcherChangeTypes]::All, 1000)
        
        # Created�C�x���g�����Ȃ��ꍇ������̂ł����Ń`�F�b�N����
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
                    if( ! $quiet ) { Write-Host "�V�����Y���t�@�C�� [ $file ]" }
                    if( ! $quiet ) { Write-Host "�t�@�C�����Ď����A�W���o�͂֏o�͂��܂��B" }
                }
            }
        }

        # tail -f ���Ă���t�@�C���̃C�x���g���ǂ���
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
            <# Created�C�x���g�����Ȃ��ꍇ������̂ł����ł̏����͂��Ȃ�
            Created
            {
                # tail -f ���Ă���t�@�C���ł͂Ȃ������ꍇ
                if( ! $targetChanged ) {
                    # tail -f ����Ώۂ��ŐV�̃t�@�C���֕ύX
                    $targetFileName = & $ScanNewerFile 
                }
            }
            #>
            Deleted
            {
                # tail -f ���Ă���t�@�C���������ꍇ
                if( $targetChanged ) {
                    # tail -f ���~�߂āA�t�@�C���쐬���Ď������Ԃɖ߂�
                    $targetFileName = ""
                    if( ! $quiet ) { Write-Host "�Y���t�@�C�����폜����܂����B" }
                    if( ! $quiet ) { Write-Host "�f�B���N�g���Ď���Ԃɖ߂�܂��B" }
                }
            }
#            Changed { } # Changed�������ƕK�������������^�C�~���O�Ō��o�ł���Ƃ͌���Ȃ�
            Renamed
            {
                # tail -f ���Ă���t�@�C���������ꍇ
                if( $targetChanged ) {
                    # ���̃t�@�C���� tail -f �𑱂���
                    $targetFileName = $changedInfo.Name
                }
            }
       }

       if([string]::IsNullOrEmpty($targetFileName))
       {
           continue
       }

        # �O��̏I���ʒu���疖�������o���ĕW���o�͂���
        $filePath = Join-Path $targeDir $targetFileName -Resolve
        try
        {
            # [System.IO.FileShare]::ReadWrite �t���O���w�肷��K�v���邱�Ƃɒ���
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
            # tail -f ���~�߂āA�t�@�C���쐬���Ď������Ԃɖ߂�
            $targetFileName = ""
            if( ! $quiet ) { Write-Host "��O���������܂����B�f�B���N�g���Ď���Ԃɖ߂�܂��B" }

            #if( ! $quiet ) { Write-Host "��O���������܂����B�i�X�L�b�v���ĊĎ��͑��s�j" }
            if( ! $quiet ) { Write-Host $_.Exception }
        }
    }
}
catch [Exception]
{
   [System.Console]::Error.WriteLine("��O���������܂����B")
   [System.Console]::Error.WriteLine($_.Exception)
}
finally
{
    if( ! $quiet ) { Write-Host " ["$MyInvocation.MyCommand.Name"]�������I�����܂��B" }
}
