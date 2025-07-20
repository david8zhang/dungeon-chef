extends Node

var ingredient_item_inventory = []
var dish_to_serve
var curr_customer_needs = []
var curr_customer_texture
var curr_customer_dialog = []
var customers_served = 0

var all_ingredient_stats = []

var dialog_config = {}
var reaction_config = {}
var starter_dialog = []
var out_of_ingredients_dialog = []

func _ready() -> void:
	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.autoplay = true
	audio_stream_player.stream = load("res://audio/bgm/Peritune_Sunlit_Cafe.mp3")
	audio_stream_player.volume_db = -5.0
	add_child(audio_stream_player)

	# Load all ingredient stats
	for file_name in DirAccess.get_files_at("res://resources/ingredients"):
		if (file_name.get_extension() == "tres"):
			var ingredient_stat = load("res://resources/ingredients/" + file_name)
			all_ingredient_stats.append(ingredient_stat)

	load_dialog_lines()

func load_dialog_lines():
	for file_name in DirAccess.get_files_at("res://resources/dialog/needs"):
		if (file_name.get_extension() == "tres"):
			var dialog_resource = load("res://resources/dialog/needs/" + file_name) as CustomerDialog
			dialog_config[dialog_resource.desired_effect_type] = dialog_resource.dialog_lines
	for file_name in DirAccess.get_files_at("res://resources/dialog/reactions"):
		if (file_name.get_extension() == "tres"):
			var reaction_resource = load("res://resources/dialog/reactions/" + file_name) as CustomerReaction
			reaction_config[reaction_resource.reaction_type] = reaction_resource.dialog_lines
		var starter_dialog_resource = load("res://resources/dialog/special/StarterDialog.tres") as SpecialCustomerDialog
		var out_of_ingredients_dialog_resource = load("res://resources/dialog/special/OutOfIngredients.tres") as SpecialCustomerDialog
		starter_dialog = starter_dialog_resource.dialog_lines
		out_of_ingredients_dialog = out_of_ingredients_dialog_resource.dialog_lines

func add_ingredient_item_to_inventory(ingredient_item: IngredientItem):
	var does_ing_exist_in_inventory := false
	for ing in (ingredient_item_inventory as Array[IngredientItem]):
		if ing.get_unique_id() == ingredient_item.get_unique_id():
			ing.quantity += 1
			does_ing_exist_in_inventory = true
	if !does_ing_exist_in_inventory:
		var new_ing_item = IngredientItem.new()
		new_ing_item.copy_from_item(ingredient_item)
		new_ing_item.quantity = 1
		ingredient_item_inventory.append(new_ing_item)

func remove_ingredient_item_from_inventory(ingredient_item: IngredientItem):
	for ing in (ingredient_item_inventory as Array[IngredientItem]):
		if ing.get_unique_id() == ingredient_item.get_unique_id():
			ing.quantity = max(0, ing.quantity - 1)
	ingredient_item_inventory = ingredient_item_inventory.filter(func (ing): return ing.quantity > 0)
	
func init_ingredient_items_inventory():
	for i in range(0, 5):
		var rand_ingredient_stat = all_ingredient_stats.pick_random()
		var ingredient_item = IngredientItem.new()
		ingredient_item.ingredient_stats = rand_ingredient_stat
		ingredient_item.quantity = 1
		add_ingredient_item_to_inventory(ingredient_item)

func is_inventory_empty():
	return ingredient_item_inventory.is_empty() and dish_to_serve == null
