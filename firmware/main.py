import board
import digitalio
import time
import busio
import adafruit_ds3231
import math

 # initialize the i2c bus and the clock chip
i2c = busio.I2C(board.SCL, board.SDA)
rtc = adafruit_ds3231.DS3231(i2c)
rtc.datetime = time.struct_time((2017, 1, 1, 5, 58, 55, 6, 1, -1))


 # class for moving the stepper motor... it's basic.
class QuickStepper:
	rawpins = []
	pins = []
	curStep = 0
	maxStep = 4

	def __init__(self, pin0, pin1, pin2, pin3):
		print("Running stepper init")
		self.rawpins = [pin0, pin1, pin2, pin3]
		self.pins = [digitalio.DigitalInOut(pin0),
			digitalio.DigitalInOut(pin1),
			digitalio.DigitalInOut(pin2),
			digitalio.DigitalInOut(pin3)]

		for pin in self.pins:
			print("Setting pin "+str(pin))
			pin.direction = digitalio.Direction.OUTPUT
			pin.value = False
		self.curStep = 0
		self.maxStep = 4
	
	def onestep(self):
		self.pins[self.curStep].value = False
		self.curStep += 1
		if self.curStep >= self.maxStep:
			self.curStep -= self.maxStep
		self.pins[self.curStep].value = True

	def steps(self, steps, sleep_time):
		while steps > 0:
			steps -= 1
			self.onestep()
			time.sleep(sleep_time)


 # gear teeth counts
motor_steps = 2048.0

second_sun_teeth = 11
second_ring_teeth = 19
second_spr = motor_steps*19.0/11.0

minute_sun_teeth = 13
minute_ring_teeth = 47
minute_spr = motor_steps*47.0/13.0

hour_sun_teeth = 17
hour_ring_teeth = 79
hour_spr = motor_steps*79.0/17.0



second_stepper = QuickStepper(board.D10, board.D11, board.D12, board.D13)
minute_stepper = QuickStepper(board.A0, board.A1, board.A2, board.A3)
hour_stepper = QuickStepper(board.A4, board.A5, board.SCK, board.MOSI)

old_seconds = rtc.datetime.tm_sec
old_minutes = rtc.datetime.tm_min
old_hours = rtc.datetime.tm_hour

second_error = 0
minute_error = 0
hour_error = 0

tics = 0
while True:
	timenow = rtc.datetime
	seconds = timenow.tm_sec
	minutes = timenow.tm_min
	hours = timenow.tm_hour
	
	if hours != old_hours :
		print("hours: " + str(hours) + " old_hours: " + str(old_hours) + " error: " + str(hour_error))
		hour_stepper.steps(math.floor((hour_spr+hour_error)/24), .005)
		hour_error = (hour_spr+hour_error)/24 - math.floor((hour_spr+hour_error)/24)
		old_hours = hours

	if minutes != old_minutes :
		print("minutes: " + str(minutes) + " old_minutes: " + str(old_minutes) + " error: " + str(minute_error))
		minute_stepper.steps(math.floor((minute_spr+minute_error)/60), .005)
		minute_error = (minute_spr+minute_error)/60 - math.floor((minute_spr+minute_error)/60)
		old_minutes = minutes

	# move the second hand
	if seconds != old_seconds :
		print("seconds: " + str(seconds) + " old_seconds: " + str(old_seconds) + " error: " + str(second_error))
		if seconds < old_seconds :
			old_seconds -= 60
		tics = seconds - old_seconds
		old_seconds = seconds
		print("tics: " + str(tics) + "\n")
		
		second_stepper.steps(math.floor((tics*second_spr+second_error)/60), .005)
		second_error = ((tics*second_spr+second_error)/60) - math.floor((tics*second_spr+second_error)/60)
		
 # pins:
 # ['A0', 'A1', 'A2', 'A3', 'A4', 'A5', 'SCK', 'MOSI', 'MISO', 'D0', 'RX', 'D1', 'TX', 'SDA', 'SCL', 'D5', 'D6', 'D9', 'D10', 'D11', 'D12', 'D13', 'NEOPIXEL']

