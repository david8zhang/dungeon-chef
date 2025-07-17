class_name Plating
extends Control

@onready var ingredients_inventory = $Inventory
@onready var back_button = $BackButton
@onready var main_course_button = $MainCourseButton as Button
@onready var side_course_button = $SideCourseButton as Button
@onready var main_course_info = $MainCourse as Course
@onready var side_course_info = $SideCourse as Course
@onready var assemble_button = $AssembleButton as Button
@onready var game_result = $GameResult as GameResult

@export var course_scene: PackedScene

var selected_item: IngredientItem
var inventory_config = []
var main_course: IngredientItem
var side_course: IngredientItem

func _ready() -> void:
	ingredients_inventory.hide_close_button()
	ingredients_inventory.on_item_selected.connect(select_item)
	back_button.pressed.connect(go_to_cooking_scene)
	for i in range(0, 3):
		var ingredient_item = IngredientItem.new()
		ingredient_item.ingredient_stats = load("res://resources/ingredients/Placeholder.tres")
		ingredient_item.quantity = 3
		inventory_config.append(ingredient_item)
	assemble_button.hide()
	ingredients_inventory.init_items(inventory_config)
	main_course_button.pressed.connect(set_main_course)
	side_course_button.pressed.connect(set_side_dish_course)
	assemble_button.pressed.connect(assemble_dish)
	game_result.on_continue.connect(go_to_cooking_scene)

func go_to_cooking_scene():
	get_tree().change_scene_to_file("res://scenes/Cooking.tscn")

func select_item(item: IngredientItem):
	selected_item = item

func remove_item_from_inventory(item):
	var idx = 0
	for it in inventory_config:
		if it == item:
			it.quantity = max(it.quantity - 1, 0)
			if it.quantity == 0:
				inventory_config.remove_at(idx)
		idx += 1
	ingredients_inventory.init_items(inventory_config)

func set_main_course():
	if selected_item != null:
		assemble_button.show()
		main_course_button.hide()
		main_course = selected_item
		remove_item_from_inventory(selected_item)
		main_course_info.show()

func set_side_dish_course():
	if selected_item != null:
		side_course_button.hide()
		side_course = selected_item
		remove_item_from_inventory(selected_item)
		side_course_info.show()

func assemble_dish():
	game_result.show()
	var dish_inventory_item = DishItem.new()
	dish_inventory_item.quantity = 1
	dish_inventory_item.dish_name = main_course.ingredient_stats.ingredient_name
	dish_inventory_item.main_course = main_course
	dish_inventory_item.side_course = side_course
	var results = []
	results.append(dish_inventory_item)
	game_result.init_result(results)
