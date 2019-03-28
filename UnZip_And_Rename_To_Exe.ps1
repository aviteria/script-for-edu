<#
.SYNOPSIS
  패스워드가 설정된 악성코드 zip 파일을 풀고, 실행파일을 찾아 확장자 .exe를 붙여주는 스크립트
.DESCRIPTION
  1. ZIP 파일을 보관할 BACKUP 디렉토리를 생성 (있으면 생성하지 않음)
  2. 패스워드가 설정된 zip 파일의 압축을 해제 (7-zip 프로그램을 사용, 압축파일 원본은 BACKUP)
  3. 실행파일(MZ)을 찾아 파일의 확장자(.exe) 추가 (원본 파일은 삭제)
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
