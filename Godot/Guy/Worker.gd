extends Node2D

export (NodePath) var tree_target_path

export (NodePath) var invasion_target_path
export (NodePath) var invasion_tree_1_path

export (NodePath) var invasion_target_2_path
export (NodePath) var invasion_tree_2_path

export (NodePath) var invasion_target_3_path
export (NodePath) var invasion_tree_3_path

export (String, FILE) var hostile_worker_path

onready var tree_target = get_node(tree_target_path)

onready var invasion_target = get_node(invasion_target_path)
onready var invasion_tree_1 = get_node(invasion_tree_1_path)

onready var invasion_target_2 = get_node(invasion_target_2_path)
onready var invasion_tree_2 = get_node(invasion_tree_2_path)

onready var invasion_target_3 = get_node(invasion_target_3_path)
onready var invasion_tree_3 = get_node(invasion_tree_3_path)

var damage = 0

onready var animation_player = get_node("AnimationPlayer")
onready var sample_player = get_node("SamplePlayer2D")
onready var area = get_node("Area2D")

func _ready():
	#set_process(true)
	if (Globals.get("InvasionTimer") == 0):
		Globals.set("InvasionCounter", Globals.get("InvasionCounter") + 1)
		
		if (Globals.get("InvasionCounter") <= 2):
			set_global_pos(invasion_target.get_global_pos())
			set_scale(Vector2(-1, 1))
			tree_target = invasion_tree_1
		elif (Globals.get("InvasionCounter") <= 3):
			set_global_pos(invasion_target_2.get_global_pos())
			set_scale(Vector2(-1, 1))
			tree_target = invasion_tree_2
			invasion_tree_1.set_hittable(false)
		else:
			set_global_pos(invasion_target_3.get_global_pos())
			set_scale(Vector2(-1, 1))
			invasion_tree_1.set_hittable(false)
			invasion_tree_2.set_hittable(false)
			tree_target = invasion_tree_3
	
	if (Globals.get("RetributionTimer") < 0):
		area.connect("area_enter", self, "_on_hit")
		animation_player.play("chopping")
		tree_target.set_hittable(false)
		
		set_z(get_global_pos().y)
	else:
		tree_target.set_hittable(true)
		get_node("AnimatedSprite").queue_free()
		get_node("StaticBody2D").queue_free()
		get_node("Area2D").queue_free()
		
		if (Globals.get("RetributionTimer") == 0):
			var s = ResourceLoader.load(hostile_worker_path).instance()
			s.set_global_pos(get_global_pos())
			add_child(s)
			print(get_node("../").get_name())
			print("Retribution!")
			print("Hostile worker spawned at " + String(s.get_global_pos()))

func _do_hit():
	sample_player.play("Chop")
	tree_target.faux_hit()

func _on_hit(object):
	if (object.is_in_group("PlayerChop")):
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
			
			if (Globals.get("RetributionTimer") == -1):
				Globals.set("RetributionTimer", 2)
				Globals.set("InvasionTimer", -1)
			
			self.queue_free()

func _process(delta):
	#do something
	pass
