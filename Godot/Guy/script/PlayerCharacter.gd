extends Node2D

export var horizontal_speed = 200
export var vertical_speed = 150

export var camera_top_left_limit = Vector2(-1000, -1000)
export var camera_bottom_right_limit = Vector2(1000, 1000)

export (NodePath) var scene_end_path

onready var area = get_node("Area2D")
onready var kinematic_body = get_node("KinematicBody2D")
onready var animation_player = kinematic_body.get_node("AnimationPlayer")
onready var camera = kinematic_body.get_node("Camera2D")
onready var sample_player = get_node("SamplePlayer")
onready var scene_end = get_node(scene_end_path)

var health = 2

var current_state = "standing"
var last_state = "standing"
var last_direction = "right"
var horizontal_input = 0
var vertical_input = 0

var input_ready_states = ["standing", "right", "left"]
var speed_scale = 1

func _ready():
	set_process(true)
	
	camera.set_limit(MARGIN_TOP, camera_top_left_limit.y)
	camera.set_limit(MARGIN_LEFT, camera_top_left_limit.x)
	camera.set_limit(MARGIN_BOTTOM, camera_bottom_right_limit.y)
	camera.set_limit(MARGIN_RIGHT, camera_bottom_right_limit.x)
	
	speed_scale = Globals.get("SpeedScale")

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
	elif (current_state == "hit"):
		animation_player.play("hit")


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
	
	kinematic_body.move(Vector2(horizontal_speed * speed_scale * delta * horizontal_input, vertical_speed * speed_scale * delta * vertical_input))
	area.set_pos(kinematic_body.get_pos())
	
	set_z(kinematic_body.get_global_pos().y)

func stop_chopping():
	if (current_state == "chopping_left" || current_state == "chopping_right"):
		current_state = "standing"

func stop_hit():
	health -= 1
	
	if (health == 0):
		scene_end.game_over()
	
	if (current_state == "hit"):
		current_state = "standing"

func play_step_sound():
	sample_player.play("Walk")

func _on_hit():
	current_state = "hit"