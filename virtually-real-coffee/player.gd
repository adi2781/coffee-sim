extends RigidBody3D

var sensitivity = 0.1  #Adjust speed of mouse panning
var vertical_rotation = 0.1 # Manage vertical rotation limits
var camera  # Reference to the camera node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Capture the mouse for the FPS control
	
	# Get the Camera3D node (adjust path if needed)
	camera = get_node("/root/Node3D/Player/Camera3D")
	print(camera)  # Debugging line to confirm the camera node is found

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Rotate Player horizontally with the mouse for looking left and right
		rotate_y(-event.relative.x * sensitivity)
		
		# Apply vertical rotation to the camera, with clamping
		vertical_rotation -= event.relative.y * sensitivity
		vertical_rotation = clamp(vertical_rotation, -1.5, 1.5)  # Limits the up/down angle
		
		# Update the camera's rotation in the x-axis
		camera.rotation_degrees.x = vertical_rotation * 180 / PI

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	apply_central_force(transform.basis * input * 1200.0 * delta)
