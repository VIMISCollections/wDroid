 
if [ $# -ne 6 ]; then
    echo "usage $0 device_id app_name package_name running_time apk_path output_path"
    exit
fi

echo "Setting up phone..."
adb -s $1 shell mkdir -p data/local/tmp/dalvik-cache
adb -s $1 push monkey.jar data/local/tmp
adb -s $1 push monkey data/local/tmp 
adb -s $1 shell chmod 755 data/local/tmp/monkey 

echo "Setting up app..."
adb -s $1 uninstall $3
adb -s $1 shell rm -r data/local/tmp/$3.txt
adb -s $1 install $5
echo "Running monkey..."
adb -s emulator-5554 shell
echo "Getting bug report from device..."
rm -r $6/$3.txt
adb -s $1 pull data/local/tmp/$3.txt $6
echo "Clearing phone..."
adb -s $1 shell rm -r data/local/tmp/$3.txt
echo "Finished running!"