extends Container

var _active = true

func _battle():
	pass


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("Container clicked!")
			if _active == true:
				$Anim.play("tap")
				_battle()
				_active = false
			else:
				$Anim.play("untap")
				_active = true
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			self.free()
