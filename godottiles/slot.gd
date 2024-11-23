class_name InvSlot
extends Control
@onready var label = $Panel/TextureButton/Label
@onready var numLabel = $Panel/SlotNum
@onready var texture:= $ContentTexture
var slotContent: Item = null
var hotbarSlotNum = -1
@onready var button = $Panel/TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if slotContent != null && slotContent.itemName != null:
		if slotContent.texture == null:
			label.text = slotContent.itemName
			texture.texture = null
		if slotContent.texture != null:
			texture.texture = slotContent.texture
			label.text = ""
		button.tooltip_text = "%s \n %s \n %s \n %s" % [slotContent.itemName, slotContent.itemDesc, slotContent.itemTier, slotContent.stackCount]
		texture.tooltip_text = "%s \n %s \n %s \n %s" % [slotContent.itemName, slotContent.itemDesc, slotContent.itemTier, slotContent.stackCount]
	

func _on_texture_button_pressed():
	if not get_parent() is BoxContainer:
		if Inventory.itemSelected != null:
			if true:
				if slotContent != null && slotContent.itemName != "":
					Inventory.itemSelectStorage = slotContent
					if Inventory.itemSelected.texture == null:
						label.text = Inventory.itemSelected.itemName
					if Inventory.itemSelected.texture != null:
						texture.texture = Inventory.itemSelected.texture
				slotContent = Inventory.itemSelected
				button.tooltip_text = "%s \n %s \n %s \n %s" % [slotContent.itemName, slotContent.itemDesc, slotContent.itemTier, slotContent.stackCount]
				texture.tooltip_text = "%s \n %s \n %s \n %s" % [slotContent.itemName, slotContent.itemDesc, slotContent.itemTier, slotContent.stackCount]
				if Inventory.itemSelectStorage == null:
					Inventory.itemSelected = null
				else: if Inventory.itemSelectStorage != null:
					Inventory.itemSelected = Inventory.itemSelectStorage
				Inventory.itemSelectStorage = null
		else: if slotContent != null && slotContent.itemName != "":
			if slotContent != null && slotContent.texture == null:
				label.text = slotContent.itemName
			if slotContent.texture != null:
				texture.texture = slotContent.texture
			if slotContent == Inventory.itemSelected:
				slotContent.stackCount += Inventory.itemSelected.stackCount
				Inventory.itemSelected = null
			else: if slotContent != Inventory.itemSelected:
				Inventory.itemSelected = slotContent
				slotContent = Inventory.itemSelected
				if slotContent == Inventory.itemSelected:
					slotContent = null
				label.text = ""
				button.tooltip_text = ""
				texture.tooltip_text = ""
				texture.texture = null
	if get_parent() is BoxContainer:
		pass
	
