extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	##should center the buttons
	#var setx = get_window().get_size_with_decorations().x/2 - ($MarginContainer.size.x)/2
	#var sety = get_window().get_size_with_decorations().y/2 - ($MarginContainer.size.y)/2
	#$MarginContainer.position = Vector2(setx, sety)
	pass

func _on_play_pressed() -> void:
	$ButtonSound.play()
	#go to network option first
	get_tree().change_scene_to_file("res://Netorking/lobby.tscn")

func _on_deck_builder_pressed() -> void:
	$ButtonSound.play()
	get_tree().change_scene_to_file("res://Scenes/DeckBuilder/DeckBuilding.tscn")

func _on_options_pressed() -> void:
	$ButtonSound.play()
	get_tree().change_scene_to_file("res://Scenes/Options/options_menu.tscn")

func _on_quit_pressed():
	$ButtonSound.play()
	get_tree().quit()
