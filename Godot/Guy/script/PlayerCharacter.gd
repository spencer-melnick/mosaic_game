extends Node2D

export var horizontal_speed = 200
export var vertical_speed = 150

export var camera_top_left_limit = Vector2(-1000, -1000)
export var camera_bottom_right_limit = Vector2(1000, 1000)

onready var area = get_node("Area2D")
onready var kinematic_body = get_node("KinematicBody2D")
onready var animation_player = kinematic_body.get_node("AnimationPlayer")
onready var camera = kinematic_body.get_node("Camera2D")
onready var sample_player = get_node("SamplePlayer")

var current_state = "standing"
var last_state = "standing"
var last_direction = "right"
var horizontal_input = 0
var vertical_input = 0

var input_ready_states = ["standing", "right", "left"]

func _ready():
	set_process(true)
	
	camera.set_limit(MARGIN_TOP, camera_top_left_limit.y)
	camera.set_limit(MARGIN_LEFT, camera_top_left_limit.x)
	camera.set_limit(MARGIN_BOTTOM, camera_bottom_right_limit.y)
	camera.set_limit(MARGIN_RIGHT, camera_bottom_right_limit.x)

func start_animation():
	if (current_state == "standing"):
		animation_player.play("standing")
	elif (current_state == "left"):
		animation_player.play("walk_left")
	elif (current_state == "right"):
		animation_player.play("walk_right")
	elif (current_state == "chopping_left"):
		animation_player.play("chop_left")
	elif (current_state == "chopping_right"):
		animation_player.play("chop_right")


func process_input():
	horizontal_input = 0
	vertical_input = 0
	
	if (input_ready_states.find(current_state) != -1):
		
		if (Input.is_action_pressed("move_right")):
			horizontal_input += 1
		if (Input.is_action_pressed("move_left")):
			horizontal_input -= 1
		
		if (Input.is_action_pressed("move_up")):
			vertical_input -= 1
		if (Input.is_action_pressed("move_down")):
			vertical_input += 1
		
		if (horizontal_input == 1):
			current_state = "right"
			last_direction = "right"
		elif (horizontal_input == -1):
			current_state = "left"
			last_direction = "left"
		elif (horizontal_input == 0):
			current_state = "standing"
		
		if (current_state == "standing" && vertical_input != 0):
			current_state = last_direction
		
		if (Input.is_action_pressed("action")):
			current_state = "chopping_" + last_direction
	
	if (current_state != last_state):
		start_animation()
	
	last_state = current_state

func _process(delta):
	process_input()
	
	kinematic_body.move(Vector2(horizontal_speed * delta * horizontal_input, vertical_speed * delta * vertical_input))
	area.set_pos(kinematic_body.get_pos())
	
	set_z(kinematic_body.get_global_pos().y)

func stop_chopping():
	if (current_state == "chopping_left" || current_state == "chopping_right"):
		current_state = "standing"

func play_step_sound():
	sample_player.play("Walk")