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

enum EffectDurationType {
	OVER_TIME,
	INSTANT
}

@export var ingredient_type: IngredientType
@export var texture: Texture
@export var name: String = ""
@export var effect_type: EffectType
@export var effect_duration_type: EffectDurationType
@export var effect_amount_base := 0
@export var effect_duration_base := 0 # If it's an instant effect the duration will always be 1