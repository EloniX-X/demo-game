extends CharacterBody3D

var speed = 4
var gravity = -9.8
var jump_speed = 6.0
var mouse_sensitivity = 0.002
var paused = false

@onready var camera = $Camera3D
@onready var bullet = preload("res://bullet.tscn")
@export var bullet_speed = 20
@onready var bspawn = $Camera3D/bulletspawn

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func get_input_direction():
	var input_dir = Vector3.ZERO
	input_dir.x = -Input.get_action_strength("strafe_left") + Input.get_action_strength("strafe_right")
	input_dir.z = -Input.get_action_strength("move_forward") + Input.get_action_strength("move_back")
	input_dir = input_dir.normalized()
	return input_dir

func _physics_process(delta):
	var input_dir = get_input_direction()
	var rotation_dir = Vector3(input_dir.x, 0, input_dir.z)
	rotation_dir = rotation_dir.rotated(Vector3.UP, rotation.y)

	var horizontal_velocity = rotation_dir * speed
	horizontal_velocity.y = velocity.y

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		horizontal_velocity.y = jump_speed
	else:
		horizontal_velocity.y += gravity * delta

	if is_on_floor() and Input.is_action_just_pressed("crouch"):
		print("hey")
		
	if Input.is_action_just_pressed("exit_button"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		print("paused")
		

	if Input.is_action_just_pressed("click"):
		print("hi")
		shoot()
		
		
		#if here
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			print("unpaused")



		
	velocity = horizontal_velocity
	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		

func shoot():
	print("shooting")
	var projectile = bullet.instantiate()
	projectile.position = bspawn.global_position
	projectile.transform.basis = bspawn.global_transform.basis
	get_parent().add_child(projectile)
	projectile.velocity = -projectile.transform.basis.z * 30
