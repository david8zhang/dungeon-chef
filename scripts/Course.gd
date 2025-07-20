class_name Course
extends PanelContainer

@onready var ingredient_name = $MarginContainer/VBoxContainer/IngredientName as RichTextLabel
@onready var texture_rect = $MarginContainer/VBoxContainer/TextureRect as TextureRect
@onready var dish_effect_1 = $MarginContainer/VBoxContainer/DishEffect as RichTextLabel
@onready var dish_effect_2 = $MarginContainer/VBoxContainer/DishEffect2 as RichTextLabel

func init_from_ingredient_item(ingredient_item: IngredientItem):
	ingredient_name.text = ingredient_item.get_name_with_modifiers()
	texture_rect.texture = ingredient_item.get_texture()
	var dish_effect_labels = [dish_effect_1, dish_effect_2]
	var effect_names = ingredient_item.get_effect_names()
	var idx = 0
	for en in effect_names:
		if idx < dish_effect_labels.size():
			var label = dish_effect_labels[idx]
			label.show()
			label.text = en
		idx += 1
