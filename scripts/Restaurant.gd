class_name Restaurant
extends Node2D

@onready var customer = $Customer
@onready var button = $CanvasLayer/Button

func _ready() -> void:
	button.pressed.connect(go_to_kitchen)

func go_to_kitchen():
	get_tree().change_scene_to_file("res://scenes/Cooking.tscn")