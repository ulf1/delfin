# login credentials
username=root
passwort=topsecret

# process monitor
mysqladmin -u ${username} -p extended-status processlist

# mytop
mytop -u ${username} -p ${passwort}

# innotop
innotop -u ${username} -p ${passwort}
