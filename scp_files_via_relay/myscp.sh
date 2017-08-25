#!/usr/bin/expect
set relay_password "password" # 登录relay的密码
set worker_password "worker"  # 登录目标服务器的密码
set proxyCommand "-o ProxyCommand=ssh -q username@relayhost -W %h:%p"  # 登录relay的用户名和地址
if {$argc == 2} {
   set option -r
   set src [lindex $argv 0]
   set dst [lindex $argv 1]
} elseif {$argc == 3} {
   set option [lindex $argv 0]
   set src [lindex $argv 1]
   set dst [lindex $argv 2]
} else {
   puts "usage: scp \[-12346BCpqrv\] \[-c cipher\] \[-F ssh_config\] \[-i identity_file\]"
   puts "           \[-l limit\] \[-o ssh_option\] \[-P port\] \[-S program\]"
   puts "           \[\[user@\]host1:\]file1 ... \[\[user@\]host2:\]file2"
   exit 1
}
spawn scp $proxyCommand $option $src $dst
set timeout 2
expect {
      "username@relayhost's password" {   # 登录relay自动输入密码期望遇到的字符
          send "$relay_password\n"
          exp_continue
      }
      "Are you sure you want to continue connecting (yes/no)?" {
          send "yes\r"
          exp_continue
      }
      "worker@*password" {              # 登录目标服务器自动输入密码期望遇到的字符
          send "$worker_password\n"
          exp_continue
      }
}

expect "long@localhost*" # 标识文件传输完成时，期望遇到的字符
interact
