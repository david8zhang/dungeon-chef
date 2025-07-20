class_name Customer
extends Node2D

@onready var sprite = $Sprite2D as Sprite2D

var knight_textures = []

func _ready() -> void:
	# Until I can figure out how to dynamically load resources correctly in Godot 4+
	knight_textures = [
		load("res://assets/restaurant/knights/knight_2.png"),
		load("res://assets/restaurant/knights/knight_3.png"),
		load("res://assets/restaurant/knights/knight_4.png")
	]

func init_texture(texture):
	if texture != null:
		sprite.texture = texture
	else:
		var textures_to_pick_from = knight_textures.filter(func (t): return sprite.texture != t)
		sprite.texture = textures_to_pick_from.pick_random()
