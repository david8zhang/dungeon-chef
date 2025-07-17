class_name DishItem
extends InventoryItem

var main_course: IngredientItem
var side_course: IngredientItem

var dish_name := ""

func _init(_quantity: int = 0):
	quantity = _quantity 
