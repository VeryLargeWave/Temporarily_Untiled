extends Node2D

@export var caveType: int = 0
@export var cavesToMake: int
@onready var cave:= $Caves
@onready var cavesMade: bool = false
@export var stay: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	cavesToMake = randi_range(3, 6)
	if randf_range(0, 100) > 50:
		var shapeA = preload("res://cave_a.tscn").instantiate()
		cave.add_child(shapeA)
	else:
		var shapeB = preload("res://cave_b.tscn").instantiate()
		cave.add_child(shapeB)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in cave.get_overlapping_bodies():
		if body is Tile:
			body.queue_free()
	if cavesMade == false and !stay:
		for cavesToMake in 100:
			position.x += randi_range(-30, 30)
			position.y += randi_range(-30, 30)
			if position.y < 35:
				position.y = 35


func _on_timer_timeout():
	queue_free()
