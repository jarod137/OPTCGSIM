extends Node

var json = JSON.new()
var path = "res://Assets/CardData/cards.json"

var card_data = []

func _ready():
	load_card_data()
	populate_UI()

func _process(delta):
	pass
	

func load_card_data():
	var fileExists = FileAccess.file_exists(path)
	
	if fileExists:
		var file = FileAccess.open(path, FileAccess.READ)
		var fileContents = file.get_as_text()
		
		var result = json.parse(fileContents)
		file.close()
		
		if result == OK:
			card_data = json.get_data()
			print("Loaded card data successfully")
		else:
			print("Error: could not parse JSON file", result.error_string)
	else:
		print("Error: JSON file not found")
		
func populate_UI():
	var deckBuilderScene = preload("res://Scenes/DeckBuilder/DeckBuilder.tscn")
	
	var grid = $CanvasLayer/GridContainer
	
	if !grid:
		print("Error: Existing GridContainer not found in scene")
		return
	
	grid.add_theme_constant_override("h_separation", 20)
	grid.add_theme_constant_override("v_separation", 20)
	
	for card_info in card_data:
		var card_instance = deckBuilderScene.instantiate()
	
		var name_node = card_instance.get_node_or_null("CanvasLayer/GridContainer/Control/character_name")
		if name_node:
			name_node.text = card_info["name"]
		else:
			print("character_name node not found - check the path: CanvasLayer/GridContainer/Control/character_name")
		
		grid.add_child(card_instance)
