#!/bin/sh

expect -c "
set timeout 1
spawn openssl req -new -key server.key -out server.csr

expect \"Country Name (2 letter code) \[AU\]:\"
send \"JP\r\"

expect \"State or Province Name (full name) \[Some-State\]\"
send \"Fukushiama\r\"

expect \"Locality Name (eg, city) \[\]:\"
send \"Iwaki\r\"

expect \"Organization Name (eg, company) \[Internet Widgits Pty Ltd\]:\"
send \"UmbrellaNotice\r\"

expect \"Organizational Unit Name (eg, section) \[\]:\"
send \"umbrellanotice team\r\"

expect \"Common Name (e.g. server FQDN or YOUR name) \[\]:\"
send \"www.umbrellanotice.work\r\"

expect \"Email Address \[\]:\"
send \"\r\"

expect \"A challenge password \[\]:\"
send \"notice\r\"

expect \"An optional company name \[\]:\"
send \"\r\"
"