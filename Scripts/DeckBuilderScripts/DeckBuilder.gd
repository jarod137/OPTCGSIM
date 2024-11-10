extends Node

var json = JSON.new()
var path = "res://Assets/CardData/data.json"
var card_data = []

var current_page = 0
var cards_per_page = 6

var deck = []

var draftDeck = Player_Deck.new()

# IMPORTANT: Change this to load if the scene is showing as corrupted
var deckBuilderScene = preload("res://Scenes/DeckBuilder/DeckBuilding.tscn")
var cardScene = preload("res://Scenes/DeckBuilder/DeckBuildContainer.tscn")
var deck_instance = deckBuilderScene.instantiate()

var currentOption = "ALL"

var currentSearch = ""

func _ready():
	load_card_data()
	populate_UI()

func _process(delta):
	pass

# Could probably be moved to Deck.gd
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
		
		
func populate_UI(min_index: int = 0, max_index: int = 6, search: String = ""):
	var canvas_layer = deck_instance.get_node_or_null("CanvasLayer")
	if not canvas_layer:
		print("Error: CanvasLayer not found")
		return
		
	var grid_container = canvas_layer.get_node_or_null("GridContainer")
	if not grid_container:
		print("Error: GridContainer not found")
		return
		
	for child in grid_container.get_children():
		child.queue_free()
	
	# Thinking about using index counter to keep track, and just keep incrementing that
	# Something like card count
	var index = min_index
	var cardCount = 0 
	
	while cardCount < cards_per_page && index < card_data.size():
		var card_info = card_data[index]
		var card_instance = cardScene.instantiate()
		
		var card_name = card_info["name"]
		
		if card_info["info"] == currentOption || currentOption == "ALL":
			if !search == "":
				if card_name.contains(search):
					var btn_node = card_instance.get_node("TextureButton")
					if btn_node:
						var img_path = card_info.get("imgPath", "")
						if img_path != "":
							var texture = load(img_path) as Texture2D
							btn_node.texture_normal = texture
						
					btn_node.pressed.connect(_on_texture_button_pressed.bind(card_info, card_instance))	
					grid_container.add_child(card_instance)
					cardCount += 1
			else:
				var btn_node = card_instance.get_node("TextureButton")
				if btn_node:
					var img_path = card_info.get("imgPath", "")
					if img_path != "":
						var texture = load(img_path) as Texture2D
						btn_node.texture_normal = texture
					
				btn_node.pressed.connect(_on_texture_button_pressed.bind(card_info, card_instance))	
				grid_container.add_child(card_instance)
				cardCount += 1
			
		
		index += 1

	add_child(deck_instance)
	
func _on_texture_button_pressed(info, instance) -> void:
	print("Button pressed for: ", info["name"])
	deck.append(info)
	
	# TODO: testing needed
	if info["info"] == "LEADER":
		if draftDeck.has_leader():
			print("Leader already picked")
			return
		else:
			draftDeck.set_leader(info)
			add_to_leader_container(info)
			return
	else:
		if !draftDeck.has_leader():
			print("Error: there is not a leader picked")
			return
	
	var cardColors = draftDeck.parseColor(info)
	
	for cardColor in cardColors:
		for leaderColor in draftDeck.leaderColor:
			if cardColor == leaderColor:
				draftDeck.add_to_deck(info)
				add_to_deck_container(info)
	
	print("Error: color does not match")
	return
		
func add_to_leader_container(info):
	var canvas_layer = deck_instance.get_node_or_null("CanvasLayer")
	if not canvas_layer:
		print("Error: CanvasLayer not found")
		return
		
	var container = canvas_layer.get_node_or_null("Container")
	if not container:
		print("Error: container not found")
		return
		
	var card_instance = cardScene.instantiate()
	
	var btn_node = card_instance.get_node("TextureButton")
	if btn_node:
		var img_path = info.get("imgPath", "")
		if img_path != "":
			var texture = load(img_path) as Texture2D
			btn_node.texture_normal = texture
		
	container.add_child(card_instance)
	
func add_to_deck_container(info):
	var canvas_layer = deck_instance.get_node_or_null("CanvasLayer")
	if not canvas_layer:
		print("Error: CanvasLayer not found")
		return
		
	var scroll_node = canvas_layer.get_node_or_null("ScrollContainer")
	if not scroll_node:
		print("Error: scroll_node not found")
		return
		
	var deck_container = scroll_node.get_node_or_null("DeckContainer")
	if not deck_container:
		print("Error: deck_container not found")
		return
		
	var card_instance = cardScene.instantiate()
	
	var btn_node = card_instance.get_node("TextureButton")
	if btn_node:
		var img_path = info.get("imgPath", "")
		if img_path != "":
			var texture = load(img_path) as Texture2D
			btn_node.texture_normal = texture
			
	deck_container.add_child(card_instance)
	
# Next page button hit
func _on_button_pressed():
	current_page += 1
	var min_index = current_page * cards_per_page
	var max_index = min_index + cards_per_page
	print("currentSearch: ", currentSearch)
	populate_UI(min_index, max_index, currentSearch)

# Main menu button
func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")

func _on_save_button_pressed():
	print("Save button pressed")
	if draftDeck.has_leader() == true && (draftDeck.get_cards().size() >= 50):
		draftDeck.save_to_JSON()

func _on_previous_button_pressed():
	if current_page < 1:
		print("Error: already on the first page")
		return
	
	current_page -= 1
	var min_index = current_page * cards_per_page
	var max_index = min_index + cards_per_page
	print("currentSearch: ", currentSearch)
	populate_UI(min_index, max_index, currentSearch)

func _on_option_button_item_selected(index):
	var min_index = current_page * cards_per_page
	var max_index = min_index + cards_per_page
	
	match index:
		0:
			currentOption = "ALL"
			
		1:
			currentOption = "LEADER"
		2:
			currentOption = "CHARACTER"
		3:
			currentOption = "EVENT"
		4:
			currentOption = "STAGE"
		_:
			print("Error: invalid input...somehow")
			
	var option_node = deck_instance.get_node_or_null("CanvasLayer/Filter/OptionButton")
	if not option_node:
		print("Error: could not find option node")
		
	option_node.selected = index
	populate_UI(min_index, max_index, currentSearch)


func _on_line_edit_text_submitted(new_text):
	currentSearch = new_text
	var min_index = current_page * cards_per_page
	var max_index = min_index + cards_per_page
	populate_UI(min_index, max_index, currentSearch)
