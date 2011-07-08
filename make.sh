gcc -undefined dynamic_lookup  -lreadline -shared -I/opt/local/include -L/opt/local/lib readline.c -o readline.so
gcc -undefined dynamic_lookup -dynamiclib -std=c99 -o gslsupport.dylib gslsupport.c
#echo "\nNow copy the .so libraries to your MacPorts lua installation (usually /opt/local/lib/lua/5.1)"