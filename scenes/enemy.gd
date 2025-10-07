extends Area2D

class_name Enemy

const pointsLabelScene = preload("res://scenes/points_label.tscn")


@onready var hSpeed = 20
@onready var vSpeed = 100

@onready var rayCast2d: RayCast2D = $RayCast2D
@onready var animatedSprite2d: AnimatedSprite2D = $AnimatedSprite2D


func _process(delta):
	position.x -= hSpeed * delta
	
	if !rayCast2d.is_colliding():
		position.y += vSpeed * delta

func die():
	hSpeed = 0
	vSpeed = 0
	animatedSprite2d.play("dieAN")

func dieFromHit():
	set_collision_layer_value(3, false)
	set_collision_mask_value(3,false)
	
	rotation_degrees = 180
	hSpeed = 0
	vSpeed = 0
	
	var dieTween = get_tree().create_tween()
	dieTween.tween_property(self, "position", position + Vector2(0,-25), .2)
	dieTween.chain().tween_property(self, "position", position + Vector2(0,500), 4)
	
	var pL = pointsLabelScene.instantiate()
	pL.position = self.position + Vector2(-20, -20)
	get_tree().root.add_child(pL)


func _on_area_entered(area):
	if area is Koopa and (area as Koopa).inAShell and (area as Koopa).hSpeed != 0:
		dieFromHit()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
