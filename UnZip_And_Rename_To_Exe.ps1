<#
.SYNOPSIS
  �н����尡 ������ �Ǽ��ڵ� zip ������ Ǯ��, ���������� ã�� Ȯ���� .exe�� �ٿ��ִ� ��ũ��Ʈ
.DESCRIPTION
  1. ZIP ������ ������ BACKUP ���丮�� ���� (������ �������� ����)
  2. �н����尡 ������ zip ������ ������ ���� (7-zip ���α׷��� ���, �������� ������ BACKUP)
  3. ��������(MZ)�� ã�� ������ Ȯ����(.exe) �߰� (���� ������ ����)
.PARAMETER 
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  <Inputs if any, otherwise state None>
.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>
.NOTES
  Version:        1.0
  Author:         Seungsuk Ryoo
  Creation Date:  2018-12-20
  Purpose/Change: Initial script development, All rights reserved.
  
.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
#>


#---------------------------------------------------------[Initialisations]--------------------------------------------------------
$backupDir = "ZipBackUp"
$zipFilePassword = "koreait"
$pattern = "MZ"
#----------------------------------------------------------[Declarations]----------------------------------------------------------

#-----------------------------------------------------------[Functions]------------------------------------------------------------
function 7unzip($file) {
    $7ZipPath = '"C:\Program Files\7-Zip\7z.exe"'
    $command = "& $7ZipPath e -y -tzip -p$zipFilePassword $file"
    iex -Command $command
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

# BACKUP directory check and create
if(-Not (Test-Path -path $backupDir)){
    mkdir $backupDir
}

# Extract ZIP file(with password)
Get-ChildItem *.zip | 
Foreach-Object {
    7unzip $_
    $zip = $backupDir + "\" + $_.Name
    echo $zip
    if(Test-Path -path $zip){
        Remove-Item $_.Name
    } else {
        Move-Item -Path $_ -Destination $backupDir
    }
}

# Rename file extension to .EXE
Get-ChildItem *.* |
Foreach-Object {
    $content = Get-Content $_
    if ($content[0].StartsWith($pattern) -and ([IO.Path]::GetExtension($_) -ne '.exe')) {
        $filenew = $_.Name + ".exe"
        if(Test-Path -path $filenew){
            Remove-Item $_.Name
        } else {
            Rename-Item $_.Name $filenew
        }
    }
}
