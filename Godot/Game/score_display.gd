extends Label

func _ready():
	set_process(true)

func _process(delta):
	set_text("x " + String(Globals.get("Points")))
