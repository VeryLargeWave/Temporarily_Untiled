extends Node2D
var mountsMade: bool = false
var mountsMakin: int = 0
var blocks: Array[Tile] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mountsMakin < 4:
		var mountWidth = randi_range(4, 15)
		for a in range(mountWidth):
			var xPo = a * 20
			var mountCenterDis = abs(a + (mountWidth/2)) 
			for b in range(mountCenterDis):
				#this one spawns funny floating tiles which become solid after a bit
				var mountBlock = preload("res://tile.tscn").instantiate()
				mountBlock.position = position + Vector2(xPo, -b*20-20)
				mountBlock.texture = preload("res://tileRock.png")
				mountBlock.linear_velocity = Vector2(0, randf_range(-10, -1))
				#the freeze timer freezes em and defaults to 1 second
				var freezeTimer = preload("res://freeze_timer.tscn").instantiate()
				var fillTimer = preload("res://fill_timer.tscn").instantiate()
				mountBlock.add_child(freezeTimer)
				mountBlock.add_child(fillTimer)
				blocks.append(mountBlock)
				get_parent().add_child(mountBlock)
			#this one does that too
			var mountBlock = preload("res://tile.tscn").instantiate()
			mountBlock.position = position + Vector2(xPo, 0)
			#mountBlock.global_position = global_position
			mountBlock.texture = preload("res://tileRock.png")
			mountBlock.linear_velocity = Vector2(randf_range(-10, -1), randf_range(-10, -1))
			#the freeze timer freezes em and defaults to 1 second
			var freezeTimer = preload("res://freeze_timer.tscn").instantiate()
			var fillTimer = preload("res://fill_timer.tscn").instantiate()
			mountBlock.add_child(freezeTimer)
			mountBlock.add_child(fillTimer)
			blocks.append(mountBlock)
			get_parent().add_child(mountBlock)
		mountsMakin += 1
		position += Vector2(randi_range(200, 2000), 0)
	var i = 0
	for block in blocks:
		if block.linear_velocity.length() < 0.8:
			#this is an additional freeze thing, where the timer is more of a failsafe
			block.freeze = true
			block.snap_grid()
			blocks.remove_at(i)
			#this spawns additional tiles to fill the gaps of the other ones
			var extraMountBlock = preload("res://tile.tscn").instantiate()
			extraMountBlock.position = block.position
				#mountBlock.global_position = global_position
			extraMountBlock.texture = preload("res://tileRock.png")
			#the freeze timer freezes em and defaults to 1 second
			var freezeTimer = preload("res://freeze_timer.tscn").instantiate()
			var fillTimer = preload("res://fill_timer.tscn").instantiate()
			extraMountBlock.add_child(freezeTimer)
			extraMountBlock.add_child(fillTimer)
			get_parent().add_child(extraMountBlock)
			#i is just used to help remove blocks from the array
			i -= 1
		i += 1
	var f = true
	for block in blocks:
		if block.freeze == false:
			f = false
	#stops makin the mountain
	if f:
		queue_free()
