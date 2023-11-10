extends Node2D

func _on_instructions_pressed():
	get_tree().change_scene_to_file("res://Scenes/instructionsScreen.tscn")


func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/ghostSelectionScreen.tscn")
	
func _on_exit_pressed():
	get_tree().quit()
