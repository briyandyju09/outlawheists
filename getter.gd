extends StaticBody2D

var player_in_area = false
var claimed = 0

func _on_area_2d_body_entered(body):
	if body.has_method("player_sell_method"):
		player_in_area = true  # Set player_in_area to true when the player enters

func _on_area_2d_body_exited(body):
	if body.has_method("player_sell_method"):
		player_in_area = false  # Set player_in_area to false when the player exits

func _process(delta):
	if player_in_area and Input.is_action_just_pressed("interact"):  # Check if E key is pressed
		if claimed <= 0:
			print("working")
			var random_number = randi_range(1, 10)
			Global.noofbag += random_number
			print(random_number)
			claimed += 1
		else:
			print("already claimed")
