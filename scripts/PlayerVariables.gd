extends Node

var ingredient_item_inventory = []
var dish_to_serve
var curr_customer_needs = []

func add_ingredient_item_to_inventory(ingredient_item: IngredientItem):
	var does_ing_exist_in_inventory := false
	for ing in (ingredient_item_inventory as Array[IngredientItem]):
		if ing.get_unique_id() == ingredient_item.get_unique_id():
			ing.quantity += 1
			does_ing_exist_in_inventory = true
	if !does_ing_exist_in_inventory:
		ingredient_item_inventory.append(ingredient_item)

func remove_ingredient_item_from_inventory(ingredient_item: IngredientItem):
	for ing in (ingredient_item_inventory as Array[IngredientItem]):
		if ing.get_unique_id() == ingredient_item.get_unique_id():
			ing.quantity = max(0, ing.quantity - 1)
	ingredient_item_inventory = ingredient_item_inventory.filter(func (ing): return ing.quantity > 0)
	
func init_ingredient_items_inventory():
	var all_ingredient_stats = []
	for file_name in DirAccess.get_files_at("res://resources/ingredients"):
		if (file_name.get_extension() == "tres"):
			var ingredient_stat = load("res://resources/ingredients/" + file_name)
			all_ingredient_stats.append(ingredient_stat)
	for i in range(0, 10):
		var rand_ingredient_stat = all_ingredient_stats.pick_random()
		var ingredient_item = IngredientItem.new()
		ingredient_item.ingredient_stats = rand_ingredient_stat
		ingredient_item.quantity = 1
		add_ingredient_item_to_inventory(ingredient_item)
