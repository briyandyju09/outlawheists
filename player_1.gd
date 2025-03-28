extends CharacterBody2D

@export var speed = 250
@onready var animated_sprite = $AnimatedSprite2D
@onready var camera = $Camera2D

var last_direction = 1  
var is_punching = false

func _ready():
	await get_tree().process_frame
	if is_multiplayer_authority():
		camera.make_current()
	else:
		camera.enabled = false

func _physics_process(delta):
	if !is_multiplayer_authority():
		return
	if is_punching:
		return 

	get_input()
	move_and_slide()
	update_animation()

	# 
	if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("ui_accept"):
		play_punch_animation()

func get_input():
	var input_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var input_y = Input.get_action_strength("down") - Input.get_action_strength("up")

	
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
		return 

	is_punching = true
	velocity = Vector2.ZERO
	animated_sprite.play("Punch" + str(last_direction))
	
	await animated_sprite.animation_finished 
	is_punching = false
	
func player_sell_method():
	pass
