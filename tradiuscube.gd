extends Node3D

@onready var tradiuslayer1 = $Area3D/tradius_layer1
var volumeplay = 0
var volumezero = -80
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	tradiuslayer1.volume_db = 0

func _on_area_3d_body_exited(body: Node3D) -> void:
	tradiuslayer1.volume_db = -80
