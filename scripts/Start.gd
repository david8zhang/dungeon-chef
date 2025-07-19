class_name Start
extends Node2D

@onready var button = $CanvasLayer/HBoxContainer/Button as Button

func _ready() -> void:
	button.pressed.connect(start_game)

func start_game():
	PlayerVariables.init_ingredient_items_inventory()
	get_tree().change_scene_to_file("res://scenes/Restaurant.tscn")
