class_name BoilingGame
extends Control

@onready var ingredients_inventory = $Inventory
@onready var view_ingredients_button = $ViewIngredients
@onready var start_button = $StartButton as Button
@onready var title = $Title as Label
@onready var subtitle = $Subtitle as Label
@onready var boiling_pot = $BoilingPot as BoilingPot

var inventory_config = []

func _ready() -> void:
	ingredients_inventory.hide()
	ingredients_inventory.on_item_selected.connect(add_item_to_pot)
	view_ingredients_button.pressed.connect(show_ingredients_list)
	ingredients_inventory.on_close.connect(hide_ingredients_list)
	for i in range(0, 3):
		var ingredient_item = IngredientItem.new()
		ingredient_item.ingredient_stats = load("res://resources/ingredients/Placeholder.tres")
		ingredient_item.quantity = 3
		inventory_config.append(ingredient_item)
	ingredients_inventory.init_items(inventory_config)
	start_button.pressed.connect(start_game)
	start_button.hide()

func show_ingredients_list():
	ingredients_inventory.show()
	view_ingredients_button.hide()

func hide_ingredients_list():
	ingredients_inventory.hide()
	view_ingredients_button.show()

func start_game():
	ingredients_inventory.hide()
	start_button.hide()
	view_ingredients_button.hide()
	title.show()
	subtitle.show()
	boiling_pot.begin_minigame()

func add_item_to_pot(item: IngredientItem):
	if boiling_pot.can_add_item():
		start_button.show()
		var single_item = IngredientItem.new()
		single_item.copy_from_item(item)
		single_item.quantity = 1
		boiling_pot.add_item(single_item)
		remove_item_from_inventory(item)

func remove_item_from_inventory(item):
	var idx = 0
	for it in inventory_config:
		if it == item:
			it.quantity = max(it.quantity - 1, 0)
			if it.quantity == 0:
				inventory_config.remove_at(idx)
		idx += 1
	ingredients_inventory.init_items(inventory_config)
