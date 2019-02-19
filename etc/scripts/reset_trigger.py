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
                print("Backing up boot partition")
                #subprocess.call(["sudo", "backup_boot"])
                print("Boot partition back up finished")
                print("Restoring boot partition")
                #subprocess.call(["sudo", "/home/pi/update-reset/src/sbin/restore_boot"])
                print("Boot restore finished")
