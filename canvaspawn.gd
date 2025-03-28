extends CanvasLayer


func _ready():
	update_display()

func _process(delta):
	update_display()

func update_display():
	$pawnl.text = str(Global.coins)
