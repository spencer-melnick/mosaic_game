extends Node2D

export (NodePath) var tree_target_path
onready var tree_target = get_node(tree_target_path)

var damage = 0

onready var animation_player = get_node("AnimationPlayer")
onready var sample_player = get_node("SamplePlayer2D")
onready var area = get_node("Area2D")

func _ready():
	#set_process(true)
	area.connect("area_enter", self, "_on_hit")
	animation_player.play("chopping")
	tree_target.set_hittable(false)
	set_z(get_global_pos().y)

func _do_hit():
	sample_player.play("Chop")
	tree_target.faux_hit()

func _on_hit(object):
	damage += 1
	
	if (damage == 1):
		animation_player.play("hit_1")
		sample_player.play("Hurt")
		yield(animation_player, "finished")
		animation_player.play("chopping")
	elif (damage == 2):
		animation_player.play("hit_2")
		sample_player.play("Hurt")
		yield(animation_player, "finished")
		tree_target.set_hittable(true)
		self.queue_free()

func _process(delta):
	#do something
	pass
