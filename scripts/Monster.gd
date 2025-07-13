class_name Monster
extends Node2D

@export var monster_stats: MonsterStats

@onready var game = get_node("/root/Game") as Game
@onready var sprite = $Sprite2D as Sprite2D
@onready var health_bar = $HealthBar as ProgressBar
var monster_id := ""

func _ready():
	health_bar.max_value = monster_stats.max_health
	health_bar.value = health_bar.max_value

func get_monster_name():
	return monster_stats.monster_name

func get_curr_health():
	return health_bar.value

func get_attack():
	return monster_stats.attack

func get_defense():
	return monster_stats.defense

func take_damage(damage):
	var label = Label.new()
	label.text = "-" + str(damage)
	label.add_theme_font_size_override("font_size", 20)
	game.add_child(label)
	label.global_position = Vector2(sprite.global_position.x, sprite.global_position.y)
	var on_tween_finished = func _on_tween_finished():
		label.queue_free()
	var tween = create_tween()
	var final_y_pos = label.global_position.y - 40
	tween.tween_property(label, "global_position:y", final_y_pos, 0.75)
	tween.finished.connect(on_tween_finished)
	health_bar.value -= damage
