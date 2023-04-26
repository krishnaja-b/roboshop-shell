source common.sh

print_head "disabling mysql version 8"
dnf module disable mysql -y &>>{log_file}
status_check $?

print_head "copy mysql repo file"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>{log_file}
status_check $?

print_head "installing my sql server"
yum install mysql-community-server -y &>>{log_file}
status_check $?

print_head "enable my sql server"
systemctl enable mysqld &>>{log_file}
status_check $?

print_head "start mysql server"
systemctl start mysqld &>>{log_file}
status_check $?

print_head "set root password"
mysql_secure_installation --set-root-pass RoboShop@1 &>>{log_file}
status_check $?

print_head "to check password working r not"
mysql -uroot -pRoboShop@1 &>>{log_file}
status_check $?
