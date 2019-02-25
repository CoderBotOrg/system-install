#!/usr/bin/env python

import pigpio
import subprocess
import time
import os

BUTTON_PIN = 16

pi = pigpio.pi('localhost')
pi.set_mode(BUTTON_PIN, pigpio.INPUT)
pi.set_pull_up_down(BUTTON_PIN, pigpio.PUD_UP)

doreset = False #flag to see if restore is on
doreset1 = os.path.isfile('/boot/doreset')      # checks if flag doreset is there
#doreset2 = SECOND/PATH/TO/FLAG


while(True):
        # prints in log the tail of the restore process (after reboot and restore)
        if(doreset and (not doreset1)):
                print("[ OK ]")
                print("Restoring boot kernel...")
                print("[ OK ]") 
                doreset = False

        if(pi.wait_for_edge(BUTTON_PIN, edge = pigpio.FALLING_EDGE,  wait_timeout = 5)):
                doreset = True
                #deletes the log file. if that doesn't exist, create one
                with open('/home/pi/log/reset_trigger_service.log', 'w+'): pass
                print("Creating FLAG (doreset) for reset...")
                open("/home/pi/doreset", 'a').close()   # creates flag doreset inside (/boot)
                print("[ OK ]")
                print("Rebooting...")
                os.system('sudo reboot')      			# reboots system to trigger reset