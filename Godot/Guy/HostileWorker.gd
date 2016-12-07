extends Node2D

export var horizontal_speed = 100
export var vertical_speed = 75

onready var animation_player = get_node("AnimationPlayer")
onready var players = get_tree().get_nodes_in_group("Player")

onready var attack_proximity_left = get_node("AttackProximityLeft")
onready var attack_proximity_right = get_node("AttackProximityRight")

var state = "walk_left"
var last_state = "none"

var following_states = ["walk_left", "walk_right"]

func _ready():
	print("Hostile worker spawned!")
	set_process(true)
	
	#attack_proximity_left.connect("body_enter", self, "_on_proximity_entered", ["left"])
	#attack_proximity_right.connect("body_enter", self, "_on_proximity_entered", ["right"])

func _process(delta):
	if (following_states.find(state) != -1):
		
		var left_overlaps = attack_proximity_left.get_overlapping_bodies()
		var right_overlaps = attack_proximity_right.get_overlapping_bodies()
		
		var in_proximity = false
		
		for x in left_overlaps:
			if (x.is_in_group("Player")):
				state = "chop_left"
				in_proximity = true
				break
		
		if (!in_proximity):
			for x in right_overlaps:
				if (x.is_in_group("Player")):
					state = "chop_right"
					in_proximity = true
					break
		
		if (!in_proximity):
			var destination = players[0].get_global_pos()
			
			var travel_1 = destination - attack_proximity_left.get_global_pos()
			var travel_2 = destination - attack_proximity_right.get_global_pos()
			
			var travel
			
			if (travel_1.length_squared() > travel_2.length_squared()):
				travel = travel_2
			else:
				travel = travel_1
			
			if (travel.x > (horizontal_speed * delta)):
				travel.x = horizontal_speed * delta
			if (travel.x < -(horizontal_speed * delta)):
				travel.x = -horizontal_speed * delta
				
			if (travel.y > (vertical_speed * delta)):
				travel.y = vertical_speed * delta
			if (travel.y < -(vertical_speed * delta)):
				travel.y = -vertical_speed * delta
			
			set_global_pos(get_global_pos() + travel)
			
			if (travel.x > 0):
				state = "walk_right"
			elif (travel.x < 0):
				state = "walk_left"
	
	if (state != last_state):
		play_animation(state)
	
	set_z(get_global_pos().y)
	last_state = state

func play_animation(name):
	print("enemy now " + name)
	animation_player.play(name)

func _on_proximity_entered(object, direction):
	if (following_states.find(state) != -1):
		if (object.is_in_group("Player")):
			state = "chop_" + direction

func _return_to_following():
	state = "walk_left"

func _player_hit():
	players[0].get_parent()._on_hit()