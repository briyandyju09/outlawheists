extends Area2D

var entered = false

func _on_body_entered(body: PhysicsBody2D):
	entered = true

func _on_body_exited(body: PhysicsBody2D):
	entered = false

func _process(delta):
	if entered and Input.is_action_just_pressed("interact"):
		var scene_tree = get_tree()
		if scene_tree:
			SceneManager.change_scene("res://Scenes/town.tscn")
