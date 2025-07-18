class_name FryingPan
extends Node2D

@onready var frying_pan_game = get_node("/root/FryingPanGame") as FryingPanGame
@onready var ingredient_1 = $PanIngredient as PanIngredient
@onready var ingredient_2 = $PanIngredient2 as PanIngredient
@onready var ingredient_3 = $PanIngredient3 as PanIngredient
@onready var ingredients = [ingredient_1, ingredient_2, ingredient_3]

var cooked_ingredients = []
var num_ingredients_to_cook = 0

func _ready() -> void:
	for ing in ingredients:
		ing.hide()
		ing.on_cooked.connect(process_cooked_ingredient)

func can_add_item():
	var ing_slots = ingredients.filter(func (ing): return !ing.visible)
	return !ing_slots.is_empty()

func add_item(item: InventoryItem):
	var ing_slots = ingredients.filter(func (ing): return !ing.visible)
	var ing_slot_to_show = ing_slots[0] as PanIngredient
	ing_slot_to_show.ingredient_item = item
	ing_slot_to_show.show()

func begin_minigame():
	var ingredients_in_pan = ingredients.filter(func (ing): return ing.visible)
	num_ingredients_to_cook = ingredients_in_pan.size()
	for ing in ingredients_in_pan:
		ing.begin_cooking()

func process_cooked_ingredient(pan_ingredient: PanIngredient):
	if !cooked_ingredients.has(pan_ingredient):
		cooked_ingredients.append(pan_ingredient)
	if cooked_ingredients.size() == num_ingredients_to_cook:
		var cooked_ingredient_items = cooked_ingredients.map(func(ci): return ci.ingredient_item)
		for ci in cooked_ingredient_items:
			ci.quantity = 1
			ci.cook_type = IngredientItem.CookType.FRIED
			ci.cook_grade = IngredientItem.CookGrade.AVERAGE
		frying_pan_game.end_game(cooked_ingredient_items)
