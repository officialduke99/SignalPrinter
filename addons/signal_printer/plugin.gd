@tool
extends EditorPlugin

const TYPE_NAME : String = "SignalPrinter"
const SCRIPT : GDScript = preload("res://addons/signal_printer/signal_printer.gd")
const ICON : Texture2D = preload("res://icon.svg")

func _enter_tree() -> void:
	add_custom_type(TYPE_NAME, "Node", SCRIPT, ICON)


func _exit_tree() -> void:
	remove_custom_type(TYPE_NAME)
