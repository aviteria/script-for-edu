<#
.SYNOPSIS
  ���丮�� zip ���ϵ��� ã��, ������ .vs ���丮(����Ӽ�), Debug���丮�� �����ϴ� ��ũ��Ʈ '
  �л� ���� ������ ���� �ۼ���
.DESCRIPTION
  1. ZIP ������ ������ BACKUP ���丮�� ���� (������ �������� ����)
  2. �н����尡 ������ zip ������ ������ ���� (7-zip ���α׷��� ���, �������� ������ BACKUP)
  3. ��������(MZ)�� ã�� ������ Ȯ����(.exe) �߰� (���� ������ ����)
.NOTES
  Version:        1.0
  Author:         Seungsuk Ryoo
  Creation Date:  2019-03-28
  Purpose/Change: Initial script development, All rights reserved.
  
.TODO UPDATE
  Ȱ�뵵�� ������ ������ ������ ���� ������ �� �ֵ��� ������Ʈ
#>


#---------------------------------------------------------[Initialisations]--------------------------------------------------------
$backupDir = "ZipBackUp"
$tobe_delete = ".vs debug"
#----------------------------------------------------------[Declarations]----------------------------------------------------------

#-----------------------------------------------------------[Functions]------------------------------------------------------------
function delete_dotvs_directory($zip_file, $folder_to_delete) {
    $7ZipPath = '"C:\Program Files\7-Zip\7z.exe"'
    $command = "& $7ZipPath -r d $zip_file $folder_to_delete"
    iex -Command $command
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

# BACKUP directory check and create
if(-Not (Test-Path -path $backupDir)){
    mkdir $backupDir
}

# COPY zip to backup directory
Get-ChildItem *.zip | 
Foreach-Object {
    Copy-Item -Path $_ -Destination $backupDir
}

# REMOVE .vs and debug folder from all the zip files
Get-ChildItem *.zip | 
Foreach-Object {
    delete_dotvs_directory($_, ".vs")
    delete_dotvs_directory($_, "debug")
}
