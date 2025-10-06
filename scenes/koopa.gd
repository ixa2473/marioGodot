extends Enemy

class_name Koopa

const koopaDefaultShape = preload("res://Resources/CollisionShapes/koopa_default.tres")
const koopaInShellShape = preload("res://Resources/CollisionShapes/koopa_shell.tres")
const koopaShellPos = Vector2(0,5)

@onready var colShape2d: CollisionShape2D = $CollisionShape2D
@export var slideSpeed = 400

var inAShell = false

func _ready():
	colShape2d.shape = koopaDefaultShape

func die():
	if !inAShell:
		!super.die()
	
	colShape2d.set_deferred("shape", koopaInShellShape)
	colShape2d.set_deferred("position", koopaShellPos)
	inAShell = true

func onStomp(playerPos: Vector2):
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	set_collision_layer_value(4, false)
	
	var movDir = 1 if playerPos.x <= global_position.x else -1
	hSpeed = -movDir * slideSpeed


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	pass # Replace with function body.
