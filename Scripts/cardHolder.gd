extends Container


var cardHeld = ""
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.global_position = get_global_mouse_position()
