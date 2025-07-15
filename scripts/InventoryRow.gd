class_name InventoryRow
extends Node

@onready var button = $Button
@onready var quantity_label = $MarginContainer/HBoxContainer/Quantity as Label
@onready var item_name_label = $MarginContainer/HBoxContainer/VBoxContainer/ItemName as Label
@onready var texture_rect = $MarginContainer/HBoxContainer/TextureRect as TextureRect
var item: InventoryItem

signal on_item_selected()

func _ready() -> void:
	button.pressed.connect(select_item)

func select_item():
	on_item_selected.emit(self)

func set_item(_item: InventoryItem):
	item = _item
	quantity_label.text = str(_item.quantity)
	if _item is IngredientItem:
		texture_rect.texture = _item.ingredient_stats.texture
		item_name_label.text = _item.ingredient_stats.ingredient_name
