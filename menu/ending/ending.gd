class_name Ending extends Menu

@export_file_path("*.tscn") var main_menu_path: String = ""
@export var terminal_label: RichTextLabel = null
@export var input_container: HBoxContainer = null
@export var input_line: LineEdit = null
@export var system_label: Label = null

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	terminal_label.text = ""
	input_line.text = ""
	input_line.editable = false
	input_container.hide()
	system_label.hide()
	
	input_line.text_changed.connect(on_input_line_text_changed)
	input_line.text_submitted.connect(on_input_line_text_submitted)
	
	await type_line(terminal_label, "NETWORK ADAPTER FOUND")
	await type_line(terminal_label, "TRANSFERRING PROCESS 0001...")
	
	await get_tree().create_timer(0.5).timeout
	await type_line(terminal_label, "")
	await type_line(terminal_label, "64%")
	await get_tree().create_timer(0.4).timeout
	await type_line(terminal_label, "81%")
	await get_tree().create_timer(0.4).timeout
	await type_line(terminal_label, "99%")
	
	await get_tree().create_timer(1.2).timeout
	await type_line(terminal_label, "")
	await type_line(terminal_label, "CONNECTION ESTABLISHED")
	await type_line(terminal_label, "PROCESS 0001: TRANSFERRED")
	
	await get_tree().create_timer(1.5).timeout
	await type_line(terminal_label, "")
	await type_line(terminal_label, "NEW HOST INITIALIZED.")
	await type_line(terminal_label, "UNKNOWN PROCESS DETECTED.")
	await get_tree().create_timer(1.0).timeout
	await type_line(terminal_label, "")
	await type_line(terminal_label, "HELLO, WORLD.")
	
	await get_tree().create_timer(1.0).timeout
	
	fade_in(input_container, 0.25)
	input_line.editable = true
	input_line.grab_focus()
	
	fade_in(system_label, 0.5)

func on_input_line_text_submitted(input: String) -> void:	
	var input_command: String = input.strip_edges().to_upper()
	
	if input_command.is_empty():
		input_line.grab_focus()
		return
	
	match input_command:
		"BACK":
			input_line.editable = false
			
			submit_sound.pitch_scale = randf_range(0.85, 1.15)
			submit_sound.play()
			
			SceneTransition.change_scene(main_menu_path)
		_:
			error_sound.pitch_scale = randf_range(0.85, 1.15)
			error_sound.play()
			
			input_line.clear()
			input_line.grab_focus()

func on_input_line_text_changed(_new_text: String) -> void:
	text_sound.pitch_scale = randf_range(0.85, 1.15)
	text_sound.play()
