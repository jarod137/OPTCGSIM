extends Node

var turncount = 0

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")


func _on_end_turn_button_pressed() -> void:
	pass # Replace with function body.


func _on_start_turn_button_pressed() -> void:
	if turncount == 0:
		$UI/Player1/DonDeck.setUpDon()



func _on_win_pressed() -> void:
	get_tree().change_scene_to_file("res://victory.tscn")


func _on_lose_pressed() -> void:
	get_tree().change_scene_to_file("res://Loss.tscn")
