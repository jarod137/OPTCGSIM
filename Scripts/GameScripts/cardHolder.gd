
# cardHolder.gd
# This script makes the container follow the mouse cursor every frame.

extends Container

var cardHeld = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position = get_global_mouse_position()
