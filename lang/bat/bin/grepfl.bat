@echo off

rem unixfind.exe . -type f -print 2>null


if not "%6" == "" (
   unixfind.exe . -type f -print 2>nul | egrep -i "%1" | egrep -i "%2" | egrep -i "%3" | egrep -i "%4" | egrep -i "%5" | egrep -i "%6"
   goto :end
)
if not "%5" == "" (
   unixfind.exe . -type f -print 2>nul | egrep -i "%1" | egrep -i "%2" | egrep -i "%3" | egrep -i "%4" | egrep -i "%5"
   goto :end
)
if not "%4" == "" (
   unixfind.exe . -type f -print 2>nul | egrep -i "%1" | egrep -i "%2" | egrep -i "%3" | egrep -i "%4" 
   goto :end
)
if not "%3" == "" (
   unixfind.exe . -type f -print 2>nul | egrep -i "%1" | egrep -i "%2" | egrep -i "%3" 
   goto :end
)
if not "%2" == "" (
   unixfind.exe . -type f -print 2>nul | egrep -i "%1" | egrep -i "%2" 
   goto :end
)
if not "%1" == "" (
   unixfind.exe . -type f -print 2>nul | egrep -i "%1"
   goto :end
)


:end
echo.
pause
