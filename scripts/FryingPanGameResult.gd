class_name FryingPanGameResult
extends Control

@onready var ingredient_container = $PanelContainer/VBoxContainer/VBoxContainer2 as VBoxContainer
@onready var continue_button = $PanelContainer/VBoxContainer/ContinueButton
@export var inventory_row_scene: PackedScene

func init_result(cooked_ingredients):
	var consolidated_items = {}
	for ing in (cooked_ingredients as Array[IngredientItem]):
		if consolidated_items.has(ing.ingredient_stats.ingredient_name):
			var ing_item = consolidated_items[ing.ingredient_stats.ingredient_name] as IngredientItem
			ing_item.quantity += 1
		else:
			consolidated_items[ing.ingredient_stats.ingredient_name] = ing
	for ing in consolidated_items.values():
		var item_row_scene = inventory_row_scene.instantiate() as InventoryRow
		ingredient_container.add_child(item_row_scene)
		item_row_scene.set_item(ing)
