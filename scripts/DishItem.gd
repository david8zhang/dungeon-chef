class_name DishItem
extends InventoryItem

var cooked_ingredients: Array[IngredientItem] = []

func _init(_quantity: int = 0):
	quantity = _quantity 
