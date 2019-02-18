#!/usr/bin/env python

import pigpio
import subprocess
import time

BUTTON_PIN = 16

pi = pigpio.pi('localhost')
pi.set_mode(BUTTON_PIN, pigpio.INPUT)
pi.set_pull_up_down(BUTTON_PIN, pigpio.PUD_UP)

while(True):
        if(pi.wait_for_edge(BUTTON_PIN, edge = pigpio.FALLING_EDGE,  wait_timeout = 5)):
                print("***DO NOT TURN OFF THE SYSTEM during the process\n" +
			"or you will damage the system irreversibly***")
		time.sleep(5)
		print("Backing up boot partition")
                time.sleep(2)
                #subprocess.call(["sudo", "backup_boot"])
                print("Boot partition back up finished")
                time.sleep(2)
                print("Restoring boot partition")
                #subprocess.call(["sudo", "/home/pi/update-reset/src/sbin/restore_boot"])
                print("Boot restore finished")
