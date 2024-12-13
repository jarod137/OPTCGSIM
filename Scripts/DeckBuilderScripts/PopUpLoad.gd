
# PopUpLoad.gd
# A simple popup view that extends Window class to prompt user with a list of files located at the "res://Assets/SaveData/" dir.

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

# Fetches all files are specified dir and appends them to files arr 
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

# Populates UI to reflect all located files and connect a button pressed listener 	to set_text()
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

# Sets the global text var to the specified string value if the passed value is not ""	
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

# emits a single that a selection was made
func _on_done_button_pressed() -> void:
	emit_signal("value_selected", line_edit.text)
	self.hide()
