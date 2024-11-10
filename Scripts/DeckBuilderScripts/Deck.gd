extends Control

# TODO: This entire class needs to be tested
class_name Player_Deck

var leader = null

var leaderColor = []

var cards = []
var json = JSON.new()

func has_leader() -> bool:
	if leader == null:
		return false
		
	return true
	
func set_leader(newLeader) -> bool:
	leader = newLeader
	
	if leader == newLeader:
		print("New leader set succcessfullly")
		leaderColor = parseColor(newLeader)
		return true
	else:
		print("Error: something went wrong")
		return false
		
# TODO: needs to be tested
func remove_leader() -> bool:
	leader = null
	leaderColor = null
	
	if leader == null:
		return true
	else:
		return false
		
# TODO: needs to implement a check for max amount of cards
func add_to_deck(card) -> void:
	if has_leader() == false:
		print("Error: cannot add until you select a leader.")
		return
	
	if max_cards_reached():
		print("Error: max amount of cards reached")
		return
	
	cards.append(card)
	
func max_cards_reached() -> bool:
	if cards.size() > 50:
		return true
		
	return false
	
func save_to_JSON() -> void:
	var deckSave = "res://Assets/SaveData/save.json"
	var saveFile = FileAccess.open(deckSave, FileAccess.WRITE)
	
	var save_dict = {
		"Leader": leader,
		"Cards": cards
	}
	
	print(save_dict)
	
	var json_string = JSON.stringify(save_dict, "\t")
	saveFile.store_string(json_string)
	saveFile.close()

# TODO: needs to be implemented && needs corresponding button
func read_JSON() -> bool:
	return false
	
func parseColor(info) -> Array:
	var colorInfo = info["color"]
	var parsedColorInfo = colorInfo.rsplit("/", true)
	return parsedColorInfo

func get_cards() -> Array:
	return cards
	
func _init():
	leader = null
	print("constructed", self)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
