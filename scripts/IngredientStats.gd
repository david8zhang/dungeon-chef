class_name IngredientStats
extends Resource

enum EffectType {
	HEALING,
	ATTACK,
	DEFENSE,
	FIRE_RESIST,
	POISON_RESIST,
	ACCURACY,
	SPEED
}

enum FlavorProfile {
	SPICY,
	SOUR,
	SAVORY,
	SWEET,
	SALTY,
	BITTER
}

@export var ingredient_name: String = ""
@export var texture: Texture
@export var fry_effect_type: EffectType
@export var boil_effect_type: EffectType
@export var flavor_profile: FlavorProfile