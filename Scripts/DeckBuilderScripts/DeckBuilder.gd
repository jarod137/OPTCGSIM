
# DeckBuilder.gd
# Responsible for most if not all of the deck builder capabilities. This includes (leader selection, supporter selection, search, saving, loading)

extends Node

var json = JSON.new()
var path = "res://Assets/CardData/data.json"
var card_data = []

var current_page = 0
var cards_per_page = 6

var deck = []

# Deck object that is connected to Player_Deck class that handles saving, loading, setting leaders, etc.
var draftDeck

var deckBuilderScene = preload("res://Scenes/DeckBuilder/DeckBuilding.tscn")
var cardScene = preload("res://Scenes/DeckBuilder/DeckBuildContainer.tscn")

@onready var popupScene = preload("res://Scenes/DeckBuilder/PopUpLoad.tscn")
@onready var popUpSave = preload("res://Scenes/DeckBuilder/PopUpSave.tscn")

var currentOption = "ALL"
var currentSearch = ""

func _ready():
	# Instantiates a new PlayerDeck object
	draftDeck = Player_Deck.new()
	load_card_data()
	populate_UI()

func _process(delta):
	pass

# This currently is set to load data from the path specified at the top of this file by default. We thought this would help new users better understand the initial layout of the tool.
func load_card_data():
	var fileExists = FileAccess.file_exists(path)
	
	# Checks if the file specified at the top of the file is present or not. 
	# If file is found, it is parsed and prepped for populateUI()
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
		
	
# Responsible for loading assets to screen. 
# Takes at most 3 args that are composed of optional args. If optional args are not passed, default to 0, 6, and "" respectively.
# 	min_index: the lowest index in the data array that should be loaded to the screen.
#	max_index: the max index in the data array that should be loaded to the screen.
# 	search: the string that will be used to filter the results from search. 
func populate_UI(min_index: int = 0, max_index: int = 6, search: String = ""):
	var canvas_layer = get_node_or_null("CanvasLayer")
	if not canvas_layer:
		print("Error: CanvasLayer not found")
		return
		
	var grid_container = canvas_layer.get_node_or_null("GridContainer")
	if not grid_container:
		print("Error: GridContainer not found")
		return
		
	for child in grid_container.get_children():
		child.queue_free()
	
	var index = min_index
	var cardCount = 0 
	
	# performs computations while between min and max index
	while cardCount < cards_per_page && index < card_data.size():
		var card_info = card_data[index]
		var card_instance = cardScene.instantiate()
		
		var card_name = card_info["name"]
		
		if card_info["info"] == currentOption || currentOption == "ALL":
			if !search == "":
				# Checks if the card title is part of the search
				if card_name.contains(search):
					var btn_node = card_instance.get_node("TextureButton")
					if btn_node:
						var img_path = card_info.get("imgPath", "")
						if img_path != "":
							var texture = load(img_path) as Texture2D
							btn_node.texture_normal = texture
						
					# Connects a button pressed listener to each of the displayed cards for user interaction. Connects to _on_texture_button_pressed()
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
				
				# Connects a button pressed listener to each of the displayed cards for user interaction. Connects to _on_texture_button_pressed()
				btn_node.pressed.connect(_on_texture_button_pressed.bind(card_info, card_instance))	
				grid_container.add_child(card_instance)
				cardCount += 1
			
		
		index += 1

# Responsible for interactive with the Deck.gd class. takes two mandatory args that represent the parsed card info, and the actual card instance
func _on_texture_button_pressed(info, instance) -> void:
	print("Button pressed for: ", info["name"])
	deck.append(info)
	
	# checks if the passed card type is LEADER
	if info["info"] == "LEADER":
		# Checks if the deck already has a leader specified or not. If it does, then the code will return and not allow user to set new leader.
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
	
	# Parses the colors of the passed card
	var cardColors = draftDeck.parseColor(info)
	
	# Checks if any of the passed card colors matches any of the leader card colors. Adds to deck if check is passed.
	for cardColor in cardColors:
		for leaderColor in draftDeck.leaderColor:
			if cardColor == leaderColor:
				draftDeck.add_to_deck(info)
				add_to_deck_container(info)
	
	print("Error: color does not match")
	return

