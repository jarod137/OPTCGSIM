extends Node

#need this for networking
signal game_finished()

var turncount = 0

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")


func _on_end_turn_button_pressed() -> void:
	$CanvasLayer/UI/Player1/DonDeck.donDraw()


func _on_start_turn_button_pressed() -> void:
	if turncount == 0:
		$CanvasLayer/UI/Player1/DonDeck.setUpDon()
	turncount += 1



func _on_win_pressed() -> void:
	get_tree().change_scene_to_file("res://victory.tscn")


func _on_lose_pressed() -> void:
	get_tree().change_scene_to_file("res://Loss.tscn")


func _on_load_deck_button_pressed() -> void:
	pass # Replace with function body.
