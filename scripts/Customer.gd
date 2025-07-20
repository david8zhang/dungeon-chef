class_name Customer
extends Node2D

@onready var sprite = $Sprite2D as Sprite2D

var knight_textures = []

func _ready() -> void:
	for file_name in DirAccess.get_files_at("res://assets/restaurant/knights"):
		if (file_name.get_extension() == "png"):
			knight_textures.append(load("res://assets/restaurant/knights/" + file_name))

func init_texture(texture):
	if texture != null:
		sprite.texture = texture
	else:
		var textures_to_pick_from = knight_textures.filter(func (t): return sprite.texture != t)
		sprite.texture = textures_to_pick_from.pick_random()
