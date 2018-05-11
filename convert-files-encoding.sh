#!/bin/bash
#set -x  # echo on

# Usage:
#  $ "./convert-files-encoding.sh" -p="/tmp" -t="*.py *.xml" -i="windows-1251" -o="utf-8"
#  $ "./convert-files-encoding.sh" -p="./cpp/problem-solving-in-cpp/" -t="*.hpp *.cpp" -i="windows-1251" -o="utf-8"

for i in "$@"
do
case $i in
    -p=*|--path=*)
        path="${i#*=}"
        shift # past argument=value
        ;;
    -t=*|--types=*)
        file_types="${i#*=}"
        shift # past argument=value
        ;;
    -i=*|--inencoding=*)
        inencoding="${i#*=}"
        shift # past argument=value
        ;;
    -o=*|--outencoding=*)
        outencoding="${i#*=}"
        shift # past argument=value
        ;;
    --default)
        path="/tmp"
        file_types="*.py *.xml"
        inencoding='windows-1251'
        outencoding="utf-8"
        shift # past argument with no value
        ;;
    *)
          # unknown option
    ;;
esac
done

for file_type in $file_types; do
    for file in $(find "$path" -name "$file_type"); do
        file_encoding=$(chardet $file | awk '{print $2}')
        if [ "$file_encoding" != "$outencoding" ]; then

            # Если входная кодировка не задана, то в качестве исходной используется кодировка определенная с помощью chardet:
            if [ -z "$inencoding" ]; then
                inencoding=$file_encoding
            fi
            
            # Если задана входная кодировка через -i или --inencoding, то предполагается, что файл именно в этой кодировке.

            echo "recode $inencoding..$outencoding $file"
            recode $inencoding..$outencoding "$file"
        fi    
    done
done

