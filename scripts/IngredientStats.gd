class_name IngredientStats
extends Resource

enum IngredientType {
	PROTEIN,
	VEGETABLE,
	SEASONING,
	LIQUID
}

enum EffectType {
	HEALING,
	ATTACK,
	DEFENSE
}

@export var ingredient_type: IngredientType
@export var ingredient_name: String = ""
@export var texture: Texture
@export var effect_type: EffectType
@export var effect_amount_base := 0