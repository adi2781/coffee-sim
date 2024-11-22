extends RigidBody3D

var sensitivity = 0.05 #mouse sensitivity
var camera 

var horizontal_rotation = 0.0   
var target_horizontal_rotation = 0.0  # for smoothing
var vertical_rotation = 0.0  
var target_vertical_rotation = 0.0  # for smoothing

const ROTATE_SMOOTHNESS = 2.5  # Adjust for rotational smoothness
const PITCH_LIMIT = 1.5  # Limit vertical rotation to avoid flipping

func _ready() -> void:
	print("Scene is ready, setting mouse mode...")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Capture the mouse for FPS control
	
	# Get the Camera3D node
	camera = get_node("/root/Node3D/Player/Camera3D")

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Update target rotation values based on mouse movement
		target_horizontal_rotation += -event.relative.x * sensitivity * 0.05  # Convert to radians
		target_vertical_rotation -= event.relative.y * sensitivity * 0.05
		
		# Clamp the vertical rotation (pitch)
		target_vertical_rotation = clamp(target_vertical_rotation, -PITCH_LIMIT, PITCH_LIMIT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Smoothly interpolate horizontal rotation (yaw)
	horizontal_rotation = lerp(horizontal_rotation, target_horizontal_rotation, ROTATE_SMOOTHNESS * delta)
	rotation.y = horizontal_rotation
	
	# Smoothly interpolate vertical rotation (pitch)
	if camera:
		vertical_rotation = lerp(vertical_rotation, target_vertical_rotation, ROTATE_SMOOTHNESS * delta)
		camera.rotation.x = vertical_rotation

	# Handle movement directly without interpolation
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	apply_central_force(transform.basis * input * 2000.0 * delta)
