class_name MainCharacter
extends CharacterBody2D

@export var player_speed: float = 700.0
@export var spawnedObject: PackedScene
@onready var jumpParticle: CPUParticles2D = $CPUParticles2D
@onready var stepUpRight: RayCast2D = $StepUpRight
@onready var noStepUpRight: RayCast2D = $NoStepUpRight
@onready var noUpRight: RayCast2D = $NoUpRight
@onready var stepUpLeft: RayCast2D = $StepUpLeft
@onready var noStepUpLeft: RayCast2D = $NoStepUpLeft
@onready var noUpLeft: RayCast2D = $NoUpLeft
@onready var tileCollider: ShapeCast2D = $TileCollider
@onready var adjTileCollider: ShapeCast2D = $TileCollider/AdjacentTileCollider
@onready var characterInventory: Inventory = $CanvasLayer/Inventory
@onready var hotbar: HBoxContainer = $CanvasLayer/Hotbar
var hotbarSelected = 0
var hotbarThang

static var mousePosition: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	var hotbarThingses = 0
	for slot in hotbar.get_children():
		hotbar.remove_child(slot)
	for thingamabop in characterInventory.invGrid.get_children():
		if thingamabop is InvSlot && hotbarThingses < 10:
			hotbar.add_child(thingamabop.duplicate())
			hotbarThingses += 1
		if hotbarThingses > 10:
			for slot in hotbar.get_children():
				if slot is InvSlot:
					slot.visible = true
	pass
func _input(event):
	if event is InputEventMouseMotion:
		mousePosition = event.position
		tileCollider.position.x = get_local_mouse_position().x
		tileCollider.position.y = get_local_mouse_position().y
		tileCollider.global_position = round((tileCollider.global_position/20)) * 20
		adjTileCollider.position.x = get_local_mouse_position().x
		adjTileCollider.position.y = get_local_mouse_position().y
		adjTileCollider.global_position = round((tileCollider.global_position/20)) * 20
	
	
func _physics_process(delta):
	tileCollider.global_position = round((tileCollider.global_position/20)) * 20
	adjTileCollider.global_position = round((tileCollider.global_position/20)) * 20
	
	#for body in playerCollisionLeft.get_overlapping_bodies():
		#if body is Tile:
			#body.apply_impulse((velocity * 0.07).limit_length(10.0))
	
	if !is_on_floor():
		velocity.y += 1000 * delta
		var nv = velocity.x
		nv *= 3 * delta
		velocity.x -= nv
		if velocity.y < 0 and !Input.is_action_pressed("up"):
			velocity.y = velocity.y * 0.9
		if Input.is_action_pressed("down"):
			velocity.y += 100
			velocity.x * 0.4
		jumpParticle.emitting = false
	if is_on_floor():
		var nv = velocity.x
		nv *= 3 * delta
		velocity.x -= nv
		if Input.is_action_pressed("up"):
			velocity.y += -500 - velocity.y
			jumpParticle.one_shot = true
			jumpParticle.emitting = true
	move_and_slide()
	
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#we're going to want this code to actually call a function/lambda inside of the item code
	if Input.is_action_just_pressed("place") and !tileCollider.is_colliding() and adjTileCollider.is_colliding() and hotbarThang == "tile":
		var o = spawnedObject.instantiate()
		var actualMousePosition = get_local_mouse_position()
		o.frozen = true
		o.position = actualMousePosition + position
		o.snap_grid()
		get_parent().add_child(o)
		#if o.get_contact_count() != 0:
			#queue_free()
	#this one is for cheating
	if Input.is_action_just_pressed("debugWarp"):
		position.x = get_global_mouse_position().x
		position.y = get_global_mouse_position().y
		velocity = Vector2(0, 0)
		
	#inventory code bb
	if Input.is_action_just_pressed("inventory"):
		var hotbarThingses = 0
		for slot in hotbar.get_children():
			hotbar.remove_child(slot)
		for thingamabop in characterInventory.invGrid.get_children():
			if thingamabop is InvSlot && hotbarThingses < 10:
				hotbar.add_child(thingamabop.duplicate())
				hotbarThingses += 1
			if hotbarThingses > 9:
				for slot in hotbar.get_children():
					if slot is InvSlot:
						slot.visible = true
	
	if Input.is_action_pressed("right"):
		velocity.x += player_speed * delta
		if stepUpRight.is_colliding() && !noStepUpRight.is_colliding() && !noUpRight.is_colliding():
			velocity.y -= 2000 * delta
			#velocity.x -= 30
		if noStepUpRight.is_colliding():
			if velocity.y < -1:
				velocity.y += 800 * delta
			#print("ssssssaaaaaaaaaaaaaaaaaaaaaaaaa", velocity)
		#if !stepUpRight.get_overlapping_bodies().is_empty():
			#print("somit in go up")
		#if noStepUpRight.get_overlapping_bodies().is_empty():
			#print("nothing in no going up")
			
		#print(noStepUpRight.get_overlapping_bodies())
	if Input.is_action_pressed("left"):
		velocity.x -= player_speed * delta
		if stepUpLeft.is_colliding() && !noStepUpLeft.is_colliding() && !noUpLeft.is_colliding():
			velocity.y -= 2000 * delta
			#velocity.x -= 30
		if noStepUpLeft.is_colliding():
			if velocity.y < -1:
				velocity.y += 800 * delta
	
	#HERE COMES THE HOTBAR STUUUUUF
	if Input.is_action_pressed("hotbar1"):
		hotbarSelected = 0
		for slot in hotbar.get_children():
			if slot is InvSlot:
				if slot.hotbarSlotNum == 0:
					hotbarThang = slot.slotContent.itemType
	if Input.is_action_pressed("hotbar2"):
		hotbarSelected = 1
	if Input.is_action_pressed("hotbar3"):
		hotbarSelected = 2
	if Input.is_action_pressed("hotbar4"):
		hotbarSelected = 3
	if Input.is_action_pressed("hotbar5"):
		hotbarSelected = 4
	if Input.is_action_pressed("hotbar6"):
		hotbarSelected = 5
	if Input.is_action_pressed("hotbar7"):
		hotbarSelected = 6
	if Input.is_action_pressed("hotbar8"):
		hotbarSelected = 7
	if Input.is_action_pressed("hotbar9"):
		hotbarSelected = 8
	if Input.is_action_pressed("hotbar10"):
		hotbarSelected = 9
	if Input.is_action_pressed("hotbar11"):
		hotbarSelected = 10
	
	
	pass

