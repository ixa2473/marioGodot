extends CharacterBody2D

class_name Player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum PlayerMode { SMALL, BIG, SHOOTING }

signal pointsScored(points: int)

const pointsLabelScene = preload("res://scenes/points_label.tscn")

@onready var animatedSprite2d = $AnimatedSprite2D as PlayerAnimatedSprite
@onready var areaCollisionShape2d: CollisionShape2D = $Area2D/Area_CollisionShape2D
@onready var playerCollisionShape2d: CollisionShape2D = $Player_CollisionShape2D
@onready var area2d: Area2D = $Area2D

#movement
@onready var run_damping = 1
@onready var speed = 100
@onready var jump_speed = -300

#stomping enemeies
@onready var minStompDeg = 35
@onready var maxStompDeg = 145
@onready var stompYSpeed = -150

var player_mode = PlayerMode.SMALL
var doubleJump
var isDead = false

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


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Enemy:
		handleEnemyCollision(area)

func handleEnemyCollision(enemy: Enemy):
	if enemy == null || isDead:
		return
	
	if is_instance_of(enemy, Koopa) and (enemy as Koopa).inAShell:
		(enemy as Koopa).onStomp(global_position)
	else:
		var collisionAngle = rad_to_deg(position.angle_to_point(enemy.position))
		
		if collisionAngle > minStompDeg && maxStompDeg > collisionAngle:
			enemy.die()
			onEnemyStomped()
			spawnPointsLabel(enemy)
		else: 
			die()

func die():
	if player_mode == PlayerMode.SMALL:
		isDead == true
		animatedSprite2d.play("smallDeathAN")
		set_physics_process(false)
		
		var dT = get_tree().create_tween()
		dT.tween_property(self, "position", position + Vector2(0, 48), .5)
		dT.chain().tween_property(self, "position", position + Vector2(0, 256), 1)
		dT.tween_callback(func(): get_tree().reload_current_scene())

func onEnemyStomped():
	velocity.y = stompYSpeed

func spawnPointsLabel(enemy):
	var pL = pointsLabelScene.instantiate()
	pL.position = enemy.position + Vector2(-20, -20)
	get_tree().root.add_child(pL)
	pointsScored.emit(100)
