extends Node2D

@export var spawnedObject: PackedScene
@export var texture: Texture2D
@export var texture2: Texture2D
@export var baseWorldMade: bool = false
var hasSpawned: bool = false
var rng = RandomNumberGenerator.new()
var noise = FastNoiseLite.new()
# Called when the node enters the scene tree for the first time.

## reminder: caves, game gui and interface
## special tile pockets
## grass using array cast system

func _ready():

	position = round((position/20)) * 20
	rotation = 0
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = int(Time.get_unix_time_from_system())
	var index_count = 100
	for x in range(index_count):
		var xi = x * 1
		var noi: float = clamp(noise.get_noise_1d(xi) * 55,-1.0,1.0)
		#print(noi)
	#x position of thing spawning
func x_coord_to_index(x: int) -> float:
	position.x = round((position.x/20)) * 20
	return position.x
# whether it'll spawn or not
func should_spawn_tile(noise_value: float, tile_y: int) -> bool:
#need to conpare noise value to pos to determine spawning or not
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if hasSpawned == false:
		for n in range(400):
			for n1 in range (19):
				
				var noi = clamp(noise.get_noise_1d(n * 2) * 20,-7.0,7.0) 
				#print(noi)
				var tileYLocal = n1 * 20
				var tileY: float = position.y + tileYLocal
				#if noi < -1.5:
					#print("tiley:",tileYLocal)
				#if noi > n1:
					#continue
				if int(noi) < 0 && n1 == 1:
					for n2 in range(int(abs(noi))):
						#print("me working")
						var hillTileY = n2 * 20 - tileY
						var o = spawnedObject.instantiate()
						
						
						o.frozen = true
						o.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
						o.texture = texture
						o.tileStrength = 0.5
						o.position = Vector2(position.x + (n * 20), hillTileY)
						o.snap_grid
						if randf_range(0, 100) < 0.5:
							var cavey = preload("res://cave_maker.tscn").instantiate()
							cavey.position = o.position
							get_parent().add_child(cavey)
						get_parent().add_child(o)
						
				var o = spawnedObject.instantiate()
				
				o.frozen = true
				#o.can_sleep = true
				o.texture = texture
				o.tileStrength = 0.5
				o.tileType = "dirt"
				
				o.position = Vector2(position.x + (n * 20), tileY)
				o.snap_grid
				if n1 > 2 and rng.randf_range(-13,n1) > 2:
					o.tileType = "stone"
					o.texture = texture2
					o.tileStrength = 1.2
				var fraction = (1.0 - (n1 / 13.0))
				o.oldModulate = Color(fraction, fraction, fraction, 1)
				get_parent().add_child(o)
				hasSpawned = true
				baseWorldMade = true
	pass
