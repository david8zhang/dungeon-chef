class_name CustomerReaction
extends Resource

enum ReactionType {
	HAPPY,
	AVERAGE,
	UNHAPPY
}

@export var reaction_type: ReactionType
@export var dialog_lines: Array[String] = []
