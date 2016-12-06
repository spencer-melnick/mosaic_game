extends Control

export (String, FILE) var next_scene

var active = false

onready var area = get_node("Area2D")
onready var gui = get_node("CanvasLayer").get_node("Control")
onready var animation_player = get_node("AnimationPlayer")

onready var yes_select = gui.get_node("YesSelect")
onready var no_select = gui.get_node("NoSelect")

onready var yes_button = gui.get_node("Yes")
onready var no_button = gui.get_node("No")

func next_level():
	gui.hide()
	
	Globals.set("SpeedScale", Globals.get("Points") / 3.0)
	Globals.set("Points", 0)
	
	animation_player.play("fade_out")
	yield(animation_player, "finished")
	
	get_tree().set_pause(false)
	get_node("/root/globals").goto_scene(next_scene)

func close_gui():
	active = false
	get_tree().set_pause(false)
	gui.hide()

func _ready():
	area.connect("body_enter", self, "_area_enter")
	
	yes_button.connect("mouse_enter", self, "_mouse_over", [1])
	no_button.connect("mouse_enter", self, "_mouse_over", [0])
	
	no_button.connect("pressed", self, "close_gui")
	yes_button.connect("pressed", self, "next_level")

func _mouse_over(state):
	if (state == 0):
		yes_select.hide()
		no_select.show()
	
	if (state == 1):
		yes_select.show()
		no_select.hide()

func _area_enter(object):
	if (!active):
		active = true
		
		gui.show()
		get_tree().set_pause(true)