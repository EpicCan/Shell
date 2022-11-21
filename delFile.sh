#!/bin/bash
function clear(){
  if [ -d $1 ];then
    for f in ` ls $1 `
      do
         file=$1$f
         a1=`stat -c %Y $file`
         b1=`date +%s`
         # 3600 -- 1h
         # 86400 -- 1d
         # 1209600 -- 14d
         # 1296000 -- 15d
         # Delete files that were last modified more than 15 days ago 
         if [ $[ $b1 - $a1 ] -gt 1296000 ];then
                          rm -rf $file
         fi
      done
  else
     echo "目录不存在"
  fi
}
dirPath1="/volume1/serverbackup/hisdbbackup/"
clear $dirPath1