class_name Countdown
extends Control

@onready var label = $Label as Label
@export var countdown_secs := 3

var seconds_elapsed := 0
var timer
signal on_complete

func start():
	show()
	label.text = str(countdown_secs - seconds_elapsed)
	timer = Timer.new()
	timer.wait_time = 1
	timer.autostart = true
	timer.timeout.connect(on_timer_tick)
	add_child(timer)

func on_timer_tick():
	if seconds_elapsed == countdown_secs - 1:
		timer.stop()
		on_complete.emit()
	else:
		timer.start()
		seconds_elapsed += 1
		label.text = str(countdown_secs - seconds_elapsed)