extends CharacterBody2D

@onready var vision: Area2D = $Vision
@onready var visionChecker: RayCast2D = $VisionCheck
@onready var jumpCheck: RayCast2D = $JumpCheck
@onready var jumpCheck2: RayCast2D = $JumpCheck2
var chaseDuration = 0
var lastSeen = 0

const SPEED = 6.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if jumpCheck.is_colliding() or jumpCheck2.is_colliding():
		if is_on_floor():
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# basic moevement, modifies velocity based on vision
	for body in vision.get_overlapping_bodies():
		if body is MainCharacter:
			var direction
			visionChecker.target_position = Vector2(body.position.x + 20, body.position.y + 30) - position
			if visionChecker.is_colliding():
				continue
			var directionDetermine = position.x - body.position.x - 20
			if directionDetermine < 0:
				direction = 1
			if directionDetermine > 0:
				direction = -1
			chaseDuration = 3
			lastSeen = direction
	
	if chaseDuration > 0:
			velocity.x += lastSeen * SPEED
			chaseDuration -= delta
	var nv = velocity.x
	nv *= 3 * delta
	velocity.x -= nv

	move_and_slide()
