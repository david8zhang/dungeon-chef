class_name Game
extends Node2D

enum Side {
	PLAYER,
	MONSTER
}

@export var monster_scene: PackedScene
@onready var player_party: Node = $PlayerParty
@onready var process_turn_button = $CanvasLayer/Control/Button as Button
var monsters = []
var max_monsters_to_spawn := 3
var turn_order := []
var turn_delay_timer

func _ready() -> void:
	var num_monsters_to_spawn = randi_range(1, max_monsters_to_spawn)
	var x_pos = 1052
	var y_pos = 100
	for i in range(0, num_monsters_to_spawn):
		var monster = monster_scene.instantiate() as Monster
		monster.global_position = Vector2(x_pos, y_pos)
		monster.monster_stats = load("res://resources/monsters/Bat.tres")
		monster.monster_id =  monster.get_name() + "-" + str(i)
		monsters.append(monster)
		add_child(monster)
		y_pos += 125
	init_turn_order()
	process_turn_button.pressed.connect(process_turn)
	
func init_turn_order():
	var player_party_member_ids = player_party.get_children().map(func (p: PartyMember): return p.party_member_id)
	var monster_ids = monsters.map(func(m: Monster): return m.monster_id)
	turn_order = player_party_member_ids + monster_ids
	turn_order.shuffle()

func process_turn():
	if turn_order.is_empty():
		init_turn_order()
		return
	if turn_delay_timer != null and is_instance_valid(turn_delay_timer):
		turn_delay_timer.queue_free()
	var attacker_id = turn_order.pop_front()
	var attacker = get_party_member_for_id(attacker_id)
	if attacker == null:
		attacker = get_monster_for_id(attacker_id)

	var on_tween_finished = func _on_tween_finished():
		handle_attack(attacker)
		var reset_tween = create_tween()
		reset_tween.tween_property(attacker, "scale", Vector2(1, 1), 0.5)
		turn_delay_timer = Timer.new()
		turn_delay_timer.autostart = true
		turn_delay_timer.one_shot = true
		turn_delay_timer.wait_time = 0.5
		turn_delay_timer.timeout.connect(process_turn)
		add_child(turn_delay_timer)	
	var tween = create_tween()
	tween.tween_property(attacker, "scale", Vector2(1.5, 1.5), 0.5)
	tween.finished.connect(on_tween_finished)

func handle_attack(attacker):
	var side = get_side(attacker)
	if side == Side.PLAYER:
		var party_member = attacker as PartyMember
		monsters.sort_custom(func (a, b): return a.get_curr_health() - b.get_curr_health())
		var lowest_hp_monster = monsters[0] as Monster
		var damage = calculate_damage(party_member.get_attack(), lowest_hp_monster.get_defense())
		lowest_hp_monster.take_damage(damage)
	elif side == Side.MONSTER:
		var monster = attacker as Monster
		var party_members = get_player_party_members()
		var target = party_members.pick_random()
		var damage = calculate_damage(monster.get_attack(), target.get_defense())
		target.take_damage(damage)

func calculate_damage(attack: int, defense: int):
	return attack * (1 - round(defense / (attack + defense)))


func get_player_party_members():
	var party_members = []
	for node in player_party.get_children():
		var pm = node as PartyMember
		party_members.append(pm)
	return party_members

func get_party_member_for_id(id: String):
	for pm in get_player_party_members():
		if pm.party_member_id == id:
			return pm
	return null

func get_monster_for_id(id: String):
	for monster in monsters:
		if monster.monster_id == id:
			return monster
	return null

func get_side(attacker):
	if monsters.has(attacker):
		return Side.MONSTER
	elif get_player_party_members().has(attacker):
		return Side.PLAYER
