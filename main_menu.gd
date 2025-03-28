extends Control


func _on_start_pressed():
	SceneManager.change_scene("res://Scenes/town.tscn")


func _on_helped_pressed():
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
