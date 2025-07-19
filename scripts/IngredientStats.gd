class_name IngredientStats
extends Resource

enum EffectType {
	HEALING,
	ATTACK,
	DEFENSE,
	FIRE_RESIST,
	COLD_RESIST,
	CURE_POISON
}

@export var ingredient_name: String = ""
@export var raw_texture: Texture
@export var fried_texture: Texture
@export var boiled_texture: Texture
@export var fry_effect_types: Array[EffectType]
@export var boil_effect_types: Array[EffectType]