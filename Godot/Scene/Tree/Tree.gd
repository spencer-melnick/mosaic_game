extends Node2D

var hits = 0
onready var animation_player = get_node("StaticBody2D").get_node("AnimationPlayer")
onready var area2d = get_node("Area2D")
onready var sample_player = get_node("SamplePlayer")

func _ready():
	area2d.connect("area_enter", self, "on_hit")
	set_z(get_global_pos().y)
	print(get_z())

func on_hit(object):
	hits += 1
	
	if (hits == 1):
		animation_player.play("first_hit")
		sample_player.play("Chop")
	
	if (hits == 2):
		animation_player.play("second_hit")
		sample_player.play("Chop")
	
	if (hits == 3):
		animation_player.play("final_hit")
		sample_player.play("Destroyed")
		
		yield(animation_player, "finished")
		sample_player.play("Point_Get")
		get_node("StaticBody2D").queue_free()