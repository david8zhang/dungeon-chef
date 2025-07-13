class_name MonsterPartStats
extends Resource

enum MonsterPartType {
	PROTEIN,
	VEGETABLE,
	SEASONING,
	LIQUID
}

@export var monster_part_type: MonsterPartType
@export var name: String = ""