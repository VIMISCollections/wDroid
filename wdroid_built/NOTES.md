### Anne's Notes ###
This folder contains the built version of wDroid, as this was not included when the Git repo was downloaded. 
The files were downloaded following the instructions in the README in the root-folder. 
CERTAIN FILES HAVE BEEN CREATED/CHANGED BY ME!! All changes I've made, I will describe in detail in these notes.

### Running wDroid ###
Downloaded Android Studio:
https://developer.android.com/studio/install

Make sure to follow instructions on how to install after download!
Downloaded the SDK Platform-Tools from here:
https://developer.android.com/tools/releases/platform-tools

Export ANDROID_HOME and configure PATH to let OS identify `adb` command (in Ubuntu):
export ANDROID_HOME="C:\Program Files\Android\Android Studio"
export PATH=$PATH:$ANDROID_HOME/platform-tools

And put that into the Android Studio folder. Added path to platform-tools to PATH.
The current version of Android Studio doesn't have an 'emulator' command, as is written in the cmd in the README. Instead, I used the Android program to manually create an emulator: 
More actions -> Virtual Device Manager -> '+' Create Virtual Device
I just created the 'Small Phone' with API 24.
Launch the device, then to see the emulator id, run this (in Git Bash):
adb devices
(Usually it has id emulator-5554)

Problems with some of the commands in run.sh. Therefore, I created a new file run1.sh, where I changed some commands. Notably, all paths now DON'T start with '/', and line 16 uses the '--bypass-low-target-sdk-block' option to bypass an error with the SDK API when trying to install apps.
Also, the line that calls the monkey tool uses options that don't exist (-n and -t). This causes monkey to throw an error and refuse running.

**The actual relevant script is now run2.sh!!**
Running the actual tool using a .sh script doesn't work! I don't know why! It seems all other parts of the script works, EXCEPT for when running monkey. 
The script run2.sh will do the setup, and open the emulator shell in the terminal. The user must then manually enter the folder wherein the monkey-executable is placed, and run the monkey tool to perform the analysis, to get a file with actual output. 

Run the tool (in Git Bash):
sh run2.sh emulator-5554 IMSI-Catcher com.SecUpwN.AIMSICD 3600 ../../qark/qark/myApks/Android-IMSI-Catcher-Detector.apk C:/Users/annem/Desktop

When it enters the emulator shell, run these lines:
cd data/local/tmp
monkey -p $3 -v -v -v --ignore-crashes --ignore-timeouts --kill-process-after-error --ignore-security-exceptions --pct-syskeys 0 --pct-nav 0 --bugreport 99999 | tee $3.txt
Where $3 is the name of the app-package.
Then 'exit' and rest of script will run.

For some reason, it seems like the monkey tool just doesn't run properly UNLESS it is called directly in the folder it's placed in. Calling it from root with a path doesn't work! So user must manually enter the relevant folder, and call it. 

**TESTING CMD**
This is the line I used to run monkey within the emulator for the app AIMSICD (the second entry in Dimitris' list). 
Another stupid thing in this script, is that the package name passed after the '-p' option is unknown to us till the app has been installed in the emulator. I found the name by entering the emulator shell, navigating to data/app and checking the content of that folder. There, I could see the package name of the app. 
monkey -p com.SecUpwN.AIMSICD -v -v -v --ignore-crashes --ignore-timeouts --kill-process-after-error --ignore-security-exceptions --pct-syskeys 0 --pct-nav 0 --bugreport 99999 | tee com.SecUpwN.AIMSICD.txt


**PROBLEMS RUNNING**
These problems MAY be caused by me giving wrong input.
The uninstall line doesn't work. It uses the folder-name provided by the user as input, but fx IMSI-Catcher gets the name com.SecUpwN.AIMSICD when installed, and the uninstall command expects this name!

The output I get doesn't make much sense. It's not what's promised in the README, and it generally is hard to understand...

ROOT ISSUES:
https://stackoverflow.com/questions/5095234/how-to-get-root-access-on-android-emulator
"If anyone is trying to get this to work on the new Google Play system images, adbd is set to secure in ramdisk.img. I was able to work around it by using ramdisk.img from the Google APIs image. I tested on both the 7.0 and 8.0 images."

TODO:
- Look at paper, see if it explains tool better
- Remove unused input variables from run2.sh

**Used links:**
https://github.com/RichardHoOoOo/wDroid
https://developer.android.com/studio/install
https://www.reddit.com/r/GooglePixel/comments/17bzbcy/install_failed_deprecated_sdk_version_any_way/
https://stackoverflow.com/questions/78964382/android-studio-emulator-running-but-not-visible-out-of-view
