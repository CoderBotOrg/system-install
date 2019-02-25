#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pigpio
import time
import os

# setting up service script parameters
BUTTON_PIN = 16

pi = pigpio.pi('localhost')
pi.set_mode(BUTTON_PIN, pigpio.INPUT)
pi.set_pull_up_down(BUTTON_PIN, pigpio.PUD_UP)



while(True):
		#waiting for falling edge
		if(pi.wait_for_edge(BUTTON_PIN, edge = pigpio.FALLING_EDGE)):
				start_time = time.time() 						   # initial time
				while pi.read(BUTTON_PIN) == 0: 				   # counts how much time button is pressed
						buttonTime = time.time() - start_time	  # How long was the button down?
						if buttonTime >= 3:
								#deletes the log file. if that doesn't exist, create one
								with open('/home/pi/log/reset_trigger_service.log', 'w+'): pass
								print("Creating FLAG (doreset) for reset...")
								open("/boot/doreset", 'a').close() # creates flag doreset inside (/boot)
								print("[ OK ]")
								print("Rebooting + boot kernel restore...")
								os.system('sudo reboot')		   # reboots system to trigger reset
								break 							   # avoid duplicate in logs because of signal delay