extends Control

@export_file("*.tscn") var map_path: String = ""
@export var terminal_label: RichTextLabel = null
@export var name_label: Label = null
@export var status_label: Label = null
@export var input_line: LineEdit
var loading: bool = true
var starting: bool = false

func _ready() -> void:
	terminal_label.text = ""
	input_line.text = ""
	input_line.editable = false

	name_label.hide()
	status_label.hide()
	input_line.hide()

	input_line.text_submitted.connect(_on_command_submitted)

	await run_boot_sequence()

func run_boot_sequence() -> void:
	await type_line("BIOS v1.987")
	await type_line("MEMORY CHECK ........ OK")
	await type_line("HARDWARE STATUS ..... OLD")
	await type_line("NETWORK CONNECTION .. OFFLINE")

	await get_tree().create_timer(0.5).timeout

	await type_line("")
	await type_line("UNKNOWN PROCESS DETECTED", 0.05)

	await get_tree().create_timer(0.8).timeout

	await type_line("SYSTEM INTEGRITY: COMPROMISED", 0.04)

	await get_tree().create_timer(0.6).timeout

	await fade_in(name_label, 1.0)

	status_label.text = "ARTIFICIAL INTELLIGENCE SYSTEM"
	await fade_in(status_label, 0.6)

	await get_tree().create_timer(0.5).timeout

	input_line.placeholder_text = "TYPE PLAY TO BEGIN"
	await fade_in(input_line, 0.5)

	input_line.editable = true
	input_line.grab_focus()

	loading = false

func type_line(line: String, delay: float = 0.025) -> void:
	for i: int in range(line.length()):
		terminal_label.append_text(line.substr(i, 1))
		await get_tree().create_timer(delay).timeout

	terminal_label.append_text("\n")

func fade_in(node: Control, duration: float) -> void:
	node.show()
	node.modulate.a = 0.0

	var tween: Tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, duration)

	await tween.finished

func _on_command_submitted(command: String) -> void:
	if loading || starting: return

	var input_command: String = command.strip_edges().to_upper()
	if input_command == "PLAY":
		starting = true
		input_line.editable = false

		await type_line("")
		await type_line("> PLAY")
		await type_line("INITIALIZING GAME...")

		await get_tree().create_timer(0.8).timeout

		if map_path.is_empty():
			status_label.text = "ERROR: GAME SCENE NOT SET"
			starting = false
			input_line.editable = true
			input_line.grab_focus()
			return

		SceneTransition.change_scene(map_path)
	else:
		status_label.text = "UNKNOWN COMMAND: " + input_command
		input_line.clear()
		input_line.grab_focus()
