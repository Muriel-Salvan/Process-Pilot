@echo off
echo Hello World>&2
echo/|set /p ="Enter string: " >&2
set /p var= %=%
echo Hello %var%>&2
