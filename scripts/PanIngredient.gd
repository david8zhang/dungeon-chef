class_name PanIngredient
extends Node2D

@onready var button = $Sprite2D/Button as Button
@onready var sprite = $Sprite2D as Sprite2D
var ingredient_item: IngredientItem
var did_flip = false
var burn_tween: Tween
var cook_tween: Tween

enum CookTiming {
	EARLY,
	PERFECT,
	LATE
}

var top_side_timing = CookTiming.EARLY
var bottom_side_timing = CookTiming.EARLY

signal on_cooked(pan_ingredient)

func _ready():
	button.pressed.connect(on_flip)

func on_flip():
	if !did_flip:
		did_flip = true
		cook_other_side()
	else:
		on_cooked.emit(self)
		hide()

func set_ingredient_item(item: IngredientItem):
	ingredient_item = item
	sprite.texture = item.get_texture()

func begin_cooking():
	var on_finished = func _on_finished():
		sprite.modulate = Color(0, 1, 0)
		if !did_flip:
			top_side_timing = CookTiming.PERFECT
		else:
			bottom_side_timing = CookTiming.PERFECT

		# Set timer when perfect cook timing expires
		var expiry_timer = Timer.new()
		expiry_timer.wait_time = 0.5
		expiry_timer.autostart = true
		expiry_timer.one_shot = true
		var callable = Callable(self, "expire_perfect_timing")
		expiry_timer.timeout.connect(callable)
		add_child(expiry_timer)
		
		burn_tween = create_tween()
		burn_tween.tween_property(sprite, "modulate", Color(0, 0, 0, 1), 3.0)
	var cook_time = randi_range(5, 15)
	cook_tween = create_tween()
	cook_tween.tween_property(sprite, "modulate", Color(1, 0, 0, 1), float(cook_time))
	cook_tween.finished.connect(on_finished)

func cook_other_side():
	var on_finished = func _on_finished():
		sprite.modulate = Color(0, 1, 0)
		burn_tween = create_tween()
		burn_tween.tween_property(sprite, "modulate", Color(0, 0, 0, 1), 3.0)
	if burn_tween != null:
		burn_tween.stop()
	if cook_tween != null:
		cook_tween.stop()
	sprite.modulate = Color(1, 1, 1)
	var cook_time = randi_range(5, 15)
	cook_tween = create_tween()
	cook_tween.tween_property(sprite, "modulate", Color(1, 0, 0, 1), float(cook_time))
	cook_tween.finished.connect(on_finished)	

func expire_perfect_timing():
	if !did_flip:
		top_side_timing = CookTiming.LATE
	else:
		bottom_side_timing = CookTiming.LATE