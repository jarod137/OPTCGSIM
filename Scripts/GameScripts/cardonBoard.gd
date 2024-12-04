extends Container


var _active = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _battle():
	# how I plan to implement battling
	pass
	
	#if power < opponentPower:
		#pass
	#else:
		#if isLeader:
			#takeLife()
		#else:
			#opponentCard.trash()
	#pass

func _on_mouse_entered() -> void:
	_active = true
	show_attack_menu()


func _on_mouse_exited() -> void:
	_active = false
	hide_attack_menu

# Show the popup menu
func show_attack_menu():
	if _active:
		var popup = get_node("res://Scenes/Game/CardMenu.tscn")
		#if popup:
		popup.popup()  # Show the popup menu

# Hide the popup menu
func hide_attack_menu():
	$"AttackMenu".hide()
