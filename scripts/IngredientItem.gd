class_name IngredientItem
extends InventoryItem

enum CookType {
	RAW,
	SAUTED,
	FRIED,
	CHOPPED,
	BOILED
}

enum CookGrade {
	NONE,
	EXCELLENT,
	AVERAGE,
	POOR
}

var ingredient_stats: IngredientStats
var cook_type: CookType = CookType.RAW
var cook_grade: CookGrade = CookGrade.NONE

func copy_from_item(other_item: IngredientItem):
	ingredient_stats = other_item.ingredient_stats
	cook_type = other_item.cook_type
	cook_grade = other_item.cook_grade

func get_unique_id():
	return str(cook_type) + "_" + str(cook_grade) + "_" + str(ingredient_stats.ingredient_name)

func get_name_with_modifiers():
	var grade_modifier = ""
	match cook_grade:
		CookGrade.EXCELLENT:
			grade_modifier = "Excellently "
		CookGrade.POOR:
			grade_modifier = "Poorly "
	var cook_type_modifier = ""
	match cook_type:
		CookType.RAW:
			cook_type_modifier = "Raw "
		CookType.SAUTED:
			cook_type_modifier = "Sautéed "
		CookType.FRIED:
			cook_type_modifier = "Fried "
		CookType.BOILED:
			cook_type_modifier = "Boiled "
	return grade_modifier + cook_type_modifier + ingredient_stats.ingredient_name
