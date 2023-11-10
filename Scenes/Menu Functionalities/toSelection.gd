extends Node2D

func _on_next_pressed():
	get_tree().change_scene_to_file("res://Scenes/ghostSelectionScreen.tscn")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/instructionsScreen.tscn")
