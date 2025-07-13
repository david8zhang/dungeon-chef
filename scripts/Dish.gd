class_name Dish
extends PanelContainer

@onready var button = $Button

signal on_dish_selected(dish)

func _ready() -> void:
	button.pressed.connect(select_dish)

func select_dish():
	on_dish_selected.emit(self)

func apply_affects(party_member: PartyMember):
	print("apply affects to party member: " + party_member.get_full_name())