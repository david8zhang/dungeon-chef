class_name Dish
extends Node2D

@onready var main_course_sprite = $MainCourse as Sprite2D
@onready var side_course_sprite = $SideCourse as Sprite2D

func set_item(dish_item: DishItem):
	main_course_sprite.texture = dish_item.main_course.get_texture()
	if dish_item.side_course != null:
		side_course_sprite.texture = dish_item.side_course.get_texture()
	else:
		side_course_sprite.hide()
