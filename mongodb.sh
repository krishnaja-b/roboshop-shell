source common.sh
print_head "setup mogodb repository"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo
print_head "install mongodb"
yum install mongodb-org -y
print_head "update mongodb listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
print_head "enable mongodb"
systemctl enable mongod
print_head "start mongodb service"
systemctl restart mongod

#update /etc/mongod.conf file from 127.0.0.1 with 0.0.0.0




