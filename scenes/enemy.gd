extends Area2D

class_name Enemy

@export var hSpeed = 20
@export var vSpeed = 100
@onready var rayCast2d: RayCast2D = $RayCast2D

func _process(delta):
	position.x -= hSpeed * delta
	
	if !rayCast2d.is_colliding():
		position.y += vSpeed * delta
		#
