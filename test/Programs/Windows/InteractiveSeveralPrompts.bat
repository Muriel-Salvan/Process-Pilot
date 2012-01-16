@echo off
echo STDOUT Line 1
set /p var="Enter string 1 from STDOUT: " %=%
echo STDOUT Line 2 %var%
echo "STDERR Line 1">&2
echo/|set /p ="Enter string 2 from STDERR: " >&2
set /p var= %=%
echo STDOUT Line 3 %var%
echo "STDERR Line 2">&2
