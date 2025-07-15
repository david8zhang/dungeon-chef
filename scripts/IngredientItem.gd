class_name IngredientItem
extends InventoryItem

enum CookType {
	SAUTED,
	FRIED,
	CHOPPED,
	BOILED
}

enum CookGrade {
	EXCELLENT,
	AVERAGE,
	POOR
}

var ingredient_stats: IngredientStats
var cook_type: CookType
var cook_grade: CookGrade

func copy_from_item(other_item: IngredientItem):
	ingredient_stats = other_item.ingredient_stats
	cook_type = other_item.cook_type
	cook_grade = other_item.cook_grade