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

func add_item(item: IngredientItem):
	var ing_slots = ingredients.filter(func (ing): return !ing.visible)
	var ing_slot_to_show = ing_slots[0] as PanIngredient
	ing_slot_to_show.set_ingredient_item(item)
	ing_slot_to_show.show()

func get_ingredients_to_cook():
	return ingredients.filter(func (p): return p.ingredient_item != null).map(func (p): return p.ingredient_item)

func begin_minigame():
	var ingredients_in_pan = ingredients.filter(func (ing): return ing.visible)
	num_ingredients_to_cook = ingredients_in_pan.size()
	for ing in ingredients_in_pan:
		ing.begin_cooking()

func process_cooked_ingredient(pan_ingredient: PanIngredient):
	if !cooked_ingredients.has(pan_ingredient):
		cooked_ingredients.append(pan_ingredient)
	if cooked_ingredients.size() == num_ingredients_to_cook:
		var cooked_ingredient_items = []
		for ing in (cooked_ingredients as Array[PanIngredient]):
			var ingredient_item = IngredientItem.new()
			ingredient_item.copy_from_item(ing.ingredient_item)
			ingredient_item.quantity = 1
			ingredient_item.cook_type = IngredientItem.CookType.FRIED
			if ing.top_side_timing == PanIngredient.CookTiming.PERFECT and ing.top_side_timing == PanIngredient.CookTiming.PERFECT:
				ingredient_item.cook_grade = IngredientItem.CookGrade.EXCELLENT
			elif ing.top_side_timing != PanIngredient.CookTiming.PERFECT and ing.top_side_timing != PanIngredient.CookTiming.PERFECT:
				ingredient_item.cook_grade = IngredientItem.CookGrade.POOR
			else:
				ingredient_item.cook_grade = IngredientItem.CookGrade.AVERAGE
			cooked_ingredient_items.append(ingredient_item)
		frying_pan_game.end_game(cooked_ingredient_items)
