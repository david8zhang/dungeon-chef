class_name FryingPan
extends Node2D

@onready var ingredient_1 = $PanIngredient as PanIngredient
@onready var ingredient_2 = $PanIngredient2 as PanIngredient
@onready var ingredient_3 = $PanIngredient3 as PanIngredient
@onready var ingredients = [ingredient_1, ingredient_2, ingredient_3]

func _ready() -> void:
	for ing in ingredients:
		ing.hide()

func can_add_item():
	var ing_slots = ingredients.filter(func (ing): return !ing.visible)
	return !ing_slots.is_empty()

func add_item(item: InventoryItem):
	var ing_slots = ingredients.filter(func (ing): return !ing.visible)
	ing_slots[0].show()

func begin_minigame():
	var ingredients_in_pan = ingredients.filter(func (ing): return ing.visible)
	for ing in ingredients_in_pan:
		ing.begin_cooking()
