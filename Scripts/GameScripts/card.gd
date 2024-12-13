# card.gd
# This class is responsible for the actual card interactions that are to occur. This includes things like animations and attempts to broadcast it for multiplayer.

extends Container

@onready var card = preload("res://Scenes/Game/cardHolder.tscn")
var startPosition

# Series of flags to indicate cards current state. 
var cardHighlighted = false
var isRested = false
var isDon = false
var isLeader = false
var isCharacter = false
var isStage = false
var isEvent = false

func _ready():
	startPosition = self.position


@rpc("unreliable") #attempt to send multiplayer signal
func _on_mouse_entered():
	$Anim.play("Select")
	cardHighlighted = true

@rpc("unreliable") #attempt to send multiplayer signal
func _on_mouse_exited():
	$Anim.play("DeSelect")
	cardHighlighted = false


# how I am going to implement keyword handling when cards are linked to the deck file
func keyword_check():
	if card.text.contains("Rush"):
		pass
	elif card.text.contains("DoubleAttack"):
		pass
	elif card.text.contains("Banish"):
		pass
	elif card.text.contains("Blocker"):
		pass
	else:
		pass

@rpc("unreliable") #attempt to send multiplayer signal
func _on_gui_input(event):
	if (event is InputEventMouseButton) and (event.button_index == 1):
			if event.button_mask == 1:
				if cardHighlighted:
					#Press down and drag
					var cardTemp = card.instantiate()
					get_tree().get_root().get_node("Board/CardHolder").add_child(cardTemp)
					Game.cardSelected = true
					if cardHighlighted:
						self.get_child(0).hide()
						
			elif event.button_mask == 0:
				#press up and let go
				#check for area
				if !Game.mouseOnPlacement:
					cardHighlighted = false
					self.get_child(0).show()
				else:
					self.queue_free()
					#place card on board
					get_node("../../CardPlacement").placeCard()
				for i in get_tree().get_root().get_node("Board/CardHolder").get_child_count():
					get_tree().get_root().get_node("Board/CardHolder").get_child(i).queue_free()
				Game.cardSelected = false
