class_name DishSelector
extends PanelContainer

@onready var game = get_node("/root/Game") as Game
@onready var dish_container = $MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer as HBoxContainer
@export var inventory_row_scene: PackedScene

func _ready() -> void:
	for i in range(0, 5):
		var inventory_row = inventory_row_scene.instantiate() as InventoryRow
		var dish_item = DishItem.new()
		inventory_row.item = dish_item
		inventory_row.on_item_selected.connect(select_item)
		dish_container.add_child(inventory_row)

func select_item(inventory_row: InventoryRow):
	game.select_dish(inventory_row.item)
