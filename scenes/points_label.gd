extends Label

func _ready() -> void:
	var labelTween = get_tree().create_tween()
	labelTween.tween_property(self, "position", position + Vector2(0, -10), .4)
	labelTween.tween_callback(queue_free)
