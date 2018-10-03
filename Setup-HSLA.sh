#!/bin/bash

# Define script variables
system_serial=`system_profiler SPHardwareDataType | awk '/Serial/ {print $4}'`
loggedInUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

# Open Jamf Log so setup can be monitored
su $loggedInUser -c 'open /var/log/jamf.log'

# Finder FUT policies
echo "==================================================================================" >> /var/log/jamf.log
echo "Installing Finder FUT policies - will not be shown until restart..." >> /var/log/jamf.log
jamf policy -event FinderDEP
echo "==================================================================================" >> /var/log/jamf.log

# Creating sucadmin
echo "==================================================================================" >> /var/log/jamf.log
echo "Creating sucadmin..." >> /var/log/jamf.log
jamf policy -event DEPMakeSucadmin
echo "==================================================================================" >> /var/log/jamf.log

# Setting some device defaults
echo "==================================================================================" >> /var/log/jamf.log
echo "Running SA device customization+management policies..." >> /var/log/jamf.log
jamf policy -event EnableRemoteMgmtDEP
jamf policy -event SetTimeServer
jamf policy -event EnableLocation
jamf policy -event lab-wallpaper
jamf policy -event PI_setfirmware
echo "==================================================================================" >> /var/log/jamf.log

# Installing Google Chrome, enabling auto-updates
echo "==================================================================================" >> /var/log/jamf.log
echo "Installing current version of Google Chrome..." >> /var/log/jamf.log
jamf policy -event ChromeCurrent
echo "==================================================================================" >> /var/log/jamf.log

# Installing Adobe CC
echo "==================================================================================" >> /var/log/jamf.log
echo "Installing Adobe CC. Please wait, 11gb file..." >> /var/log/jamf.log
jamf policy -event AdobeCC
echo "==================================================================================" >> /var/log/jamf.log

## Installing VMWare Fusion
#echo "==================================================================================" >> /var/log/jamf.log
#echo "Installing VMWare Fusion + Win10 VM with SolidWorks..." >> /var/log/jamf.log
#jamf policy -event LabVMWare
#echo "==================================================================================" >> /var/log/jamf.log

# Installing Office 2011 + updates, deleting Outlook
echo "==================================================================================" >> /var/log/jamf.log
echo "Installing Office 2011 + updates, deleting Outlook..." >> /var/log/jamf.log
jamf policy -event Office2011
echo "==================================================================================" >> /var/log/jamf.log

# Installing VLC
echo "==================================================================================" >> /var/log/jamf.log
echo "Installing current version of VLC" >> /var/log/jamf.log
jamf policy -event VLC-current
echo "==================================================================================" >> /var/log/jamf.log

# Installing Sublime Text 3
echo "==================================================================================" >> /var/log/jamf.log
echo "Installing current version of Sublime Text 3" >> /var/log/jamf.log
jamf policy -event SublimeText3
echo "==================================================================================" >> /var/log/jamf.log

# Installing MAMP Stack
echo "==================================================================================" >> /var/log/jamf.log
echo "Installing MAMP" >> /var/log/jamf.log
jamf policy -event MAMP
echo "==================================================================================" >> /var/log/jamf.log

# Installing Node.js
echo "==================================================================================" >> /var/log/jamf.log
echo "Installing Node.js" >> /var/log/jamf.log
jamf policy -event nodejs
echo "==================================================================================" >> /var/log/jamf.log

# Installing Flash, Java, and JRE + JDK
echo "==================================================================================" >> /var/log/jamf.log
echo "Installing current versions Flash, Java, and JRE + JDK..." >> /var/log/jamf.log
jamf policy -event LabPlugins
echo "==================================================================================" >> /var/log/jamf.log

# Setting up user Dock
echo "==================================================================================" >> /var/log/jamf.log
echo "Configuring Dock..." >> /var/log/jamf.log
jamf policy -event LabDock
echo "==================================================================================" >> /var/log/jamf.log

# Creating 'Last Imaged' and 'Image Config' tokens
echo "==================================================================================" >> /var/log/jamf.log
echo "Creating Staff High Sierra token and running recon..." >> /var/log/jamf.log
jamf policy -event config-hslamaclab
echo "==================================================================================" >> /var/log/jamf.log

 Installing Deep Freeze
echo "==================================================================================" >> /var/log/jamf.log
echo "Installing Deep Freeze. Config will be frozen following 2 reboots..." >> /var/log/jamf.log
jamf policy -event DeepFreeze
echo "==================================================================================" >> /var/log/jamf.log

/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType hud -title "Alert" -heading "Device Setup Complete ✅" -description "Your computer has been successfully prepared! To finalize setup, please restart now. Following restart, please sign in, and reboot again to freeze configuration.

Select 'Restart Now' to close all programs and restart immediately.
Select 'Restart Later' to complete device setup later."  -button1 "Restart now" -button2 "Restart later" -defaultButton 1 -cancelButton 2 -alignDescription left -alignHeading left

# Take action based on exit code
if [ $? -eq 0 ]
then
	echo "Device setup complete. Rebooting..." >> /var/log/jamf.log
	jamf policy -event LabReboot
else
	echo "User opted out of reboot. Exiting..." >> /var/log/jamf.log
fi

exit 0