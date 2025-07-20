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

static var HEALING_COLOR = "#d11141"
static var ATTACK_COLOR = "#6a329f"
static var DEFENSE_COLOR = "#ce7e00"
static var FIRE_RESIST_COLOR = "#f37735"
static var COLD_RESIST_COLOR = "#00aedb"
static var CURE_POISON_COLOR = "#00b159"

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
			return "[color=" + HEALING_COLOR + "]Healing[/color]"
		IngredientStats.EffectType.ATTACK:
			return "[color=" + ATTACK_COLOR + "]Attack Boost[/color]"
		IngredientStats.EffectType.DEFENSE:
			return "[color=" + DEFENSE_COLOR + "]Defense Boost[/color]"
		IngredientStats.EffectType.FIRE_RESIST:
			return "[color=" + FIRE_RESIST_COLOR + "]Fire Resist[/color]"
		IngredientStats.EffectType.COLD_RESIST:
			return "[color=" + COLD_RESIST_COLOR + "]Cold Resist[/color]"
		IngredientStats.EffectType.CURE_POISON:
			return "[color=" + CURE_POISON_COLOR + "]Cure Poison[/color]"

func get_effect_names():
	return get_effect_types().map(func (e): return get_name_for_effect(e))

func get_effect_types():
	match cook_type:
		CookType.FRIED:
			return ingredient_stats.fry_effect_types
		CookType.BOILED:
			return ingredient_stats.boil_effect_types

func get_effect_description():
	var frying_effects = "Fried: " + get_effects_comma_separated(ingredient_stats.fry_effect_types)
	var boiling_effects = "Boiled: " + get_effects_comma_separated(ingredient_stats.boil_effect_types)
	return "[i]" + frying_effects + "\n" + boiling_effects + "[i]"

func get_effects_comma_separated(effect_types):
	var effect_idx = 0
	var result = ""
	for effect in effect_types:
		result += get_name_for_effect(effect)
		if effect_idx != effect_types.size() - 1:
			result += ", "
		effect_idx += 1
	return result
