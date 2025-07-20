class_name Cooking
extends Node2D

@onready var frying_pan_button = $CanvasLayer/FryingPan
@onready var boiling_pot_button = $CanvasLayer/BoilingPot
@onready var plating_button = $CanvasLayer/Plating
@onready var back_button = $CanvasLayer/Back

func _ready() -> void:
	frying_pan_button.pressed.connect(go_to_frying_pan_game)
	boiling_pot_button.pressed.connect(go_to_boiling_pot_game)
	plating_button.pressed.connect(go_to_plating)
	back_button.pressed.connect(go_back_to_customer)

func go_to_frying_pan_game():
	get_tree().change_scene_to_file("res://scenes/FryingPanGame.tscn")

func go_to_boiling_pot_game():
	get_tree().change_scene_to_file("res://scenes/BoilingGame.tscn")

func go_to_plating():
	get_tree().change_scene_to_file("res://scenes/Plating.tscn")

func go_back_to_customer():
	get_tree().change_scene_to_file("res://scenes/Restaurant.tscn")