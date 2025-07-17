class_name InventoryRow
extends Node

@onready var button = $Button
@onready var quantity_label = $MarginContainer/HBoxContainer/Quantity as Label
@onready var item_name_label = $MarginContainer/HBoxContainer/VBoxContainer/ItemName as Label
@onready var main_course_texture = $MarginContainer/HBoxContainer/PanelContainer/MainCourse as TextureRect
@onready var side_course_texture = $MarginContainer/HBoxContainer/PanelContainer/SideCourse as TextureRect

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
		main_course_texture.texture = _item.ingredient_stats.texture
		item_name_label.text = _item.ingredient_stats.ingredient_name
		main_course_texture.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		side_course_texture.hide()
	elif _item is DishItem:
		main_course_texture.texture = _item.main_course.ingredient_stats.texture
		side_course_texture.texture = _item.side_course.ingredient_stats.texture
		item_name_label.text = _item.main_course.ingredient_stats.ingredient_name
		main_course_texture.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
