
# don_deck.gd
# Responsible for handling don mechanics like drawing, resting, setting to active, and initial setup.
# Note: Don cound cannot be more than 10. This should be handled in the script calling this code. 

extends HBoxContainer

@onready var card = preload("res://Scenes/Game/donCard.tscn")

# indicates if don is rested
var isRested = false

func setUpDon():
	# Instantiates new card and positions at specified location on screen. 
	var cardTemp = card.instantiate()
	var projectResolution = ProjectSettings.get_setting("display/window/size/viewport_width")
	var projectResolutionHeight = ProjectSettings.get_setting("display/window/size/viewport_height")
	
	cardTemp.global_position = Vector2(projectResolution/4, projectResolutionHeight)
	
	add_child(cardTemp)

# Sets the don card to active
func setActive():
	$Anim.play("Active")
	isRested = false

# Sets the don card to rested
func setRested():
	$Anim.play("Rested")
	isRested = true

func donDraw():
	# Instantiates new card and positions at specified location on screen. 
	var cardTemp = card.instantiate()
	var projectResolution = ProjectSettings.get_setting("display/window/size/viewport_width")
	var projectResolutionHeight = ProjectSettings.get_setting("display/window/size/viewport_height")
	
	cardTemp.global_position = Vector2(projectResolution/4, projectResolutionHeight)
	
	add_child(cardTemp)
