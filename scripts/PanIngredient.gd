class_name PanIngredient
extends Node2D

@onready var button = $Sprite2D/Button as Button

func _ready():
	button.pressed.connect(on_flip)

func on_flip():
	print("Flip!")
