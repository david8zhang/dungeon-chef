class_name Inventory
extends PanelContainer

@export var inventory_row_scene: PackedScene
@onready var inventory_container = $VBoxContainer/ScrollContainer/VBoxContainer
@onready var close_button = $VBoxContainer/CloseButton

signal on_close
signal on_item_selected(item)

func _ready() -> void:
	close_button.pressed.connect(close_inventory_menu)

func hide_close_button():
	close_button.hide()

func init_items(inventory_items):
	for child in inventory_container.get_children():
		inventory_container.remove_child(child)
		child.queue_free()
	for it in inventory_items:
		var item = it as InventoryItem
		var inventory_row = inventory_row_scene.instantiate() as InventoryRow
		inventory_row.on_item_selected.connect(select_item)
		inventory_container.add_child(inventory_row)
		inventory_row.set_item(item)
	
func close_inventory_menu():
	on_close.emit()

func select_item(inventory_row: InventoryRow):
	on_item_selected.emit(inventory_row.item)
