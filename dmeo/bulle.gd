extends Area3D

signal exploded

var muzzle_velocity := 25
var g := Vector3.DOWN * 20

var velocity := Vector3.ZERO

func _ready():
	# Optional: Set up the Area if needed
	pass

func _physics_process(delta: float) -> void:
	velocity += g * delta
	look_at(global_transform.origin + velocity.normalized(), Vector3.UP)
	global_transform.origin += velocity * delta

func _on_Shell_body_entered(body: Node) -> void:
	emit_signal("exploded", global_transform.origin)
	queue_free()
