class_name PartyMemberStats
extends Resource

enum PartyMemberType {
	KNIGHT,
	MAGE,
	ARCHER
}

@export var pm_name := ""
@export var max_health := 0
@export var attack := 0
@export var defense := 0
@export var pm_type: PartyMemberType