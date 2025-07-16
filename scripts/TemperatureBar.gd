class_name TemperatureBar
extends Node2D

@onready var optimal_zone = $FillRect/OptimalZone as ColorRect
@onready var fill_rect = $FillRect as ColorRect
@onready var temp_marker = $TempMarker as Sprite2D

var temp_increase_per_sec := 100
var num_zones = 0

const ZONE_MOVE_OFFSET = 50
const MAX_MOVEMENTS = 15
const ZONE_WIDTH = 50

var is_complete := false
signal on_complete

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


func handle_random_zone_movements(num_movements, max_movements):	
	if num_movements == max_movements:
		is_complete = true
		on_complete.emit()
		return
	var new_tween = create_tween()
	var left_bound = fill_rect.global_position.x + ZONE_WIDTH / 2.0
	var right_bound = fill_rect.global_position.x + fill_rect.size.x - ZONE_WIDTH / 2.0
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
