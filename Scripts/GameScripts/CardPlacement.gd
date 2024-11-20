extends Control

var cardCount = 0

var count: int
@onready var card = preload("res://Scenes/Game/cardonBoard.tscn")

func _on_mouse_entered():
	Game.mouseOnPlacement = true


func _on_mouse_exited():
	Game.mouseOnPlacement = false


func placeCard():
	if cardCount < 5:
		cardCount += 1
		var cardTemp = card.instantiate()
		var projectResolution = ProjectSettings.get_setting("display/window/size/viewport_width")
		var projectResolutionHeight = ProjectSettings.get_setting("display/window/size/viewport_height")
		#	add an if card is character, event, or stage here
		count += 120
		cardTemp.global_position = Vector2(projectResolution/4 + count, projectResolutionHeight/2 - 240) - self.position*2
		add_child(cardTemp)
