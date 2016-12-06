extends Control

export (String, FILE) var next_scene
export (String, FILE) var game_over_scene

var active = false

onready var area = get_node("Area2D")
onready var gui = get_node("CanvasLayer").get_node("Control")
onready var animation_player = get_node("AnimationPlayer")

onready var yes_select = gui.get_node("YesSelect")
onready var no_select = gui.get_node("NoSelect")

onready var yes_button = gui.get_node("Yes")
onready var no_button = gui.get_node("No")

var state = 0

func _input(event):
	if (active):
		if (event.is_action_pressed("move_right") || event.is_action_pressed("move_left")):
			if (state == 0):
				state = 1
			elif (state == 1):
				state = 0
				
			update_buttons()
		
		if (event.is_action_pressed("action")):
			if (state == 1):
				next_level()
			elif (state == 0):
				close_gui()

func next_level():
	gui.hide()
	
	if (Globals.get("Points") == 0):
		next_scene = game_over_scene
	
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
	set_process_input(true)
	
	area.connect("body_enter", self, "_area_enter")
	
	yes_button.connect("mouse_enter", self, "_mouse_over", [1])
	no_button.connect("mouse_enter", self, "_mouse_over", [0])
	
	no_button.connect("pressed", self, "close_gui")
	yes_button.connect("pressed", self, "next_level")

func update_buttons():
	if (state == 0):
		yes_select.hide()
		no_select.show()
	
	if (state == 1):
		yes_select.show()
		no_select.hide()

func _mouse_over(value):
	state = value
	update_buttons()

func _area_enter(object):
	if (!active):
		if (object.is_in_group("Player")):
			active = true
			
			gui.show()
			get_tree().set_pause(true)