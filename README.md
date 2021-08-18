# Huion Tablet Bash Script
Simple script for Huion tablets on Arch GNU/Linux running Xorg

**This guide will be written with Arch Linux in mind, this may or may not work on other distros.**

**I've only tested this method on one tablet (Huion Kamvas Pro 13) using only Krita, your mileage may vary.**
```diff
+ You can follow the written guide or use the script provided in the repo
```
## Prerequisites

Install required packages with pacman.
```
# pacman -S xf86-input-wacom xorg-xinput xorg-xrandr xorg-xev
```

## Information Gathering/Testing

First we begin by running ```xinput``` here we wil see all the tablets input devices.

For me it prints ```Tablet Monitor Pen stylus``` and ```Tablet Monitor Pad pad```

Next to ```Tablet Monitor Pen stylus``` it will display an id, keep that in mind or run xinput again.

Now we will run ```xrandr``` to see which port the tablet is outputting on from the GPU, for me it was ```HDMI-1```

Lastly we can now test if we can lock the stylus to one monitor ie. the tablet display by running:

```Tablet Monitor Pen stylus ID here``` ```xrandr port here```

Formatted for me: ```xinput map-to-output 13 HDMI-1```

Test if the pen stays on the tablets monitor.

## Configuration

Create a new file ```# nano /etc/X11/xorg.conf.d/50-huion.conf```

Input:
```
# Huion tablets
Section "InputClass"
    Identifier "Huion class"
    MatchProduct "GENERIC" 
    MatchIsTablet "on"
    MatchDevicePath "/dev/input/event*"
    Driver "wacom"
EndSection
```
*Note: MatchProduct must include a generic term that describes both the Stylus and Pad device seen in xinput, for me it was MatchProduct "Tablet Monitor"*

Logout and login to refresh Xorg.

Verify that the tablet is running the Wacom driver with ```$ xsetwacom list devices```

It should look something like this:
```
Tablet Monitor Pen stylus       	id: 8	type: STYLUS    
Tablet Monitor Pad pad          	id: 9	type: PAD
```
**This is all you need to do if you only want to draw on the tablet with pen pressure, if you want to map buttons on the tablet continue with the next step**

## Buttons

First we must run ```# xev -event button```

Here a window will appear click inside the black square to begin recording keystrokes.

Start pressing the buttons on the tablet, they should look like this:

```
ButtonPress event, serial 25, synthetic NO, window 0x1a00001,
    root 0x2a0, subw 0x0, time 3390669, (404,422), root:(1047,444),
    state 0x0, button 1, same_screen YES
 ```
 
Take note of what "button" number it outputs into the console for each respective button on the tablet. 

We can map the buttons using the wacom drivers.

Here we need to take the device name of the "Pad" device in ```xinput``` mine is ```Tablet Monitor Pad pad``` OR use the ID we saw in ```xinput``` Replace 'TABLET_PAD_INPUT_DEVICE_NAME_OR_ID_HERE'

BUTTON should be what xev outputs per key on the tablet eg. ```button 3```

KEY should be whatever key on the keyboard eg. ```F12```

```$ xsetwacom --set 'TABLET_PAD_INPUT_DEVICE_NAME_OR_ID_HERE' BUTTON "key KEY"```

My example: ```$ xsetwacom --set 'Tablet Monitor Pad pad' button 3 "key F12"```

This should map whatever key you want on the tablets buttons.

