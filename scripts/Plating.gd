class_name Plating
extends Control

@onready var ingredients_inventory = $Inventory
@onready var back_button = $BackButton

var selected_item: IngredientItem
var inventory_config = []

func _ready() -> void:
	ingredients_inventory.hide_close_button()
	ingredients_inventory.on_item_selected.connect(select_item)
	back_button.pressed.connect(go_to_cooking_scene)
	for i in range(0, 3):
		var ingredient_item = IngredientItem.new()
		ingredient_item.ingredient_stats = load("res://resources/ingredients/Placeholder.tres")
		ingredient_item.quantity = 3
		inventory_config.append(ingredient_item)
	ingredients_inventory.init_items(inventory_config)

func go_to_cooking_scene():
	get_tree().change_scene_to_file("res://scenes/Cooking.tscn")

func select_item(item: IngredientItem):
	selected_item = item