import serial
import time

ser = serial.Serial('/dev/ttyUSB0', 9600, timeout = 0.2)

def printCMD(cmd):
	print ("Writing: ",  cmd)
	ser.write(cmd.encode())
	time.sleep(0.1)

try:
		printCMD('0bz\r')
		try:
			readOut = ser.readline().decode('ascii')
			time.sleep(0.1)
			print ("Response: ", readOut)
		except:
			pass

except KeyboardInterrupt:
	pass
