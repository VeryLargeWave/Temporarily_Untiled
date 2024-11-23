extends Node2D
class_name Item
var pickedUp = false
@export var pickUpable = false
@export var itemType = ""
@export var itemName = ""
@export var itemDesc = ""
@export var itemTier = ""
@export var stackCount = 0
var nearbyPlayer: MainCharacter = null
@onready var sprite: Sprite2D = $Sprite2D
var texture = null
# Called when the node enters the scene tree for the first time.
func _ready():
	if itemType == "tile":
		var place = func():
			print("Iunno, it work ig")
		place.call()

func textureShift(tex):
	if tex == null:
		tex = load("res://goober1.png")
	if sprite != null:
		sprite.set_texture(tex)
	else:
		texture = tex
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if texture != null:
		sprite.texture = texture
	if Input.is_action_pressed("pickUpThing"):
		if pickUpable && pickedUp == false:
			nearbyPlayer.characterInventory.itemGet(self)
			pickedUp = true
			visible = false
			pass
	pass


func _on_area_2d_body_entered(body):
	if body is MainCharacter:
		pickUpable = true
		nearbyPlayer = body
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	
	if body is MainCharacter:
		pickUpable = false
		nearbyPlayer = null
	pass # Replace with function body.
