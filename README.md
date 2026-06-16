# create_new_shootday_folders
An Apple Script for iterating new shoot day folders for film / television / content creators to use as a Quick Action in MacOS
When working on a production iterating new shoot day folders to copy data to can be a repetitive task, especially for studio shoots which have regular splits.
This is a short Applescript that you can you safe as a Quick Action in MacOS - So you can right click a folder and under Quick Actions make new folders that iterate card rolls from the last shootdate.

Foldername Format:
The script assumes a folder format where there is any sort of prefix descriptor, followed by _YYMMDD format, followed by a _*### reel number
e.g MYSHOOT_260717_A001, MYSHOOT_260717_B001, MYSHOOT_260717_S001

It scans the folder for the most recent shootday in YYMMDD, asks you to enter the new shootdate, and then iterates by 1 a new folder name for that shootdate
so if you already had your folders: 
MYSHOOT_260717_A001, MYSHOOT_260717_B001, MYSHOOT_260717_S001 
and ran the Quick Action on the parent folder and you entered shoot date 260718 it would ask you to confirm to create folders:

MYSHOOT_260718_A002, MYSHOOT_260718_B002, MYSHOOT_260718_S002

If you want to iterate folders from the same day, just run the Quick Action again with the same shoot date 
it will iterate folder creation per reel letter by 1: 
- e.g if I ran it a second time with the shootdate 260718 it would now create

MYSHOOT_260718_A003, MYSHOOT_260718_B003, MYSHOOT_260718_S003

It doesn't ask to add new card letter or exclude card letters or anything like that for now - it just simply iterates from the last shoot date - in practice in a lot of cases this might mean you have to delete the most recently created folders for sound cards if you aren't doing sound card splits, and you will have to manually add in any new camera cards used on this day that weren't also shot on the prior day. 

It doesn't have any dependencies other than Applescript - this does mean it's Mac only - I may look at making a more generically useful script that also can create Avid Bins at the same time etc that is cross platform but this is really meant to be a simple, useful script.
Enjoy!
