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