extends Control

func _on_volume_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Options/volume_setting.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")

func _on_network_pressed() -> void:
	get_tree().change_scene_to_file("res://Netorking/network.tscn")
