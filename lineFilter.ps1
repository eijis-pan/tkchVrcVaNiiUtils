Param(
    [switch]$quiet
)

if( ! $quiet )
{
    Clear-Host
    Write-Host " ["$MyInvocation.MyCommand.Name"] �W�����͂�������𖞂����s��W���o�͂���v���O�����ł��B"
}

$ErrorActionPreference="Stop"

try 
{
    while ($true)
    {
        if( ! $quiet ) { Write-Host "�W�����͂�����͑҂�... �iCntl + c �ŏI���j" }

        $readLine = [System.Console]::In.ReadLine()
        if ([string]::IsNullOrEmpty($readLine)) { continue }

        $writeLine = ""
        if(
            $readLine -match "\s+(?<PlayerName>\S+?) received (?<EventName>Avatar change?)" -Or        # �A�o�^�[�ύX
            $readLine -match "\[NetworkManager\] (?<EventName>OnPlayerLeft?) (?<PlayerName>\S+?)\s*$" -Or  # �C���X�^���X�ޏo
            $readLine -match "\[Spawn\] (?<EventName>Spawning?) (?<PlayerName>\S+?) at location"  # ���X�|�[��
            )
        {
            if( ! $quiet ) { Write-Host "�C�x���g [ "$Matches.EventName" ], �v���C���[�� [ "$Matches.PlayerName" ]" }
            $writeLine = "�C�x���g [ " + $Matches.EventName + " ], �v���C���[�� [ " + $Matches.PlayerName + " ]"
#            $writeLine = $readLine
        }

        if([string]::IsNullOrEmpty($writeLine)) { continue }

        if( ! $quiet ) { Write-Host "�o�͓��e [ $writeLine ]" }
        Write-Output $writeLine
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
