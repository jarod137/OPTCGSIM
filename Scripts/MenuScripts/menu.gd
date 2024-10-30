extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game/World.tscn")

func _on_deck_builder_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/DeckBuilder/DeckBuilder.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Options/options_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
