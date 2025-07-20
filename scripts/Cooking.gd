class_name Cooking
extends Node2D

@onready var frying_pan_button = $CanvasLayer/FryingPan as Button
@onready var boiling_pot_button = $CanvasLayer/BoilingPot as Button
@onready var plating_button = $CanvasLayer/Plating as Button
@onready var back_button = $CanvasLayer/Back as Button

@onready var pan = $Pan as Sprite2D
@onready var pot = $Pot as Sprite2D
@onready var plates = $Plates as Sprite2D
@onready var all_sprites = [pan, pot, plates]

func _ready() -> void:
	plating_button.pressed.connect(go_to_plating)
	plating_button.mouse_entered.connect(on_hover_plates)
	plating_button.mouse_exited.connect(on_unhover_plates)

	frying_pan_button.pressed.connect(go_to_frying_pan_game)
	frying_pan_button.mouse_entered.connect(on_hover_frying_pan)
	frying_pan_button.mouse_exited.connect(on_unhover_frying_pan)

	boiling_pot_button.pressed.connect(go_to_boiling_pot_game)
	boiling_pot_button.mouse_entered.connect(on_hover_boiling_pot)
	boiling_pot_button.mouse_exited.connect(on_unhover_boiling_pot)

	back_button.pressed.connect(go_back_to_customer)
	for sprite in all_sprites:
		set_outline_width(sprite, 0)

func go_to_frying_pan_game():
	get_tree().change_scene_to_file("res://scenes/FryingPanGame.tscn")

func go_to_boiling_pot_game():
	get_tree().change_scene_to_file("res://scenes/BoilingGame.tscn")

func go_to_plating():
	get_tree().change_scene_to_file("res://scenes/Plating.tscn")

func go_back_to_customer():
	get_tree().change_scene_to_file("res://scenes/Restaurant.tscn")

func on_hover_plates():
	set_outline_width(plates, 10)

func on_unhover_plates():
	set_outline_width(plates, 0)

func on_hover_frying_pan():
	set_outline_width(pan, 10)

func on_unhover_frying_pan():
	set_outline_width(pan, 0)

func on_hover_boiling_pot():
	set_outline_width(pot, 10)

func on_unhover_boiling_pot():
	set_outline_width(pot, 0)

func set_outline_width(sprite: Sprite2D, width: int):
	var _material = sprite.material as ShaderMaterial
	_material.set_shader_parameter('width', width)
