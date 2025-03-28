extends CharacterBody2D

@export var speed = 250
@onready var animated_sprite = $AnimatedSprite2D
@onready var camera = $Camera2D
@onready var detection_area = $Area2D

var last_direction = 1  # calculate where da guy lookin
var is_punching = false  # punch

func _ready():
	await get_tree().process_frame
	if is_multiplayer_authority():
		camera.make_current() #camera focus on user only
		Global.hud_ref.hide()
	else:
		camera.enabled = false

func _physics_process(delta):
	if !is_multiplayer_authority(): #disable letting anyone control you
		return
	if is_punching:
		return 

	get_input()
	move_and_slide()
	update_animation()

	# checkin for punch input
	if Input.is_action_just_pressed("shoot") or Input.is_action_just_pressed("ui_accept"):
		play_punch_animation()

func get_input():
	var input_x = Input.get_action_strength("r") - Input.get_action_strength("l")
	var input_y = Input.get_action_strength("d") - Input.get_action_strength("u")

	# movement + animation
	if input_x != 0:
		input_y = 0
		last_direction = 1 if input_x > 0 else 3  # Right (1) or Left (3)
	elif input_y != 0:
		last_direction = 2 if input_y < 0 else 4  # Up (2) or Down (4)

	velocity = Vector2(input_x, input_y) * speed

func update_animation():
	if velocity.length() > 0:
		animated_sprite.play("Walk" + str(last_direction))
	else:
		animated_sprite.play("Idle" + str(last_direction))
		

func play_punch_animation():
	if is_punching:
		return  # prevent spammin

	is_punching = true
	velocity = Vector2.ZERO  # stop movement during punch
	animated_sprite.play("Shoot" + str(last_direction))
	
	await animated_sprite.animation_finished  # Wait
	is_punching = false  # allow movement again
	
func player_sell_method():
	pass


func _on_catch_body_entered(body):
	if body.has_method("player_sell_method"):
		print("Thief caught!")
