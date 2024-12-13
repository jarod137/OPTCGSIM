
# cardonBoard.gd
# Handles interactions with the container, including animations and battle logic.

extends Container

var _active = true

func _battle():
	pass

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		
		# Checks if the user input was with the left or right mouse button. Will play an animation and call _battle() if the former. 
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
