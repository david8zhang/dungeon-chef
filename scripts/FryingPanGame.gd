class_name FryingPanGame
extends Control

@onready var ingredients_inventory = $Inventory
@onready var view_ingredients_button = $ViewIngredients
@onready var frying_pan = $FryingPan as FryingPan
@onready var start_button = $StartButton as Button
@onready var title = $Title as Label
@onready var subtitle = $Subtitle as Label

var inventory_config = []

func _ready() -> void:
	ingredients_inventory.hide()
	ingredients_inventory.on_item_selected.connect(add_item_to_pan)
	view_ingredients_button.pressed.connect(show_ingredients_list)
	ingredients_inventory.on_close.connect(hide_ingredients_list)
	for i in range(0, 3):
		var ingredient_item = IngredientItem.new()
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

func add_item_to_pan(item: IngredientItem):
	if frying_pan.can_add_item():
		start_button.show()
		frying_pan.add_item(item)
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

func start_game():
	start_button.hide()
	view_ingredients_button.hide()
	title.show()
	subtitle.show()
	frying_pan.begin_minigame()