extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/map.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_about_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/aboutus.tscn")