# Responsible for adding card to leader slot. 
func add_to_leader_container(info):
	var canvas_layer = get_node_or_null("CanvasLayer")
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
	
# Responsible for adding card to general deck selection slots. 
func add_to_deck_container(info):
	var canvas_layer = get_node_or_null("CanvasLayer")
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
	var min_index = current_page * cards_per_page # multiplies the current page by the amount of cards per page to get new min_index
	var max_index = min_index + cards_per_page # multiplies the current page by the amount of cards per page to get new max_index
	populate_UI(min_index, max_index, currentSearch) # Calls populate_UI() to reflect changes

# Main menu button
func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")

# Responsbile for prompting user with a save deck popup that is connected to _on_save_popup_value_selected()
func _on_save_button_pressed():
	print("Save button pressed")
	
	var popup_instance = popUpSave.instantiate()
	add_child(popup_instance)
	popup_instance.position = get_viewport().size / 2
	
	popup_instance.value_selected.connect(_on_save_popup_value_selected)
	
# Saves the deck with the specified filename. 
func _on_save_popup_value_selected(filename):
	if filename == "":
		print("Error: no filename is specified")
		return
	
	# Performs a check to see if the user has specified a leader and that the deck amount is less than 50.
	if draftDeck.has_leader() == true && (draftDeck.get_cards().size() <= 50):
		# Saves the deck to the file with specified filename. 
		draftDeck.save_to_JSON(filename)

func _on_previous_button_pressed():
	# Checks if page value can be lower
	if current_page < 1:
		print("Error: already on the first page")
		return
	
	current_page -= 1
	var min_index = current_page * cards_per_page 
	var max_index = min_index + cards_per_page
	populate_UI(min_index, max_index, currentSearch)

# Responsbile for filtering out the cards to match the type specfied.
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
			
	var option_node = get_node_or_null("CanvasLayer/Filter/OptionButton")
	if not option_node:
		print("Error: could not find option node")
		
	option_node.selected = index # Updates global var to relfect change
	populate_UI(min_index, max_index, currentSearch) # calls populate_UI() to reflect changes

# Updates the global var currentSearch to input specified and sets all helper variables accordingly. 
func _on_line_edit_text_submitted(new_text):
	currentSearch = new_text
	var min_index = current_page * cards_per_page
	var max_index = min_index + cards_per_page
	current_page = 0
	populate_UI(min_index, max_index, currentSearch)

# Prompts the user with a load deck popup screen. Connects listener to _on_load_popup_value_selected()
func _on_load_button_pressed():
	var popup_instance = popupScene.instantiate()
	add_child(popup_instance)
	popup_instance.position = get_viewport().size / 2
	
	popup_instance.value_selected.connect(_on_load_popup_value_selected)

# FIXME: Need to check if this is being implemented and used. If not need to purge
func get_text_content() -> String:
	var text = get_node_or_null("CanvasLayer/FileName")
	if text.text == null:
		print("Error: please specify a file name")
		return ""
		
	return text.text

# Checks if the passed string val is a valid filename and parses if so. Clears current screen before populating with new selection. 
func _on_load_popup_value_selected(value: String) -> void:
	var fileName = value
	if fileName == "":
		print("Error: no filename specified")
		return
	
	var leader_node = get_node_or_null("CanvasLayer/Container")
	if not leader_node:
		print("Error: leader node not found")
		return
	
	for child in leader_node.get_children():
		child.queue_free()
			
	var deck_node = get_node_or_null("CanvasLayer/ScrollContainer/DeckContainer")
	if not deck_node:
		print("Error: deck node not found")
		return
	
	for child in deck_node.get_children():
		child.queue_free()
	
	draftDeck.read_JSON(fileName)
	
	if !draftDeck.leader == null:
		add_to_leader_container(draftDeck.leader)
	
	deck = draftDeck.get_cards()
	
	for card in draftDeck.cards:
		add_to_deck_container(card)
