code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}
print_head(){
echo -e "\e[36m$1\e[0m"
}

status_check() {
if [ $1 -eq 0 ]; then
   echo SUCCESS
   else
   echo FAILURE
   echo "read the log file ${log_file} for more information about error"
   exit 1
   fi
   }
   systemd_setup() {
      print_head "copy systemd service file"
          cp  ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>{log_file}
          status_check $?

          print_head "reload systemd"
          systemctl daemon-reload &>>{log_file}
          status_check $?

          print_head "enable ${component} service"
          systemctl enable ${component} &>>{log_file}
          status_check $?

          print_head "start ${component} service"
          systemctl restart ${component} &>>{log_file}
          status_check $?
   }

   schema_setup() {

     if [ "${schema_type}" == "mongo" ]; then
         print_head "copy mongodb repo file"
          cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>{log_file}
          status_check $?

          print_head "install mongo clint"
          yum install mongodb-org-shell -y &>>{log_file}
          status_check $?

          print_head "load schema"
          mongo --host mongodb.aws43.xyz </app/schema/${component}.js &>>{log_file}
          status_check $?


           elif [ "${schema_type}" == "mysql" ]; then
            print_head "install mysql clint"
            yum install mysql -y &>>{log_file}
            status_check $?

            print_head "load schema"
           mysql -h mysql.aws43.xyz -uroot -p${mysql_root_password} < /app/schema/shipping.sql
            status_check $?
           fi
           }

   app_prereq_setup() {
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
          curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>{log_file}
          status_check $?
          cd /app

          print_head "extracting app content"
          unzip /tmp/${component}.zip &>>{log_file}
          status_check $?
   }


   node_js() {
     print_head "configure nodejs repo"
     curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>{log_file}
     status_check $?

     print_head "install nodejs"
     yum install nodejs -y &>>{log_file}
     status_check $?



     print_head "installing nodejs dependencies"
     npm install &>>{log_file}
     status_check $?



     schema_setup
     systemd_setup


 }



 java() {
   print_head "install maven"
 yum install maven -y &>>{log_file}
 status_check $?

 app_prereq_setup
 print_head "downloading dependencies and packaage"
 mvn clean package &>>{log_file}
 mv target/${component}-1.0.jar ${component}.jar &>>{log_file}
 status_check $?
 # schema setup function
 schema_setup
 # systemd function
  systemd_setup
 }






