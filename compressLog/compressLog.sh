#!/bin/bash
#####################################################################
#                                                                   #
# 日志以小时为一个文件保存，压缩的时候每一个日志文件一个gzip压缩进程#
# 控制gzip的数量不要超过24，防止机器负载过重                        #
#                                                                   #
#####################################################################
function compress() {  
   if [ ! -d $1$2/$3 ];then
      echo "$1$2/$3 not exist"
      return
   fi
   for file_name in `ls $1$2/$3`
   do
      file=$1$2/$3/$file_name
      if [ -f $file ]; then
         if [[ $file == *gz ]];then
            echo "already gzip $file"
         else
            count_process=$[$(ps -ef |grep "gzip $1" | wc -l)-1]
            if [ $count_process -lt 25 ];then
               echo "gzip $file"
               gzip $file&
            else 
               sleep 1m
            fi
        fi
      elif [ -d $file ]; then
          echo $file" Is a directory"
      else
          echo $file" unknow type"
      fi
   done
}
################################################################ 
#                                                              #
#  使用手册                                                    #
#                                                              #
################################################################    
function usage() {
  echo "Usage: $0 日志所在目录 少天以前的数据被压缩"
  exit
}
################################################################
#                                                              #
# 输入参数的合法性进行校验                                     #
#                                                              #
################################################################
if [ $# -ne 2 ];then
  usage
fi
if [[ $1 != */ ]];then
   compress_path=$1/
else
  compress_path=$1
fi
if [ ! -d $compress_path ];then
   echo $1" not exist!"
   exit
fi

if [ $2 -lt 1 ];then
   echo "第二个参数必须大于等于1"
   usage
fi
compress_date=`date +%Y-%m-%d --date="-$2 day"`
################################################################
#                                                              #
# 对不同服务进行顺序压缩                                       #
#                                                              #
################################################################
echo `date +%s`
for service in `ls $compress_path`
do
   compress $compress_path $service $compress_date 
done
echo `date +%s`
