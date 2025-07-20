class_name Plating
extends Control

@onready var ingredients_inventory = $Inventory
@onready var back_button = $BackButton
@onready var main_course_button = $MainCourseButton as Button
@onready var side_course_button = $SideCourseButton as Button
@onready var main_course_info = $MainCourse as Course
@onready var side_course_info = $SideCourse as Course
@onready var serve_button = $ServeButton as Button
@onready var game_result = $GameResult as GameResult

@export var course_scene: PackedScene

var course_to_select := ""
var inventory_config = []
var main_course: IngredientItem
var side_course: IngredientItem

func _ready() -> void:
	ingredients_inventory.hide_close_button()
	ingredients_inventory.on_item_selected.connect(select_item)
	back_button.pressed.connect(go_to_cooking_scene)
	serve_button.hide()
	ingredients_inventory.init_items(inventory_config)
	main_course_button.pressed.connect(select_main_course)
	side_course_button.pressed.connect(select_side_course)
	serve_button.pressed.connect(assemble_dish)
	game_result.on_continue.connect(go_to_cooking_scene)
	update_inventory()

func update_inventory():
	var cooked_ingredients = PlayerVariables.ingredient_item_inventory.filter(func (ing): return ing.cook_type != IngredientItem.CookType.RAW)
	ingredients_inventory.init_items(cooked_ingredients)

func go_to_cooking_scene():
	get_tree().change_scene_to_file("res://scenes/Cooking.tscn")

func select_item(item: IngredientItem):
	if course_to_select == "main":
		set_main_course(item)
	elif course_to_select == "side":
		set_side_course(item)

func remove_item_from_inventory(item):
	PlayerVariables.remove_ingredient_item_from_inventory(item)
	update_inventory()

func select_main_course():
	course_to_select = "main"
	show_inventory()

func select_side_course():
	course_to_select = "side"
	show_inventory()

func show_inventory():
	ingredients_inventory.show()

func set_main_course(selected_item: IngredientItem):
	if selected_item != null:
		ingredients_inventory.hide()
		serve_button.show()
		main_course_button.hide()
		main_course = selected_item
		remove_item_from_inventory(selected_item)
		main_course_info.init_from_ingredient_item(main_course)
		main_course_info.show()

func set_side_course(selected_item: IngredientItem):
	if selected_item != null:
		ingredients_inventory.hide()
		side_course_button.hide()
		side_course = selected_item
		remove_item_from_inventory(selected_item)
		side_course_info.init_from_ingredient_item(side_course)
		side_course_info.show()

func assemble_dish():
	var dish_item = DishItem.new()
	dish_item.main_course = main_course
	dish_item.side_course = side_course
	PlayerVariables.dish_to_serve = dish_item
	get_tree().change_scene_to_file("res://scenes/Restaurant.tscn")
