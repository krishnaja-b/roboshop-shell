yum install nginx -y
 rm -rf /usr/share/nginx/html/*
 curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
 cp /configs/nginx-roboshop.config /etc/nginx/default.d/roboshop.conf
 cd /usr/share/nginx/html
 unzip /tmp/frontend.zip
 systemctl enable nginx
 systemctl restart nginx

























