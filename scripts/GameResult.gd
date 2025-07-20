class_name GameResult
extends Control

@onready var ingredient_container = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer2 as VBoxContainer
@onready var continue_button = $PanelContainer/MarginContainer/VBoxContainer/ContinueButton
@export var inventory_row_scene: PackedScene

signal on_continue

func _ready() -> void:
	continue_button.pressed.connect(on_continue_clicked)

func init_result(cooked_ingredients):
	for child in ingredient_container.get_children():
		if child is InventoryRow:
			child.queue_free()
	var consolidated_items = {}
	for ing in (cooked_ingredients as Array[InventoryItem]):
		var item_row_name = ""
		if ing is IngredientItem:
			item_row_name = ing.get_name_with_modifiers()
		if consolidated_items.has(item_row_name):
			var ing_item = consolidated_items[item_row_name] as IngredientItem
			ing_item.quantity += 1
		else:
			var new_ing_item = IngredientItem.new()
			new_ing_item.copy_from_item(ing)
			new_ing_item.quantity = 1
			consolidated_items[item_row_name] = new_ing_item
	for ing in consolidated_items.values():
		var item_row_scene = inventory_row_scene.instantiate() as InventoryRow
		ingredient_container.add_child(item_row_scene)
		item_row_scene.set_item(ing)
	show()

func on_continue_clicked():
	hide()
	on_continue.emit()
