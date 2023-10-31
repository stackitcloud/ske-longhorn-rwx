#!/bin/sh
chroot /host /usr/bin/sh <<"EOT"
if ! /usr/bin/systemctl is-active --quiet iscsid
then
    echo "Start Serice"
    /usr/bin/systemctl start iscsid
else
    echo "Service already "$(/usr/bin/systemctl is-active iscsid)
fi
if ! /usr/bin/systemctl is-enabled --quiet iscsid
then
    echo "Enable Service"
    /usr/bin/systemctl enable iscsid &> /dev/null
else
    echo "Service already "$(/usr/bin/systemctl is-enabled iscsid)
fi
EOT
sleep 60