#class_name IconLibrary 
extends Node

var icon_library = {}
const icon_paths: Array[String] = [
	"res://icon_data/damage_icon.tres",
	"res://icon_data/armor_icon.tres",
	"res://icon_data/damage_armor_icon.tres"
]

func compile_icon_library():
	var icon_id: int = 0
	for icon_path in icon_paths:
		var icon_data: IconData = load(icon_path)
		icon_library[icon_id] = icon_data
		icon_id += 1
