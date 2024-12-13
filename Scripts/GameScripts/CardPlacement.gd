
# CardPlacement.gd
# Handles card placement mechanics. Meant to be a helper class. 

extends Control

var cardCount = 0

var count: int
@onready var card = preload("res://Scenes/Game/cardonBoard.tscn")

func _on_mouse_entered():
	Game.mouseOnPlacement = true

func _on_mouse_exited():
	Game.mouseOnPlacement = false
	
# Performs a check if the card count is less than 5 and places the card if true.
func placeCard():
	if cardCount < 5:
		cardCount += 1
		var cardTemp = card.instantiate()
		var projectResolution = ProjectSettings.get_setting("display/window/size/viewport_width")
		var projectResolutionHeight = ProjectSettings.get_setting("display/window/size/viewport_height")
		#	add an if card is character, event, or stage here
		count += 100
		
		# Sepcifies position that the card is to be placed. 
		cardTemp.global_position = Vector2(projectResolution/2 + count, projectResolutionHeight/2 - 285) - self.position*2
		add_child(cardTemp)
