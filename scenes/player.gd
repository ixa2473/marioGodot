extends CharacterBody2D

class_name Player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum PlayerMode { SMALL, BIG, SHOOTING }

@onready var animatedSprite2d = $AnimatedSprite2D as PlayerAnimatedSprite
@onready var areaCollisionShape2d: CollisionShape2D = $Area2D/Area_CollisionShape2D
@onready var playerCollisionShape2d: CollisionShape2D = $Player_CollisionShape2D

@export_group("mov")
@export var run_damping = 1
@export var speed = 100
@export var jump_speed = -300

var player_mode = PlayerMode.SMALL

var doubleJump

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		doubleJump = true
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
	
	if Input.is_action_just_pressed("jump") and not is_on_floor() and doubleJump:
		doubleJump = false
		velocity.y = jump_speed
	
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = lerp(velocity.x, speed * direction, 0.1)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
	
	animatedSprite2d.triggerAnimation(velocity, direction, player_mode)
	
	move_and_slide()
