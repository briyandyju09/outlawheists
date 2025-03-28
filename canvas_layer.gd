extends CanvasLayer


func _ready():
	update_display()

func _process(delta):
	update_display()

func update_display():
	$Coin.text = str(Global.coins)
	$Bag.text = str(Global.noofbag)
	$Antique.text = str(Global.noofant)
	$Label3.text = str(Global.noofpostage)
