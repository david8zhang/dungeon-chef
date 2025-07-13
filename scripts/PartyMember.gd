class_name PartyMember
extends BattlerEntity

@export var party_member_stats: PartyMemberStats

func _ready() -> void:
	health_bar.max_value = party_member_stats.max_health
	battler_entity_id = party_member_stats.pm_name
	super._ready()

func get_curr_health():
	return health_bar.value

func get_attack():
	return party_member_stats.attack

func get_defense():
	return party_member_stats.defense
