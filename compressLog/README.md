# 简介

对归档日志进行压缩。对于几天前的日志，很少去查看，但是必须要保存。如果不压缩，磁盘空间浪费严重。该脚本的功能就是对历史日志进行并行压缩

## 使用方式

./compressLog.sh /data/ 4

第一个参数： 日志保存目录

第二个参数： 距离今天多少天以前的日志进行压缩
