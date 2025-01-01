extends CharacterBody3D
class_name playerclass



#The other thingz
var health := 100
signal injurebob
signal flashlightpickup

#Movement variables
var lerpspeed = 5.0
var speed
var WALK_SPEED = 3.1
var SPRINT_SPEED = 5.8
const JUMP_VELOCITY = 3.9
var SENSITIVITY = 0.003
var canjump = true
var cansprint = true
#Bob should be modified when hurt
#Bob variables
var BOB_FREQ = 2.4
var BOB_AMP = 0.04
var BOB_AMP_Y = 0.007
var BOB_FREQ_Y = 1.2
var t_bob = 0.0
var v_bob = 0.0
var V_BOB_FREQ = 2.5
var V_BOB_AMP = 0.015
#Item Variables
var HASFLASHLIGHT = 0
var HASCAMERA = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var viewmodel = $Pivot/Head/Camera3D/Viewmodel
@onready var pivot = $Pivot
@onready var camera = $Pivot/Head/Camera3D
@onready var head = $Pivot/Head
@onready var flashlight = $Pivot/Head/Camera3D/Viewmodel/FlashlightRig/SpotLight3D
@onready var collisionbox = $CollisionShape3D

#Mouse
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	injurebob.connect(injurebobfunction)
	flashlightpickup.connect(flashlightpickupfunction)

func _physics_process(delta):
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		print("I collided with ", collision.get_collider().name)
	
	if HASFLASHLIGHT == 0:
		viewmodel.visible = false
		flashlight.visible = false
	else:
		viewmodel.visible = true
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Handle crouching.
	if Input.is_action_pressed("crouch"):
		collisionbox.scale = scale.lerp(Vector3(1, 0.6, 1), 1)
		#collisionbox.position = position.lerp(Vector3(0, 0, 0), 0.4)
		WALK_SPEED = 1.5
		cansprint = false
		canjump = false
	else:
		collisionbox.scale = scale.lerp(Vector3(1, 1, 1,), 1)
		#collisionbox.position = position.lerp(Vector3(0, 0, 0), 0.4)
		WALK_SPEED = 3.1
		canjump = true
		cansprint = true
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and canjump == true:
		velocity.y = JUMP_VELOCITY
	# Handle sprint.
	if Input.is_action_pressed("sprint") and cansprint == true:
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	#Flashlight
	if Input.is_action_just_pressed("toggleflashlight") and HASFLASHLIGHT == 1:
		flashlight.visible = not flashlight.visible
	if Input.is_action_just_pressed("hurt"):
		health -= 10
		emit_signal("injurebob")
	if Input.is_action_just_pressed("heal"):
		health += 10
		emit_signal("injurebob")
	
	
	#Movement and Inertia
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = 0.0
			velocity.z = 0.0
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	#Head Bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	pivot.transform.origin = _headbob(t_bob)
	
	v_bob += delta * velocity.length() * float(is_on_floor())
	viewmodel.transform.origin = _viewmodelbob(v_bob)
	move_and_slide()
	
func _viewmodelbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * V_BOB_FREQ) * V_BOB_AMP
	pos.x = sin (time * V_BOB_FREQ/2) * V_BOB_AMP
	return pos

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = sin(time * BOB_FREQ/2) * BOB_AMP
	head.rotation.z = sin(t_bob * BOB_FREQ_Y) * BOB_AMP_Y
	return pos

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		pivot.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-85), deg_to_rad(85))

func injurebobfunction():
	if health <= 30:
		BOB_AMP_Y = 0.05
		WALK_SPEED = 2.8
		SPRINT_SPEED = 5.2
	else:
		BOB_AMP_Y = 0.007
		WALK_SPEED = 3.1
		SPRINT_SPEED = 5.8

func flashlightpickupfunction():
	HASFLASHLIGHT = 1

#func tradiusplayer(body : Area3D):
