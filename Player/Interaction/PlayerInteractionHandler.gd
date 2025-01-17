extends Area3D

@export var ItemTypes : Array[ItemData] = []

var NearbyBodies : Array[InteractableItem]
@onready var player = $".."


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		PickupNearestItem()
		

func flashlightpickupfunc(player : CharacterBody3D):
	player.HASFLASHLIGHT = 1
	print("flashlight got")
func PickupNearestItem():
	var nearestItem : InteractableItem = null
	var nearestItemDistance : float = INF
	for item in NearbyBodies:
		if (item.global_position.distance_to(global_position) < nearestItemDistance):
			nearestItemDistance = item.global_position.distance_to(global_position)
			nearestItem = item

	if (nearestItem != null):
		nearestItem.queue_free()
		NearbyBodies.remove_at(NearbyBodies.find(nearestItem))
		var itemPrefab = nearestItem.scene_file_path
		for i in ItemTypes.size():
			if (ItemTypes[i].ItemModelPrefab != null and ItemTypes[i].ItemModelPrefab.resource_path == itemPrefab):
				print("ItemId:" + str(i) + " Item Name:" + ItemTypes[i].ItemName)
				if ItemTypes[i].ItemName == "Flashlight":
					flashlightpickupfunc(player)
				return
		printerr("Item not found")


func OnObjectEnteredArea(body : Node3D):
	if (body is InteractableItem):
		body.GainFocus()
		NearbyBodies.append(body)

func OnObjectExitedArea(body : Node3D):
	if (body is InteractableItem and NearbyBodies.has(body)):
		body.LoseFocus()
		NearbyBodies.remove_at(NearbyBodies.find(body))
	
