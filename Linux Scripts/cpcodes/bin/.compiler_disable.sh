#!/bin/bash

echo "Disable compilers might have unexpected results"
echo "Such as:"
echo score
echo 
echo VULNERABILITIES:	14 out of 15
echo POINTS:			70 out of 80
echo 
echo sh: 1: cc: Permission denied
echo shc: Success
echo mv: cannot stat ‘/ScoreEngine/send.sh.x’: No such file or directory

exit 0;

for i in /usr/bin/yacc /usr/bin/bcc /usr/bin/kgcc /usr/bin/cc /usr/bin/gcc; do
  if [ -f $i ]; then
    chmod 000 $i
  fi
done

for i in $(ls /usr/bin/*c++ 2>/dev/null); do
  if [ -f $i ]; then
    chmod 000 $i
  fi
done

for i in $(ls /usr/bin/*g++ 2>/dev/null); do
  if [ -f $i ]; then
    chmod 000 $i
  fi
done
