extends HBoxContainer

@onready var card = preload("res://Scenes/Game/donCard.tscn")
var isRested = false

func setUpDon():
	var cardTemp = card.instantiate()
	var projectResolution = ProjectSettings.get_setting("display/window/size/viewport_width")
	var projectResolutionHeight = ProjectSettings.get_setting("display/window/size/viewport_height")
	
	cardTemp.global_position = Vector2(projectResolution/4, projectResolutionHeight)
	
	add_child(cardTemp)

func setActive():
	$Anim.play("Active")
	isRested = false

func setRested():
	$Anim.play("Rested")
	isRested = true

func donDraw():
	
	var cardTemp = card.instantiate()
	var projectResolution = ProjectSettings.get_setting("display/window/size/viewport_width")
	var projectResolutionHeight = ProjectSettings.get_setting("display/window/size/viewport_height")
	
	cardTemp.global_position = Vector2(projectResolution/4, projectResolutionHeight)
	
	add_child(cardTemp)
	
	#$Anim.play("face_up")
