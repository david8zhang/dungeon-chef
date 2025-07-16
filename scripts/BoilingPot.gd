class_name BoilingPot
extends Node2D

@onready var boiling_game = get_node("/root/BoilingGame") as BoilingGame
@onready var pot_ingredient = $PotIngredient as Sprite2D
@onready var pot_ingredient_2 = $PotIngredient2 as Sprite2D
@onready var pot_ingredient_3 = $PotIngredient3 as Sprite2D
@onready var color_rect = $ColorRect as ColorRect
@onready var ingredients = [pot_ingredient, pot_ingredient_2, pot_ingredient_3]
@onready var temperature_bar = $TemperatureBar as TemperatureBar

var ingredient_items = []
const MAX_ITEMS := 3

func _ready() -> void:
	for pi in ingredients:
		pi.hide()
	temperature_bar.hide()
	temperature_bar.on_complete.connect(end_minigame)

func add_item(item: InventoryItem):
	var ing_slots = ingredients.filter(func (ing): return !ing.visible)
	var ing_slot_to_show = ing_slots[0]
	ingredient_items.append(item)
	ing_slot_to_show.show()

func can_add_item():
	return ingredient_items.size() < MAX_ITEMS

func begin_minigame():
	color_rect.color = Color(0.1, 0.1, 0.1, 1)
	for ing in ingredients:
		ing.hide()
	temperature_bar.show()
	temperature_bar.start()

func end_minigame():
	var cooked_ingredients = []
	for ing in (ingredient_items as Array[IngredientItem]):
		ing.cook_type = IngredientItem.CookType.BOILED
		cooked_ingredients.append(ing)
	boiling_game.end_game(cooked_ingredients)
