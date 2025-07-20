class_name Restaurant
extends Node2D

@onready var customer = $Customer as Customer
@onready var button = $CanvasLayer/Button
@onready var next_line_button = $CanvasLayer/DialogBox/MarginContainer/NextLineButton
@onready var dialog_box = $CanvasLayer/DialogBox/MarginContainer/RichTextLabel as RichTextLabel
@onready var dish = $Dish
@onready var game_result = $CanvasLayer/GameResult

enum CustomerState {
	ORDERING,
	SERVED,
	STARTER,
	OUT_OF_INGREDIENTS
}

# Dialog configuration
var dialog_config = {}
var reaction_config = {}

# Determines how many needs customer has
@export var curr_level := 1

var customer_dialog_lines = []
var customer_reaction = null
var curr_dialog_index = 0
var curr_state := CustomerState.ORDERING
var all_ingredient_stats

func _ready() -> void:
	dialog_config = PlayerVariables.dialog_config
	reaction_config = PlayerVariables.reaction_config
	if PlayerVariables.dish_to_serve != null:
		curr_state = CustomerState.SERVED
		evaluate_dish()
	else:
		init_customer_needs()
	button.pressed.connect(go_to_kitchen)
	next_line_button.pressed.connect(go_to_next_dialog_line)
	game_result.on_continue.connect(generate_new_customer)

func init_customer_needs():
	# Check for special cases
	if PlayerVariables.customers_served == 0:
		button.hide()
		customer.sprite.texture = load("res://assets/restaurant/ingredient_knight.png")
		curr_state = CustomerState.STARTER
		customer_dialog_lines = PlayerVariables.starter_dialog
	elif PlayerVariables.is_inventory_empty():
		button.hide()
		customer.sprite.texture = load("res://assets/restaurant/ingredient_knight.png")
		curr_state = CustomerState.OUT_OF_INGREDIENTS
		customer_dialog_lines = PlayerVariables.out_of_ingredients_dialog
	else:
		# Regular ordering flow
		curr_state = CustomerState.ORDERING
		customer.init_texture(PlayerVariables.curr_customer_texture)
		if PlayerVariables.curr_customer_needs.is_empty():
			var effect_types = IngredientStats.EffectType.values()
			effect_types.shuffle()
			for i in range(0, get_num_needs()):
				PlayerVariables.curr_customer_needs.append(effect_types[i])
		if PlayerVariables.curr_customer_dialog.is_empty():
			for need in PlayerVariables.curr_customer_needs:
				customer_dialog_lines.append(dialog_config[need].pick_random())
		else:
			customer_dialog_lines = PlayerVariables.curr_customer_dialog
	next_line_button.visible = customer_dialog_lines.size() > 1
	dialog_box.text = customer_dialog_lines[curr_dialog_index]

func get_num_needs():
	var customers_served = PlayerVariables.customers_served
	if customers_served >= 20:
		return 4
	elif customers_served >= 10 and customers_served < 20:
		return 3
	elif customers_served >= 5 and customers_served < 10:
		return 2
	return 1

func go_to_kitchen():
	PlayerVariables.curr_customer_texture = customer.sprite.texture
	PlayerVariables.curr_customer_dialog = customer_dialog_lines
	get_tree().change_scene_to_file("res://scenes/Cooking.tscn")

func evaluate_dish():
	dish.set_item(PlayerVariables.dish_to_serve)
	dish.show()
	customer.init_texture(PlayerVariables.curr_customer_texture)
	customer_reaction = get_customer_reaction_to_dish(PlayerVariables.dish_to_serve)
	var reaction_line = reaction_config[customer_reaction].pick_random()
	dialog_box.text = reaction_line

func get_customer_reaction_to_dish(dish_to_serve: DishItem):
	var main_course = dish_to_serve.main_course as IngredientItem
	var side_course = dish_to_serve.side_course as IngredientItem
	var score = 0
	var all_effects = main_course.get_effect_types()
	if side_course != null:
		all_effects += side_course.get_effect_types()
	for effect in all_effects:
		if PlayerVariables.curr_customer_needs.has(effect):
			score += 2
	print("Needs score: " + str(score))
	score += get_points_for_quality(main_course.cook_grade)
	if side_course != null:
		score += get_points_for_quality(side_course.cook_grade)
	var reaction = CustomerReaction.ReactionType.AVERAGE

	# Maximum possible score = 2 for each need met plus 3 for each excellently cooked course
	var max_possible_score = (PlayerVariables.curr_customer_needs.size() * 2) + 6
	var percentage = float(score) / float(max_possible_score)
	print("Score percentage: " + str(percentage))
	if percentage >= 0.7:
		reaction = CustomerReaction.ReactionType.HAPPY
	elif percentage < 0.4:
		reaction = CustomerReaction.ReactionType.UNHAPPY
	return reaction

func get_points_for_quality(cook_grade: IngredientItem.CookGrade):
	match cook_grade:
		IngredientItem.CookGrade.EXCELLENT:
			return 3
		IngredientItem.CookGrade.AVERAGE:
			return 2
		IngredientItem.CookGrade.POOR:
			return 1

func get_rewards():
	var num_rand_ingredients = 2
	match customer_reaction:
		CustomerReaction.ReactionType.HAPPY:
			num_rand_ingredients = 3
		CustomerReaction.ReactionType.UNHAPPY:
			num_rand_ingredients = 1
	var ingredient_rewards = get_ingredients_to_add(num_rand_ingredients)
	game_result.init_result(ingredient_rewards)

func get_ingredients_to_add(num_ingredients):
	var ingredients_to_add = []
	for i in range(0, num_ingredients):
		var rand_ingredient_stat = PlayerVariables.all_ingredient_stats.pick_random()
		var ingredient_item = IngredientItem.new()
		ingredient_item.ingredient_stats = rand_ingredient_stat
		ingredient_item.quantity = 1
		PlayerVariables.add_ingredient_item_to_inventory(ingredient_item)
		ingredients_to_add.append(ingredient_item)
	return ingredients_to_add

func go_to_next_dialog_line():
	match curr_state:
		CustomerState.SERVED:
			get_rewards()
		CustomerState.ORDERING:
			if !customer_dialog_lines.is_empty():
				curr_dialog_index += 1
				curr_dialog_index = curr_dialog_index % customer_dialog_lines.size()
				dialog_box.text = customer_dialog_lines[curr_dialog_index]
		CustomerState.STARTER:
			if curr_dialog_index == customer_dialog_lines.size() - 1:
				next_line_button.hide()
				var ingredient_rewards = get_ingredients_to_add(3)
				game_result.init_result(ingredient_rewards)
				PlayerVariables.customers_served += 1
			else:
				curr_dialog_index += 1
				dialog_box.text = customer_dialog_lines[curr_dialog_index]
		CustomerState.OUT_OF_INGREDIENTS:
			if curr_dialog_index == customer_dialog_lines.size() - 1:
				next_line_button.hide()
				var ingredient_rewards = get_ingredients_to_add(3)
				game_result.init_result(ingredient_rewards)
			else:
				curr_dialog_index += 1
				dialog_box.text = customer_dialog_lines[curr_dialog_index]

func generate_new_customer():
	button.show()
	curr_dialog_index = 0
	customer_reaction = null
	customer_dialog_lines = []
	dish.hide()
	PlayerVariables.dish_to_serve = null
	PlayerVariables.curr_customer_needs = []
	PlayerVariables.curr_customer_dialog = []
	PlayerVariables.curr_customer_texture = null
	init_customer_needs()
