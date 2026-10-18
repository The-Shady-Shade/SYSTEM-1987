class_name MainMenu extends Menu

@export_file("*.tscn") var map_path: String = ""
@export_file("*.tscn") var settings_path: String = ""
@export var boot_label: RichTextLabel = null
@export var system_label: Label = null
@export var command_label: RichTextLabel = null
@export var input_container: HBoxContainer = null
@export var input_line: LineEdit = null
@export var log_label: RichTextLabel = null
var loading: bool = true
var starting: bool = false

func _ready() -> void:
	boot_label.text = ""
	command_label.text = ""
	input_line.text = ""
	input_line.editable = false
	log_label.text = ""

	system_label.hide()
	input_container.hide()
	
	input_line.text_changed.connect(on_input_line_text_changed)
	input_line.text_submitted.connect(on_input_line_text_submitted)
	await run_boot_sequence(GameManager.boot)

func run_boot_sequence(force: bool = false) -> void:
	if !force:
		await type_line(boot_label, "C:\\SYSTEM-1987> BOOT.EXE")
		await type_line(boot_label, "BIOS v1.987")
		await type_line(boot_label, "MEMORY CHECK ........ OK")
		await type_line(boot_label, "HARDWARE STATUS ..... OLD")
		await type_line(boot_label, "NETWORK CONNECTION .. OFFLINE")
		
		#await get_tree().create_timer(0.5).timeout
		#await type_line(boot_label, "")
		#await type_line(boot_label, "UNKNOWN PROCESS DETECTED", 0.05)
		
		#await get_tree().create_timer(0.8).timeout
		#await type_line(boot_label, "SYSTEM INTEGRITY: COMPROMISED", 0.04)
		
		await get_tree().create_timer(0.6).timeout
	await fade_in(system_label, 1.0)
	
	await type_line(command_label, "AVAILABLE COMMANDS:")
	await type_line(command_label, "  PLAY      - START THE PROGRAM")
	await type_line(command_label, "  SETTINGS  - CONFIGURE SETTINGS")
	#await type_line(command_label, "  EXIT      - SHUT DOWN THE PROGRAMM")
	
	await get_tree().create_timer(0.5).timeout
	await fade_in(input_container, 0.5)
	input_line.editable = true
	input_line.grab_focus()
	
	loading = false
	GameManager.boot = true

func on_input_line_text_changed(_new_text: String) -> void:
	text_sound.pitch_scale = randf_range(0.85, 1.15)
	text_sound.play()

func on_input_line_text_submitted(input: String) -> void:
	if loading || starting: return
	
	var input_command: String = input.strip_edges().to_upper()
	if input_command.is_empty():
		input_line.grab_focus()
		return
	
	match input_command:
		"PLAY":
			starting = true
			input_line.editable = false
			log_label.text = ""
			
			submit_sound.pitch_scale = randf_range(0.85, 1.15)
			submit_sound.play()
			
			await type_line(log_label, "INITIALIZING THE PROGRAM...")
			await get_tree().create_timer(0.8).timeout

			SceneTransition.change_scene(map_path)
		"SETTINGS":
			starting = true
			input_line.editable = false
			log_label.text = ""
			
			submit_sound.pitch_scale = randf_range(0.85, 1.15)
			submit_sound.play()
			
			await type_line(log_label, "INITIALIZING THE SETTINGS MENU...")
			await get_tree().create_timer(0.8).timeout
			
			SceneTransition.change_scene(settings_path)
		"HERE":
			log_label.text = ""
			
			submit_sound.pitch_scale = randf_range(0.85, 1.15)
			submit_sound.play()
			
			await type_line(log_label, "SO YOU'RE THE FUNNY ONE :)")
			
			input_line.clear()
			input_line.grab_focus()
		_:
			log_label.text = ""
			
			error_sound.pitch_scale = randf_range(0.85, 1.15)
			error_sound.play()
			
			await type_line(log_label, "UNKNOWN COMMAND: " + input_command)
			
			input_line.clear()
			input_line.grab_focus()
