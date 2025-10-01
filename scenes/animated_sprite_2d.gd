extends AnimatedSprite2D

class_name PlayerAnimatedSprite

func triggerAnimation(velocity: Vector2, direction: int, player_mode: Player.PlayerMode):
	var animationPrefix = Player.PlayerMode.keys()[player_mode].to_snake_case()
	
	if not get_parent().is_on_floor():
		play("%sJumpAN" % animationPrefix)
	
	elif sign(velocity.x) != sign(direction) && velocity.x != 0 && direction != 0:
		play("%sSlideAN" % animationPrefix)
		scale.x = direction
	
	else:
		if scale.x == 1 && sign(velocity.x) == -1:
			scale.x = -1
		elif scale.x == -1 && sign(velocity.x) == 1:
			scale.x = 1
		
		if velocity.x !=0:
			play("%sRunAN" % animationPrefix)
		else:
			play("%sIdleAN" % animationPrefix)
