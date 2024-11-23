class_name FreezeTimer
extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timeout():
	var parent = get_parent()
	if parent is Tile:
		parent.freeze = true
		parent.snap_grid()
	queue_free()
