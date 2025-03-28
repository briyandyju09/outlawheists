extends Area2D

var entered = false

func _ready():
	pass

func _on_body_entered(body: PhysicsBody2D):
	entered = true

func _on_body_exited(body):
	entered = false

func _process(delta):
	if entered and Input.is_action_just_pressed("interact"):
		SceneManager.change_scene("res://Scenes/pawn_shop.tscn")
		Global.teleportme = true
