from socket import *
import RPi.GPIO as GPIO
import time


led = 14
left1 = 6
left2 = 13
right1 = 19
right2 = 26
GPIO.setmode(GPIO.BCM)
GPIO.setup(led,GPIO.OUT)
GPIO.setup(left1,GPIO.OUT)
GPIO.setup(left2,GPIO.OUT)
GPIO.setup(right1,GPIO.OUT)
GPIO.setup(right2,GPIO.OUT)
GPIO.output(led,GPIO.LOW)
GPIO.output(left1,GPIO.LOW)
GPIO.output(left2,GPIO.LOW)
GPIO.output(right1,GPIO.LOW)
GPIO.output(right2,GPIO.LOW)

s = socket(AF_INET, SOCK_DGRAM)
print("socket created")
s.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1) 
s.bind(("192.168.0.103",9999))
print("Enter ^C to stop")
try:
    while True:
        print("Waiting for data...")
        data, addr = s.recvfrom(1024) # blocking
        instruction = data.decode("utf-8")
        print(instruction)
        instruction = instruction.split()
        power = instruction[0]
        angle = float(instruction[1])
        speed = float(instruction[2])
        print("power",power)
        print("angle",angle)
        print("speed",speed)
        if speed > 0.7:
            if angle > 315 or angle < 45:
                print("frontt")
                GPIO.output(left1,GPIO.LOW)
                GPIO.output(left2,GPIO.HIGH)
                GPIO.output(right1,GPIO.LOW)
                GPIO.output(right2,GPIO.HIGH)
            elif angle > 45 and angle < 135:
                print("right")
                GPIO.output(left1,GPIO.LOW)
                GPIO.output(left2,GPIO.HIGH)
                GPIO.output(right1,GPIO.HIGH)
                GPIO.output(right2,GPIO.LOW)
                
            elif angle > 135 and angle < 225:
                print("back")
                
                GPIO.output(left1,GPIO.HIGH)
                GPIO.output(left2,GPIO.LOW)
                GPIO.output(right1,GPIO.HIGH)
                GPIO.output(right2,GPIO.LOW)
            elif angle > 225 and angle < 315:
                print("left")
                GPIO.output(left1,GPIO.HIGH)
                GPIO.output(left2,GPIO.LOW)
                GPIO.output(right1,GPIO.LOW)
                GPIO.output(right2,GPIO.HIGH)
        else:
            print("stop")
            GPIO.output(left1,GPIO.LOW)
            GPIO.output(left2,GPIO.LOW)
            GPIO.output(right1,GPIO.LOW)
            GPIO.output(right2,GPIO.LOW)
        
except KeyboardInterrupt:
    print("stopping")
    GPIO.cleanup()
