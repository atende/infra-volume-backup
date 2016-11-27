#!/bin/ash
if [ ! -f ~/.rclone.conf ]; then
    echo "Creating rclone.conf file using RCONF env variables..."
    echo "[backup]" > ~/.rclone.conf
    for svar in `env | awk -F "=" '{print}' | grep ".*RCONF.*"`
    do
        new_var_name=`echo $svar | cut -f1 -d= | cut -f2- -d_ | awk '{print tolower($0)}'` 
        new_var_value=`echo $svar | cut -f2 -d=` 
        echo "$new_var_name = $new_var_value" >> ~/.rclone.conf
    done
else
   echo "Using existing ~/.rclone.conf file"
fi