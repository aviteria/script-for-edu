<#
.SYNOPSIS
  디렉토리의 zip 파일들을 찾아, 내부의 .vs 디렉토리(숨김속성), Debug디렉토리를 삭제하는 스크립트 '
  학생 과제 정리를 위해 작성함
.DESCRIPTION
  1. ZIP 파일을 보관할 BACKUP 디렉토리를 생성 (있으면 생성하지 않음)
  2. 패스워드가 설정된 zip 파일의 압축을 해제 (7-zip 프로그램을 사용, 압축파일 원본은 BACKUP)
  3. 실행파일(MZ)을 찾아 파일의 확장자(.exe) 추가 (원본 파일은 삭제)
.NOTES
  Version:        1.0
  Author:         Seungsuk Ryoo
  Creation Date:  2019-03-28
  Purpose/Change: Initial script development, All rights reserved.
  
.TODO UPDATE
  활용도가 높으면 삭제할 파일을 쉽게 지정할 수 있도록 업데이트
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