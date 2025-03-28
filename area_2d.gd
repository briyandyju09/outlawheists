extends Area2D

@export var player: Node2D  # Assign your player in the Inspector
@export var new_z_index: int = 5  # Set the Z index when inside the area

var original_z_index: int

func _ready():
	if player:
		original_z_index = player.z_index

func _on_area_entered(_body):
	if _body == player:
		player.z_index = new_z_index  # Move player in front

func _on_area_exited(_body):
	if _body == player:
		player.z_index = original_z_index  # Restore original z-index
