extends Control

var deck = []

var cardScene = preload("res://Scenes/Game/DeckContainer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_deck()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_deck():
	var game_deck = Player_Deck.new()
	
	game_deck.read_JSON()
	deck = game_deck.get_cards()
	
	set_leader_container(game_deck.leader)
	
	for card in deck:
		set_deck_container(card)
		
func set_leader_container(info):
	var leader_container = self.get_node_or_null("LeaderZone")
	if not leader_container:
		print("Error: Leader container not found")
		return
	
	var card_instance = cardScene.instantiate()
	
	var btn_node = card_instance.get_node_or_null("TextureButton")
	if not btn_node:
		print("Error: Btn node not found")
		return
	
	var img_path = info.get("imgPath", "")
	if img_path == "":
		print("Error: imgPath is empty")
		return
		
	var texture = load(img_path) as Texture2D
	btn_node.texture_normal = texture
	
	leader_container.add_child(card_instance)
	
func set_deck_container(info):
	var deck_container = self.get_node_or_null("Deck")
	if not deck_container:
		print("Error: deck container not found")
		return
		
	var card_instance = cardScene.instantiate()
	
	var btn_node = card_instance.get_node_or_null("TextureButton")
	if not btn_node:
		print("Error: Btn node not found")
		return
		
	var img_path = "res://Assets/CardBacks/backcard7.png"
	var texture = load(img_path) as Texture2D
	btn_node.texture_normal = texture
	btn_node.pressed.connect(_on_texture_button_pressed.bind(info))
	
	deck_container.add_child(card_instance)
	
func _on_texture_button_pressed(info):
	print(info)
