class_name InventoryRow
extends Node

@onready var button = $Button
@onready var quantity_label = $MarginContainer/HBoxContainer/Quantity as Label
@onready var item_name_label = $MarginContainer/HBoxContainer/VBoxContainer/ItemName as RichTextLabel
@onready var item_description = $MarginContainer/HBoxContainer/VBoxContainer/ItemDescription as RichTextLabel
@onready var item_texture = $MarginContainer/HBoxContainer/PanelContainer/MainCourse as TextureRect
@onready var ingredient_effect_1 = $MarginContainer/HBoxContainer/VBoxContainer/IngredientEffect1 as Label
@onready var ingredient_effect_2 = $MarginContainer/HBoxContainer/VBoxContainer/IngredientEffect2 as Label
@onready var ingredient_effect_labels = [ingredient_effect_1, ingredient_effect_2]

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
		# item_texture.texture = _item.ingredient_stats.texture
		item_name_label.text = _item.get_name_with_modifiers()
		if item.cook_type == IngredientItem.CookType.RAW:
			item_description.text = _item.get_effect_description()
			item_description.show()
			toggle_effect_label_visiblity(false)
		else:
			item_description.hide()
			toggle_effect_label_visiblity(true)
			var effect_names = _item.get_effect_names()
			var idx = 0
			for en in effect_names:
				if idx < ingredient_effect_labels.size():
					var label = ingredient_effect_labels[idx]
					label.show()
					label.text = en
				idx += 1

func toggle_effect_label_visiblity(is_visible):
	for ing in (ingredient_effect_labels as Array[Label]):
		ing.visible = is_visible