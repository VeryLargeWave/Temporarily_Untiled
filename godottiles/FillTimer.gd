class_name FillTimer
extends Timer
@onready var floorCheck:= $FloorChecker

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timeout():
	var parent = get_parent()
	if parent is Tile:
		var fillBlock = preload("res://tile.tscn").instantiate()
		fillBlock.texture = preload("res://tileRock.png")
		fillBlock.position = parent.position + Vector2(0, 20)
		parent.get_parent().add_child(fillBlock)
		fillBlock.freeze = true
		fillBlock.snap_grid()
	queue_free()
