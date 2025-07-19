class_name IngredientItem
extends InventoryItem

enum CookType {
	RAW,
	FRIED,
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
		CookType.FRIED:
			cook_type_modifier = "Fried "
		CookType.BOILED:
			cook_type_modifier = "Boiled "
	return grade_modifier + cook_type_modifier + ingredient_stats.ingredient_name

func get_texture():
	match cook_type:
		CookType.FRIED:
			return ingredient_stats.fried_texture
		CookType.BOILED:
			return ingredient_stats.boiled_texture
		CookType.RAW:
			return ingredient_stats.raw_texture

func get_name_for_effect(effect_type: IngredientStats.EffectType):
	match effect_type:
		IngredientStats.EffectType.HEALING:
			return "Healing"
		IngredientStats.EffectType.ATTACK:
			return "Attack Increase"
		IngredientStats.EffectType.DEFENSE:
			return "Defense Increase"
		IngredientStats.EffectType.FIRE_RESIST:
			return "Fire Resist"
		IngredientStats.EffectType.COLD_RESIST:
			return "Cold Resist"
		IngredientStats.EffectType.CURE_POISON:
			return "Cure Poison"

func get_effect_names():
	return get_effect_types().map(func (e): return get_name_for_effect(e))

func get_effect_types():
	match cook_type:
		CookType.FRIED:
			return ingredient_stats.fry_effect_types
		CookType.BOILED:
			return ingredient_stats.boil_effect_types