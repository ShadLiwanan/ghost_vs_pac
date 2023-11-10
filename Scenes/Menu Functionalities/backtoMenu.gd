extends Node2D

#var inky = preload("res://Assets/Playable Ghosts/CyanGhost.tscn")
#var blinky = preload("res://Assets/Playable Ghosts/RedGhost.tscn")
#var pinky = preload("res://Assets/Playable Ghosts/PinkGhost.tscn")
#var clyde = preload("res://Assets/Playable Ghosts/OrangeGhost.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")


func _on_next_pressed():
	get_tree().change_scene_to_file("res://Scenes/ghostsDescription.tscn")


func _on_clyde_pressed() -> void:
	pass # Replace with function body.

func _on_pinky_pressed() -> void:
	pass # Replace with function body.

func _on_blinky_pressed() -> void:
	pass # Replace with function body.

func _on_inky_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
