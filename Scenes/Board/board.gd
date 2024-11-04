extends Node3D

# Make sure to point to the actual scene files (.tscn) for card and zone instances.
const CARD_SCENE_PATH = "res://Scenes/Board/card_3d.tscn" # Update this to point to the .tscn file
const ZONE_PATHS = {
	"HandZone": "res://Scenes/Board/hand_zone.tscn",
	"DeckZone": "res://Scenes/Board/deck_zone.tscn",
	"TrashZone": "res://Scenes/Board/trash_zone.tscn",
	"CharacterZone": "res://Scenes/Board/character_zone.tscn",
	"LifeZone": "res://Scenes/Board/life_zone.tscn",
	"LeaderZone": "res://Scenes/Board/leader_zone.tscn",
	"DonDeckZone": "res://Scenes/Board/don_deck_zone.tscn",
	"DonZone": "res://Scenes/Board/don_zone.tscn"
}

var player1
var player2
var center
var turn_manager = 1

func _ready():
	# Find the Player and Center nodes
	player1 = $Player1
	player2 = $Player2
	center = $Center

	# Setup each player's zones based on the structure
	if player1 and player2 and center:
		setup_zones(player1)
		setup_zones(player2)

		# Populate each player's deck with cards
		initialize_deck(player1, 5)
		initialize_deck(player2, 5)
	else:
		print("Error: Player or Center nodes are not found!")

# Function to set up zones for a player

func setup_zones(player):
	for zone_name in ZONE_PATHS.keys():
		var zone_scene = load(ZONE_PATHS[zone_name])  # Use load for dynamic path resolution
		if zone_scene:
			var zone = zone_scene.instance()  # Instance the zone scene
			player.add_child(zone)
			zone.name = zone_name
		else:
			print("Error: Zone scene not found for", zone_name)



# Function to initialize a deck with cards for each player
func initialize_deck(player, num_cards):
	var deck_zone = player.get_node("DeckZone")
	if deck_zone:
		for i in range(num_cards):
			var card_instance = preload(CARD_SCENE_PATH).instance()  # Preload and instance the card scene

			# Example data for each card, ideally pulled from your card data file
			var card_data = {
				"id": i,
				"name": "Example Card " + str(i),
				"type": "Character",
				"attack": randi() % 5 + 1,  # Random attack between 1 and 5
				"defense": randi() % 5 + 1,  # Random defense between 1 and 5
				"effect": null  # Define effect if applicable
			}

			card_instance.set_card_data(card_data)
			deck_zone.add_child(card_instance)
			position_card_in_zone(card_instance, deck_zone, i)
	else:
		print("Error: DeckZone not found in player!")

# Position cards within each zone
func position_card_in_zone(card_instance, zone, index):
	var card_count = zone.get_child_count()
	card_instance.translation = Vector3(index * 0.2 - (card_count - 1) * 0.1, 0, 0)  # Centering cards
	card_instance.rotation_degrees = Vector3(0, 0, 0)

# Example turn manager function
func next_turn():
	if turn_manager == 1:
		draw_card(player1)
		turn_manager = 2
	else:
		draw_card(player2)
		turn_manager = 1

# Function to draw a card from deck to hand
func draw_card(player):
	var deck_zone = player.get_node("DeckZone")
	var hand_zone = player.get_node("HandZone")

	if deck_zone and hand_zone and deck_zone.get_child_count() > 0:
		var card = deck_zone.get_child(0)
		deck_zone.remove_child(card)
		hand_zone.add_child(card)
		position_card_in_zone(card, hand_zone, hand_zone.get_child_count() - 1)
	else:
		print("Error: HandZone or DeckZone not found or empty!")
