extends Node3D

var tradiusplay = false
@onready var tradiuslayer2 = $Layer2/tradius_layer2
@onready var tradiuslayer1 = $Area3D/tradius_layer1
@onready var tradiuslayer3 = $Layer3/tradius_layer3
func _ready() -> void:
	await 2
	tradiuslayer1.stop()
	tradiuslayer2.stop()
	tradiuslayer3.stop()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_layer_1_body_entered(body: CharacterBody3D) -> void:
	if tradiusplay == false:
		tradiusplay = true
		tradiuslayer1.play()
		tradiuslayer2.play()
		tradiuslayer2.volume_db = -120
		tradiuslayer3.play()
		tradiuslayer3.volume_db = -120
	var tween = get_tree().create_tween()
	tween.tween_property(tradiuslayer1, "volume_db", 0, 2)
	tween.play()
	await tween.finished

func _on_layer_1_body_exited(_body: CharacterBody3D) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(tradiuslayer1, "volume_db", -120, 2)
	tween.play()
	await tween.finished
	

func _on_layer_2_body_entered(_body: CharacterBody3D) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(tradiuslayer2, "volume_db", 0, 0.8)
	tween.tween_property(tradiuslayer1, "volume_db", -120, 2)
	tween.play()
	await tween.finished

func _on_layer_2_body_exited(_body: CharacterBody3D) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(tradiuslayer1, "volume_db", 0, 2)
	tween.tween_property(tradiuslayer2, "volume_db", -120, 2)
	tween.play()
	await tween.finished

func _on_layer_3_body_entered(_body: CharacterBody3D) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(tradiuslayer3, "volume_db", 0, 0.8)
	tween.tween_property(tradiuslayer2, "volume_db", -120, 2)
	tween.play()
	await tween.finished

func _on_layer_3_body_exited(_body: CharacterBody3D) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(tradiuslayer2, "volume_db", 0, 2)
	tween.tween_property(tradiuslayer3, "volume_db", -120, 2)
	tween.play()
	await tween.finished
