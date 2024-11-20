extends HBoxContainer

@onready var card = preload("res://Scenes/Game/donCard.tscn")
var isRested = false

func setUpDon():
	for i in 10:
		card.instantiate()

func setActive():
	$Anim.play("Active")
	isRested = false

func setRested():
	$Anim.play("Rested")
	isRested = true

func donDraw():
	$Anim.play("face_up")
