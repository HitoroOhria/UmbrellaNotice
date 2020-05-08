#!/bin/sh

expect -c "
set timeout 5
spawn openssl req -new -key server.key -out server.csr

expect -regexp \"Country Name \(2 letter code\) \[.*\]:\"
send \"JP\r\"

expect -regexp \"State or Province Name (full name) \[.*\]\"
send \"Fukushima\r\"

expect -regexp \"Locality Name (eg, city) \[.*\]:\"
send \"Iwaki\r\"

expect -regexp \"Organization Name (eg, company) \[.*\]:\"
send \"UmbrellaNotice\r\"

expect -regexp \"Organizational Unit Name (eg, section) \[.*\]:\"
send \"umbrellanotice team\r\"

expect -regexp \"Common Name (e.g. server FQDN or YOUR name) \[.*\]:\"
send \"www.umbrellanotice.work\r\"

expect -regexp \"Email Address \[.*\]:\"
send \"\r\"

expect -regexp \"A challenge password \[.*\]:\"
send \"notice\r\"

expect -regexp \"An optional company name \[.*\]:\"
send \"\r\"
"