extends Window

var pickedFile = ""
var files = []

signal value_selected(result)
@onready var line_edit = $MarginContainer/LineEdit

func _ready() -> void:
	self.show()
	get_files()
	add_files_to_list()

func _process(delta: float) -> void:
	pass

func _on_close_requested() -> void:
	self.hide()
	
func get_files():
	var path = "res://Assets/SaveData/"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				files.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
func add_files_to_list():
	var vbox = get_node_or_null("VBoxContainer")
	if not vbox:
		print("Error: VBox not found at given path")
		return
	
	for file in files:
		var button_node = Button.new()
		var label = file.rstrip(".json")
		button_node.text = label
		button_node.pressed.connect(set_text.bind(label))
		vbox.add_child(button_node)
	
func set_text(text: String):
	if text == "":
		print("Error: text is somehow empty")
		return
		
	var text_line_node = get_node_or_null("MarginContainer/LineEdit")
	if not text_line_node:
		print("Error: could not locate text line node")
		return
		
	text_line_node.text = text

func _on_cancel_button_pressed() -> void:
	self.hide()

func _on_done_button_pressed() -> void:
	emit_signal("value_selected", line_edit.text)
	self.hide()
