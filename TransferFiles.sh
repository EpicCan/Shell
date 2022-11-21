#!/bin/bash
 eval "cd /backup/SFHIS/db_backup/file"
 echo $(date "+%Y-%m-%d %H:%M:%S") "Start executing the script" >> log.txt
 echo " " >> log.txt
 for file in `find . -type f -size +20000000000c -print` 
    do
        echo $file 
        file_size1=`ls -l $file | awk '{print $5}'`
        echo $(date "+%Y-%m-%d %H:%M:%S") "Get the file $file  size for the first time is $file_size1" >> log.txt
        echo " " >> log.txt
        echo "$file_size1"
        echo "Wait for 10s to determine if it is the latest file"
        sleep 10

        file_size2=`ls -l $file | awk '{print $5}'`
        echo $(date "+%Y-%m-%d %H:%M:%S") "Get the file $file  size for the second time is $file_size2" >> log.txt
        echo " " >> log.txt 
        echo "$file_size2"

        #>20GB
        if [[ $file_size1 -gt 20000000000 ]] && [[ "$file_size1" = "$file_size2" ]];
        then
        echo "Files larger than 20G and not up to date, start transferring..."
        echo $(date "+%Y-%m-%d %H:%M:%S") "Start uploading files with FTP when the conditions are met" >> log.txt
        echo " " >> log.txt
        ftp -v -n 192.16.20.150 5100<<EOF
        user admin Cim2020inesa
        binary
        cd /serverbackup/hisdbbackup
        lcd /backup/SFHIS/db_backup/file
        prompt
        put $file
        bye
        here document
EOF
        
        echo "put is ok!"

        file_size3=`ftp -v -n 192.16.20.150 5100<<EOF
        user admin Cim2020inesa
        cd /serverbackup/hisdbbackup
        size $file
        bye
        #here document
EOF`  
        
        echo "Gets the upload file size"
        file_size4="$file_size3" 
        file_size5=`echo "${file_size3}" | awk '{print $2}' | sed -n '6p'`
        echo "The file size after uploading is is $file_size5"
        echo $(date "+%Y-%m-%d %H:%M:%S") "Gets the file $file size after uploading is $file_size5" >> log.txt
        echo " " >> log.txt 
        echo " "
         if [[ $file_size1 = $file_size5 ]]
         then
         echo $(date "+%Y-%m-%d %H:%M:%S") "The upload is successful" >> log.txt
         echo " " >> log.txt 
         echo "The file size is consistent before and after uploading "
         echo $(date "+%Y-%m-%d %H:%M:%S") "The file size is consistent before and after uploading" >> log.txt 
         echo " " >> log.txt 
         eval "rm -f $file"
         echo $(date "+%Y-%m-%d %H:%M:%S")"The file was deleted successfully before uploading" >> log.txt 
         echo " " >> log.txt
         else
         echo $(date "+%Y-%m-%d %H:%M:%S")"The upload failed, and the file size is inconsistent before and after uploading" >> log.txt 
         echo " " >> log.txt 
         echo "not equals"
         fi
        fi
    done