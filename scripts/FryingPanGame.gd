class_name FryingPanGame
extends Control

@onready var ingredients_inventory = $Inventory
@onready var view_ingredients_button = $ViewIngredients
@onready var frying_pan = $FryingPan as FryingPan
@onready var start_button = $StartButton as Button
@onready var back_button = $BackButton as Button
@onready var title = $Title as Label
@onready var subtitle = $Subtitle as Label
@onready var game_result = $GameResult as GameResult
@onready var flame = $Flame
@onready var frying_sfx = $FryingSound as AudioStreamPlayer

func _ready() -> void:
	if PlayerVariables.ingredient_item_inventory.is_empty():
		PlayerVariables.init_ingredient_items_inventory()
	ingredients_inventory.hide()
	ingredients_inventory.on_item_selected.connect(add_item_to_pan)
	view_ingredients_button.pressed.connect(show_ingredients_list)
	ingredients_inventory.on_close.connect(hide_ingredients_list)
	start_button.pressed.connect(start_game)
	start_button.hide()
	game_result.hide()
	game_result.on_continue.connect(go_to_cooking_scene)
	back_button.pressed.connect(go_to_cooking_scene)
	flame.hide()
	update_inventory()

func update_inventory():
	var raw_ingredients = PlayerVariables.ingredient_item_inventory.filter(func (ing): return ing.cook_type == IngredientItem.CookType.RAW)
	ingredients_inventory.init_items(raw_ingredients)

func show_ingredients_list():
	ingredients_inventory.show()
	view_ingredients_button.hide()

func hide_ingredients_list():
	ingredients_inventory.hide()
	view_ingredients_button.show()

func add_item_to_pan(item: IngredientItem):
	if frying_pan.can_add_item():
		start_button.show()
		var single_item = IngredientItem.new()
		single_item.copy_from_item(item)
		single_item.quantity = 1
		frying_pan.add_item(single_item)
		PlayerVariables.remove_ingredient_item_from_inventory(single_item)
		update_inventory()

func start_game():
	frying_sfx.playing = true
	flame.show()
	ingredients_inventory.hide()
	start_button.hide()
	view_ingredients_button.hide()
	back_button.hide()
	title.show()
	subtitle.show()
	frying_pan.begin_minigame()

func end_game(cooked_ingredient_items):
	frying_sfx.playing = false
	for ing_item in cooked_ingredient_items:
		PlayerVariables.add_ingredient_item_to_inventory(ing_item)
	game_result.show()
	game_result.init_result(cooked_ingredient_items)

func go_to_cooking_scene():
	get_tree().change_scene_to_file("res://scenes/Cooking.tscn")
