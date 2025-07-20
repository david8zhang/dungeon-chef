class_name TemperatureBar
extends Node2D

@onready var optimal_zone = $FillRect/OptimalZone as ColorRect
@onready var fill_rect = $FillRect as ColorRect
@onready var temp_marker = $TempMarker as Sprite2D

var temp_increase_per_sec := 100
var num_zones = 0

const ZONE_MOVE_OFFSET = 50
const MAX_MOVEMENTS = 10
const ZONE_WIDTH = 50

var time_in_zone = 0
var total_time = 0

var is_complete := false
var check_zone_timer: Timer
signal on_complete(pct_time_in_zone)

func _process(delta: float) -> void:
	var fill_rect_left_x = fill_rect.global_position.x
	var fill_rect_right_x = fill_rect.global_position.x + fill_rect.size.x
	var amt_to_move
	if Input.is_action_pressed("increase_temperature"):
		amt_to_move = temp_increase_per_sec * delta
	if !Input.is_action_pressed("increase_temperature"):
		amt_to_move = -temp_increase_per_sec * delta
	if !is_complete:
		temp_marker.global_position.x = clamp(temp_marker.global_position.x + amt_to_move, fill_rect_left_x, fill_rect_right_x)

func start():
	var fill_rect_left_x = fill_rect.global_position.x
	var fill_rect_right_x = fill_rect.global_position.x + fill_rect.size.x
	optimal_zone.global_position.x = randi_range(fill_rect_left_x + ZONE_WIDTH / 2.0 + ZONE_MOVE_OFFSET, fill_rect_right_x - ZONE_WIDTH / 2.0 - ZONE_MOVE_OFFSET)
	optimal_zone.size = Vector2(ZONE_WIDTH, fill_rect.size.y)
	var num_movements = 0
	temp_marker.global_position.x = optimal_zone.global_position.x + optimal_zone.size.x / 2
	handle_random_zone_movements(num_movements, MAX_MOVEMENTS)

	check_zone_timer = Timer.new()
	check_zone_timer.wait_time = 0.1
	check_zone_timer.autostart = true
	var callable = Callable(self, "check_in_zone")
	check_zone_timer.timeout.connect(callable)
	add_child(check_zone_timer)

func check_in_zone():
	var optimal_zone_left_bound = optimal_zone.global_position.x
	var optimal_zone_right_bound = optimal_zone.global_position.x + optimal_zone.size.x
	var temp_marker_x = temp_marker.global_position.x
	if temp_marker_x >= optimal_zone_left_bound and temp_marker_x <= optimal_zone_right_bound:
		time_in_zone += 1
	total_time += 1


func handle_random_zone_movements(num_movements, max_movements):	
	if num_movements == max_movements:
		check_zone_timer.stop()
		var pct_in_zone = float(time_in_zone) / float(total_time)
		print("Percentage of time within zone: " + str(pct_in_zone))
		is_complete = true
		on_complete.emit(pct_in_zone)
		return
	var new_tween = create_tween()
	var left_bound = fill_rect.global_position.x + ZONE_WIDTH
	var right_bound = fill_rect.global_position.x + fill_rect.size.x - ZONE_WIDTH
	var rand_x = 0
	if optimal_zone.global_position.x - ZONE_MOVE_OFFSET < left_bound:
		rand_x = ZONE_MOVE_OFFSET
	elif optimal_zone.global_position.x + ZONE_MOVE_OFFSET > right_bound:
		rand_x = -ZONE_MOVE_OFFSET
	else:
		rand_x = -ZONE_MOVE_OFFSET if randi_range(0, 1) == 0 else ZONE_MOVE_OFFSET
	var pos_to_tween_to = optimal_zone.global_position.x + rand_x
	new_tween.tween_property(optimal_zone, "global_position:x", pos_to_tween_to, float(randi_range(2, 4)) / 2)
	var callable = Callable(self, "handle_random_zone_movements").bind(num_movements + 1, max_movements)
	new_tween.finished.connect(callable)
