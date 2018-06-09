import board
import digitalio
import time
from adafruit_motor import stepper
 
pin1 = digitalio.DigitalInOut(board.D10)
pin2 = digitalio.DigitalInOut(board.D11)
pin3 = digitalio.DigitalInOut(board.D12)
pin4 = digitalio.DigitalInOut(board.D13)

pin1.direction = digitalio.Direction.OUTPUT
pin2.direction = digitalio.Direction.OUTPUT
pin3.direction = digitalio.Direction.OUTPUT
pin4.direction = digitalio.Direction.OUTPUT

stepper1 = stepper.StepperMotor(board.D10, board.D11, board.D12, board.D13)
 
while True:
#    print(dir(board))
    pin1.value = False
    pin2.value = True
    time.sleep(.01)
    pin2.value = False
    pin3.value = True
    time.sleep(.01)
    pin3.value = False
    pin4.value = True
    time.sleep(.01)
    pin4.value = False
    pin1.value = True
    time.sleep(.01)

