Param(
    [string]$targetIpAddr = "127.0.0.1",
    [int]$targetUdpPort = 39972,
    [string]$oscAddr = "/VaNiiMenu/Alert"
)

#Clear-Host
Write-Host " ["$MyInvocation.MyCommand.Name"] �W�����͂�OSC���M����v���O�����ł��B"
Write-Host "Rug.Osc ���C�u�������g�p���Ă��܂��B�iCopyright (C) 2013 Phill Tew (peatew@gmail.com)�@https://bitbucket.org/rugcode/rug.osc�j"

$ErrorActionPreference="Ignore"
[Reflection.Assembly]::LoadFrom("Rug.Osc.dll")

$ErrorActionPreference="Stop"

try 
{
    Write-Host "���M��IP�A�h���X $targetIpAddr ���M��UDP�|�[�g�ԍ� $targetUdpPort OSC�A�h���X $oscAddr"
    Write-Host("")

    $sendAddress = [System.Net.IPAddress]::Parse($targetIpAddr)
    $oscSender = New-Object Rug.Osc.OscSender($sendAddress, 0 , $targetUdpPort)
    $oscSender.Connect()

    while ($true)
    {
        Write-Host "�W�����͂�����͑҂�... �iCntl + c �ŏI���j"
        $readLine = [System.Console]::In.ReadLine()
        if ([string]::IsNullOrEmpty($readLine)) { continue } else { $oscString = $readLine }

        Write-Host "OSC�A�h���X [ $oscAddr ], OSC-string [ $oscString ]"
        Write-Host "���M���e [ $oscAddr $oscString ]"
        
        $oscMessage = New-Object Rug.Osc.OscMessage($oscAddr, $oscString)
        $oscSender.Send( $oscMessage )
    }        
}
catch [Exception]
{
    [System.Console]::Error.WriteLine("��O���������܂����B")
    [System.Console]::Error.WriteLine($_.Exception)
 }
finally
{
    if( $oscSender ) { $oscSender.Close() }
    Write-Host " ["$MyInvocation.MyCommand.Name"]�������I�����܂��B"
}
