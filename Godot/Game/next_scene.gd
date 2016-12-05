extends Node

export (String, FILE) var next_scene
var active = false

onready var animation_player = get_node("AnimationPlayer")

func _input(event):
	if (!active):
		if (event.type == InputEvent.KEY):
			animation_player.play("fade_out")
			active = true
			yield(animation_player, "finished")
			
			get_node("/root/globals").goto_scene(next_scene)

func _ready():
	set_process_input(true)