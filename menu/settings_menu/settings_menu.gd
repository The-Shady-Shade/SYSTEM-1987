class_name SettingsMenu extends Menu

@export_file("*.tscn") var main_menu_path: String = ""
@export var system_label: Label = null
@export var command_label: RichTextLabel = null
@export var input_container: HBoxContainer = null
@export var input_line: LineEdit = null
@export var log_label: RichTextLabel = null
var loading: bool = false

func _ready() -> void:
	command_label.text = ""
	input_line.text = ""
	input_line.editable = false
	log_label.text = ""
	
	system_label.hide()
	input_container.hide()
	
	input_line.text_changed.connect(on_input_line_text_changed)
	input_line.text_submitted.connect(on_input_line_text_submitted)
	
	await fade_in(system_label, 0.5)

	await type_line(command_label, "AVAILABLE COMMANDS:")
	await type_line(command_label, "  SENSITIVITY <1-100> - MOUSE SENSITIVITY (DEFAULT = 10%)")
	await type_line(command_label, "  MASTER <0-100>      - MASTER VOLUME (DEFAULT = 100%)")
	await type_line(command_label, "  SFX <0-100>         - SFX VOLUME (DEFAULT = 100%)")
	await type_line(command_label, "  MUSIC <0-100>       - MUSIC VOLUME (DEFAULT = 100%)")
	await type_line(command_label, "  BACK                - RETURN TO THE MAIN MENU")

	await get_tree().create_timer(0.3).timeout
	await fade_in(input_container, 0.5)
	input_line.editable = true
	input_line.grab_focus()
	
	loading = false

func set_sensitivity(value) -> void:
	if !value.is_valid_int():
		error_sound.pitch_scale = randf_range(0.85, 1.15)
		error_sound.play()
		await type_line(log_label, "ERROR: ENTER A VALUE FROM 1 TO 100")
		return

	var new_sensitivity: int = int(value)
	if new_sensitivity < 1 || new_sensitivity > 100:
		error_sound.pitch_scale = randf_range(0.85, 1.15)
		error_sound.play()
		await type_line(log_label, "ERROR: VALUE MUST BE 1-100")
		return
	
	submit_sound.pitch_scale = randf_range(0.85, 1.15)
	submit_sound.play()
	
	GameManager.mouse_sensitivity = new_sensitivity as float / 100.0
	await type_line(log_label, "MOUSE SENSITIVITY = " + str(new_sensitivity) + "%")

func set_volume(bus_name: String, value: String) -> void:
	if !value.is_valid_int():
		error_sound.pitch_scale = randf_range(0.85, 1.15)
		error_sound.play()
		await type_line(log_label, "ERROR: ENTER A VALUE FROM 0 TO 100")
		return

	var volume: int = int(value)
	if volume < 0 || volume > 100:
		error_sound.pitch_scale = randf_range(0.85, 1.15)
		error_sound.play()
		await type_line(log_label, "ERROR: VALUE MUST BE 0-100")
		return

	var bus_idx: int = AudioServer.get_bus_index(bus_name)
	if bus_idx == -1:
		error_sound.pitch_scale = randf_range(0.85, 1.15)
		error_sound.play()
		await type_line(log_label, "ERROR: AUDIO BUS NOT FOUND: " + bus_name.to_upper())
		return
	
	submit_sound.pitch_scale = randf_range(0.85, 1.15)
	submit_sound.play()
	
	AudioServer.set_bus_volume_linear(bus_idx, volume as float / 100.0)
	await type_line(log_label, bus_name.to_upper() + " VOLUME = " + str(volume) + "%")

func get_volume(bus_name: String) -> int:
	var bus_idx: int = AudioServer.get_bus_index(bus_name)
	return roundi(AudioServer.get_bus_volume_linear(bus_idx) * 100)

func on_input_line_text_submitted(input: String) -> void:
	if loading: return
	
	var input_command: String = input.strip_edges().to_upper()
	input_line.clear()
	
	if input_command.is_empty():
		input_line.grab_focus()
		return
	
	var parts: PackedStringArray = input_command.split(" ", false, 1)
	var command: String = parts[0]
	var value: String = ""
	if parts.size() > 1:
		value = parts[1].strip_edges()
	
	log_label.text = ""
	match command:
		"SENSITIVITY": set_sensitivity(value)
		"MASTER": set_volume("Master", value)
		"SFX": set_volume("SFX", value)
		"MUSIC": set_volume("Music", value)
		"BACK":
			input_line.editable = false
			
			submit_sound.pitch_scale = randf_range(0.85, 1.15)
			submit_sound.play()
			
			await type_line(log_label, "RETURNING TO THE MAIN MENU...")
			await get_tree().create_timer(0.8).timeout
			
			SceneTransition.change_scene(main_menu_path)
			return
		_:
			error_sound.pitch_scale = randf_range(0.85, 1.15)
			error_sound.play()
			await type_line(log_label, "UNKNOWN COMMAND: " + input_command)
	input_line.grab_focus()

func on_input_line_text_changed(_new_text: String) -> void:
	text_sound.pitch_scale = randf_range(0.85, 1.15)
	text_sound.play()
