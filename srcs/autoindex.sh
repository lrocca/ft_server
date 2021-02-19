#!/bin/bash

conf=/etc/nginx/sites-available/localhost.conf

reload() {
	service nginx reload
}

on() {
	sed -i 's|autoindex off|autoindex on|g' $conf
	sed -i 's|index index.php|index index.html index.php|g' $conf
	echo "autoindex on"
	reload
}

off() {
	sed -i 's|autoindex on|autoindex off|g' $conf
	sed -i 's|index index.html index.php|index index.php|g' $conf
	echo "autoindex off"
	reload
}

error() {
	echo "Error: $1"
	exit  1;
}

if ! [ -f $conf ]; then
	error "didin't find configuration file"
elif grep -q "autoindex off" $conf; then
	if [[ $1 == "off" ]]; then
		echo "autoindex was off";
		exit 1;
	else
		on;
	fi
elif grep -q "autoindex on" $conf; then
	if [[ $1 == "on" ]]; then
		echo "autoindex was on";
		exit 1;
	else
		off;
	fi
else
	error "didn't find autoindex directive";
fi


