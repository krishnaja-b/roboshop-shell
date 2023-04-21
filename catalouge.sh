source common.sh
print_head "configure nodejs repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>{log_file}
status_check $?
print_head "install nodejs"
yum install nodejs -y &>>{log_file}
status_check $?

print_head "create roboshop user"
id roboshop &>>{log_file}
if [ $? -ne 0 ]; then
  useradd roboshop &>>{log_file}
  fi
    status_check $?
print_head "create application directory"
if [ ! -d /app ]; then
  mkdir /app &>>{log_file}
    fi
status_check $?
print_head "delete old content"
rm -rf /app/* &>>{log_file}
status_check $?

print_head "downloading app content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>{log_file}
status_check $?
cd /app
print_head "extracting app content"
unzip /tmp/catalogue.zip &>>{log_file}
status_check $?
print_head "installing nodejs dependencies"
npm install &>>{log_file}
status_check $?
print_head "copy systemd service file"
cp  ${code_dir}/configs/catalouge.service /etc/systemd/system/catalouge.service &>>{log_file}
status_check $?
print_head "reload systemd"
systemctl daemon-reload &>>{log_file}
status_check $?

print_head "enable catalouge service"
systemctl enable catalogue &>>{log_file}
status_check $?
print_head "start catalouge service"
systemctl start catalogue &>>{log_file}
status_check $?
print_head "copy mongodb repo file"
cp configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>{log_file}
status_check $?
print_head "install mongo clint"
yum install mongodb-org-shell -y &>>{log_file}
status_check $?
print_head "load schema"
mongo --host mongodb.aws43.xyz </app/schema/catalogue.js &>>{log_file}
status_check $?







