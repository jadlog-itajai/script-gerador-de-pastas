@echo off
SetLocal EnableDelayedExpansion

set /p groupSize=Infome a quantidade de arquivos por pasta (apenas numeros):
set /a groupSize=%groupSize%+0
if %groupSize%==0 (
    echo Quantidade invalida
    pause
    exit
)

set fileCount=0
set foldersAmount=0
set folderCounter=1
set copiesCounter=0
set folderPrefix=arquivos_

cls
for %%f in (*.xml) do (
    set /a fileCount=fileCount+1
)

if %fileCount%==0 (
    cls
    echo Nenhum arquivo xml foi encontrado na pasta.
    pause
    exit
)

echo %fileCount% Arquivos encontrados.

set /a foldersAmount=(fileCount/groupSize)

if %%fileCount% %% %%groupSize% NEQ 0 (
  set /a foldersAmount=foldersAmount+1
)

echo %foldersAmount% Pastas serao criadas.

for /l %%x in (1, 1, %foldersAmount%) do (
    mkdir %folderPrefix%%%x > nul 2>&1
)

echo Movendo arquivos...
for %%f in (*.xml) do (
    rem copy %%f %folderPrefix%!folderCounter! > nul 2>&1
    move %%f %folderPrefix%!folderCounter! > nul 2>&1

    set /a copiesCounter=copiesCounter+1

    if !copiesCounter! == %groupSize% (
        set /a folderCounter=folderCounter+1
        set /a copiesCounter=0
    )
)

rem Zips all created folders. But only works on recent Windows 10 versions. As the target of this is script runs Windows 7 it is disabled.
rem echo Compactando arquivos...
rem for /l %%x in (1, 1, %foldersAmount%) do (
rem     tar -cf %folderPrefix%%%x.zip %folderPrefix%%%x
rem )

echo Processo finalizado.
pause
exit