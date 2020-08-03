import serial
import time

ser = serial.Serial('/dev/ttyUSB0', 9600, timeout = 0.2)

readOut = 0

print ("Starting up")
connected = False
sendTo_03 = '03z\r' # get the distance in mm
sendTo_0A = '0Az\r' # get the distance in mm

try:
	while True:
		for i in range(18):
			cmd = '{:02x}'.format(i+1) + 'z\r'
			print ("Writing: ",  cmd)
			ser.write(cmd.encode())
			time.sleep(0.3)

except KeyboardInterrupt:
	pass


#		while True:
#		    try:    
#		        readOut = ser.readline().decode('ascii')
#		        time.sleep(0.1)
#		        print ("Response: ", readOut) 
#		        break
#		    except:
#		        pass
#		ser.flush() #flush the buffer

