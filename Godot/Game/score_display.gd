extends Label

func _ready():
	set_process(true)

func _process(delta):
	set_text("Trees chopped: " + String(Globals.get("Points")))
