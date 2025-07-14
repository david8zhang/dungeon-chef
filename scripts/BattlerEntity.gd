class_name BattlerEntity
extends Node2D

@onready var game = get_node("/root/Game") as Game
@onready var health_bar = $HealthBar as ProgressBar
@onready var sprite = $Sprite2D as Sprite2D

var battler_entity_id := ""

func _ready() -> void:
	health_bar.value = health_bar.max_value
	toggle_highlight(false)

func get_curr_health():
	return health_bar.value

func init_healthbar():
	pass

func get_attack():
	return 0

func get_defense():
	return 0

func take_damage(damage):
	var label = Label.new()
	label.text = "-" + str(damage)
	label.add_theme_font_size_override("font_size", 20)
	label.z_index = 100
	game.add_child(label)
	label.global_position = Vector2(sprite.global_position.x, sprite.global_position.y)
	print(label.global_position)
	var on_tween_finished = func _on_tween_finished():
		label.queue_free()
	var tween = create_tween()
	var final_y_pos = label.global_position.y - 40
	tween.tween_property(label, "global_position:y", final_y_pos, 0.5)
	tween.finished.connect(on_tween_finished)
	health_bar.value -= damage

func get_full_name():
	return ""

func toggle_highlight(toggle_state: bool):
	var _material = sprite.material as ShaderMaterial
	_material.set_shader_parameter('width', 0 if !toggle_state else 1)

func is_dead():
	return get_curr_health() == 0

func play_death_anim(cb: Callable):
	var on_tween_finished = func _on_tween_finished():
		queue_free()
		cb.call()
	var tween = create_tween()
	sprite.material = null
	tween.tween_property(sprite, "modulate:a", 0, 0.75)
	tween.finished.connect(on_tween_finished)