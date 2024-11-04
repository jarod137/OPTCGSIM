extends Node3D

# Properties for card attributes
@export var card_id: int = 0
@export var card_name: String = ""
@export var card_type: String = ""   # "Leader", "Character", "Event", etc.
@export var attack: int = 0
@export var defense: int = 0

# Optional: Placeholder for card effect function
var effect = null

func _ready():
	# Load card data if needed, or initialize based on assigned values
	pass

func set_card_data(card_data):
	# Initialize card properties based on data passed in
	card_id = card_data.get("id", 0)
	card_name = card_data.get("name", "")
	card_type = card_data.get("type", "")
	attack = card_data.get("attack", 0)
	defense = card_data.get("defense", 0)
	effect = card_data.get("effect", null)
	
	update_visuals()

func update_visuals():
	# Add code to adjust card appearance based on type or other properties
	pass

func activate_effect():
	if effect:
		effect.execute()  # Assuming each effect can be "executed" or activated; adapt as needed
