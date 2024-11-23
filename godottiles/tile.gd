class_name Tile
extends RigidBody2D

@export var frozen = false
@export var breakable := breakType.interactBreak
@export var tileStrength = 1.0
enum breakType {interactBreak, velocityBreak, projectileBreak}
var tileType = ""
var mouseOver = false
var texture: Texture2D
var oldModulate
@onready var tileSprite := $tileSprite
@onready var breakParticleEmitter: CPUParticles2D = $Emitter
@onready var particleTimer:= $ParticleTimer
@onready var growTimer:= $GrowTimer
@onready var grassTimer:= $GrassTimer
@onready var kineTimer:= $KineFreezeTimer
@onready var grassChecker:= $GrassChecker

var timeHeld = 0
var itemDropped = false


func _mouse_enter():
	mouseOver = true
func _mouse_exit():
	mouseOver = false
# Called when the node enters the scene tree for the first time.

func timerEnd():
	breakParticleEmitter.emitting = false
	pass

func _ready():
	self.freeze = frozen
	grassTimer.wait_time = randf_range(3.0, 10.0)
	#tileSprite.texture = texture
	#self.mouse_entered.connect(mouseEntered)
	particleTimer.timeout.connect(timerEnd)
	if tileStrength == null:
		tileStrength = 1.0
	if oldModulate == null:
		oldModulate = tileSprite.modulate
		
	tileSprite.modulate = oldModulate
	#tileSprite.set_rotation_degrees(randi_range(0,3)*90)
	
	

	
	pass # Replace with function body.
	
func snap_grid():
	position = round((position/20)) * 20
	rotation = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#var s = (growTimer.time_left - growTimer.wait_time) / growTimer.wait_time
	#
	#scale = Vector2(s,s)
	
	if texture != null:
		tileSprite.texture = texture
	
	
	if mouseOver && not itemDropped:
		tileSprite.modulate = Color(0.3, 1, 0.3)
		if Input.is_mouse_button_pressed(1):
			particleTimer.start(0.2)
			breakParticleEmitter.emitting = true
			breakParticleEmitter.texture = texture
			if timeHeld < 0.6 * tileStrength:
				breakParticleEmitter.lifetime = 0.7
			timeHeld += delta
			if timeHeld > 0.6 * tileStrength:
				breakParticleEmitter.lifetime = 0.1
			if timeHeld > 1 * tileStrength:
				var itemDropped = load("res://item.tscn")
				var item: Item = itemDropped.instantiate()
				item.itemName = tileType
				if tileType == "":
					item.itemName = "dirt"
				item.itemDesc = "this is the temp tile desc"
				item.itemTier = "common"
				item.itemType = "tile"
				item.global_position = position
				if tileSprite.texture != null:
					item.textureShift(texture)
				get_parent().add_child(item)
				itemDropped = true
				queue_free()
		else:
			if timeHeld > 0:
				timeHeld = 0
	else:
		tileSprite.modulate = oldModulate
	modulate.a = 1
	pass


	#kineTimer.monitoring = true
	#await get_tree().create_timer(0.08).timeout

	#FREEZE_MODE_STATIC
#func _on_grass_timer_timeout():
	#grassChecker.monitoring = true
	#await get_tree().create_timer(0.08).timeout
	#if !grassChecker.get_overlapping_bodies().size() <= 0:
		#if texture != load("res://tileRock.png"):
			#print("garss")
			#texture = load("res://tileDirtGrass.png")
		#else:
			#if texture != load("res://tileRock.png"):
				#texture = load("res://tileDirt.png")
		##queue_free()
	#grassChecker.monitoring = false
	#grassTimer.wait_time = randf_range(8.0, 20.0)
#
#
#func _on_visible_on_screen_notifier_2d_screen_entered():
	#grassTimer.paused = false
	#grassChecker.enabled = true
	#await get_tree().create_timer(0.08).timeout
	#if !grassChecker.is_colliding():
		#if texture != load("res://tileRock.png"):
			#texture = load("res://tileDirtGrass.png")
	#else:
		#if texture != load("res://tileRock.png"):
			#texture = load("res://tileDirt.png")
	#grassChecker.enabled = false
	#grassTimer.wait_time = randf_range(30.0, 100.0)


func _on_visible_on_screen_notifier_2d_screen_exited():
	grassTimer.paused = true


func _on_kine_freeze_timer_timeout():
	freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
