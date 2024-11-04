extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#should center the buttons
	var setx = get_window().get_size_with_decorations().x/2 - ($MarginContainer.size.x)/2
	var sety = get_window().get_size_with_decorations().y/2 - ($MarginContainer.size.y)/2
	$MarginContainer.position = Vector2(setx, sety)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game/World.tscn")

func _on_deck_builder_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/DeckBuilder/DeckBuilding.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Options/options_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
