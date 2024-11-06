extends Node

var json = JSON.new()
var path = "res://Assets/CardData/data.json"
var card_data = []

var current_page = 0
var cards_per_page = 12

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
		
		
func populate_UI(min_index: int = 0, max_index: int = 12):
	var deckBuilderScene = preload("res://Scenes/DeckBuilder/DeckBuilding.tscn")
	var cardScene = preload("res://Scenes/DeckBuilder/DeckBuildContainer.tscn")
	
	var deck_instance = deckBuilderScene.instantiate()
	
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
	
	for i in range(min_index, min(max_index, card_data.size())):
		var card_info = card_data[i]
		var card_instance = cardScene.instantiate()
		
		var sprite_node = card_instance.get_node("cardImages")
		if sprite_node:
			var img_path = card_info.get("imgPath", "")
			if img_path != "":
				var texture = load(img_path) as Texture2D
				sprite_node.texture = texture

		var button_node = card_instance.get_node_or_null("Button")
		
		if button_node:
			button_node.pressed.connect(_on_card_pressed.bind(card_instance))
		else:
			print("Error: btn not found")
		
		grid_container.add_child(card_instance)
		
	add_child(deck_instance)
	
func _on_card_pressed(card_instance):
	print("Button clicked for ", card_instance)

func _on_mouse_entered():
	pass # Replace with function body.

func _on_mouse_exited():
	pass # Replace with function body.

# Next page button hit
func _on_button_pressed():
	current_page += 1
	var min_index = current_page * cards_per_page
	var max_index = min_index + cards_per_page
	populate_UI(min_index, max_index)


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")
