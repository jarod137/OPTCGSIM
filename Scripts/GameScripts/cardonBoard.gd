extends Container


var _active = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _active: 
		$Anim.play("tap")
	else:
		$Anim.play("untap")


func _on_mouse_entered() -> void:
	_active = true


func _on_mouse_exited() -> void:
	_active = false
