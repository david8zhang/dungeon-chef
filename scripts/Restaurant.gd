class_name Restaurant
extends Node2D

@onready var customer = $Customer
@onready var button = $CanvasLayer/Button
@onready var next_line_button = $CanvasLayer/DialogBox/MarginContainer/NextLineButton
@onready var dialog_box = $CanvasLayer/DialogBox/MarginContainer/RichTextLabel as RichTextLabel
@onready var dish = $Dish

# Determiens what kinds of foods the customer wants
var dialog_config = {}
var reaction_config = {}

# Determines how many needs customer has
@export var curr_level := 1

var customer_dialog_lines = []
var curr_dialog_index = 0

func _ready() -> void:
	load_dialog_lines()
	if PlayerVariables.dish_to_serve != null:
		evaluate_dish()
	else:
		init_customer_needs()
	button.pressed.connect(go_to_kitchen)
	next_line_button.pressed.connect(go_to_next_dialog_line)

func load_dialog_lines():
	for file_name in DirAccess.get_files_at("res://resources/dialog/needs"):
		if (file_name.get_extension() == "tres"):
			var dialog_resource = load("res://resources/dialog/needs/" + file_name) as CustomerDialog
			dialog_config[dialog_resource.desired_effect_type] = dialog_resource.dialog_lines
	for file_name in DirAccess.get_files_at("res://resources/dialog/reactions"):
		if (file_name.get_extension() == "tres"):
			var reaction_resource = load("res://resources/dialog/reactions/" + file_name) as CustomerReaction
			reaction_config[reaction_resource.reaction_type] = reaction_resource.dialog_lines

func init_customer_needs():
	if PlayerVariables.curr_customer_needs.is_empty():
		var effect_types = IngredientStats.EffectType.values()
		effect_types.shuffle()
		for i in range(0, curr_level):
			PlayerVariables.curr_customer_needs.append(effect_types[i])
	for need in PlayerVariables.curr_customer_needs:
		customer_dialog_lines.append(dialog_config[need].pick_random())
	next_line_button.visible = customer_dialog_lines.size() > 1
	dialog_box.text = customer_dialog_lines[curr_dialog_index]

func go_to_kitchen():
	get_tree().change_scene_to_file("res://scenes/Cooking.tscn")

func evaluate_dish():
	dish.show()
	var dish_to_serve = PlayerVariables.dish_to_serve as DishItem
	var main_course = dish_to_serve.main_course as IngredientItem
	var side_course = dish_to_serve.side_course as IngredientItem
	var score = get_points_for_quality(main_course.cook_grade)
	if side_course != null:
		score += get_points_for_quality(side_course.cook_grade)
	var reaction = CustomerReaction.ReactionType.AVERAGE
	if score >= 5:
		reaction = CustomerReaction.ReactionType.HAPPY
	elif score <= 2:
		reaction = CustomerReaction.ReactionType.UNHAPPY
	var reaction_line = reaction_config[reaction].pick_random()
	dialog_box.text = reaction_line

func get_points_for_quality(cook_grade: IngredientItem.CookGrade):
	match cook_grade:
		IngredientItem.CookGrade.EXCELLENT:
			return 3
		IngredientItem.CookGrade.AVERAGE:
			return 2
		IngredientItem.CookGrade.POOR:
			return 1


func go_to_next_dialog_line():
	if !customer_dialog_lines.is_empty():
		curr_dialog_index += 1
		curr_dialog_index = curr_dialog_index % customer_dialog_lines.size()
		dialog_box.text = customer_dialog_lines[curr_dialog_index]
