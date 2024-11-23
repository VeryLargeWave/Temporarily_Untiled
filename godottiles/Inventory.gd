extends Control
class_name Inventory
@onready var invGrid:= $InventoryBox/GridContainer
@export var slot: PackedScene
static var itemSelected: Item = null
static var itemSelectStorage: Item = null
var debug_item: PackedScene = load("res://debugitem.tscn")
var hotbarSlotVal = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	# now you can't see it instantly
	for a in range(121):
		invGrid.add_child(slot.instantiate())
		
	visible = false
	#invGrid.queue_sort()
	#var s = invGrid.get_child(0)
	#if s is InvSlot:
		#print("jjjjjjjj")
		#var i = DebugItem.new()
		#i.itemName = "poadsipodsfjdspojsp"
		#s.slotContent = i

# Called every frame. 'delta' is the elapsed time since the previous frame.
func itemGet(i: Item):
	invGrid.queue_sort()
	
	for slot in invGrid.get_children():
		var shulbit = 1
		if slot is InvSlot:
			if shulbit <= 11:
				slot.numLabel.text = str(shulbit)
				slot.hotbarSlotNum = hotbarSlotVal
				shulbit += 1
				hotbarSlotVal += 1
				print (slot.numLabel.text)
				print (slot.hotbarSlotNum)
			
			if slot.slotContent != null && i.itemName != null && slot.slotContent.itemName != null:
				if i.itemName == slot.slotContent.itemName:
					if i.itemType == "tile":
						#i.stackCount += 1
						#slot.slotContent = i
						slot.slotContent.stackCount += 1
						return
	for slot in invGrid.get_children():
		if slot is InvSlot:
			if slot.slotContent == null:
				slot.slotContent = i
				slot.slotContent.stackCount = 1
				break
	
func _process(delta):
	
	#invGrid.child
	if Input.is_action_just_pressed("inventory"):
		visible = !visible
	
