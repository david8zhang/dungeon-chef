class_name DishSelector
extends PanelContainer

@onready var game = get_node("/root/Game") as Game
@onready var dish_container = $MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer as HBoxContainer
@export var dish_scene: PackedScene

func _ready() -> void:
	for i in range(0, 5):
		var dish = dish_scene.instantiate() as Dish
		dish.on_dish_selected.connect(select_dish)
		dish_container.add_child(dish)

func select_dish(dish):
	game.select_dish(dish)
	dish.queue_free()
