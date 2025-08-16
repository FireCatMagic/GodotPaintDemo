extends Node3D


var view_sensitivity = 0.035
var body = 0.0
var pitch = 0.0
var speed = 0.15

func _ready():
	set_process(true)
	set_physics_process(true)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	set_process_input(true)
	
func _enter_tree():
	get_node("gimbal/innergimal/cam").make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(ie):
	if ie is InputEventMouseMotion:  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
		var sensitivity = view_sensitivity;
		set_body_rotation(pitch - ie.relative.y * sensitivity, body - ie.relative.x * sensitivity);  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review

func _physics_process(delta: float) -> void:  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	if Input.is_mouse_button_pressed(1):
		var transform = get_viewport().get_camera_3d().get_global_transform();
		var ray: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(transform.origin, transform * (Vector3(0,0,-100)))
		var result = get_world_3d().get_direct_space_state().intersect_ray(ray);
		if !result.is_empty():
			get_node("/root/world").paint_uv(result["position"], result["normal"], Color("#ffff00"))


func set_body_rotation(npitch, nyaw):  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	body = fmod(nyaw, 360)
	pitch = max(min(npitch, 90), -90)
	get_node("gimbal").set_rotation(Vector3(0, deg_to_rad(body), 0))
	get_node("gimbal/innergimal").set_rotation(Vector3(deg_to_rad(pitch), 0, 0))
	
func _process(delta):
	var aim = get_node("gimbal/innergimal").get_global_transform().basis;

	var direction = Vector3();
	
	if Input.is_key_pressed(KEY_W):
		direction -= aim[2];
	if Input.is_key_pressed(KEY_S):
		direction += aim[2];
	if Input.is_key_pressed(KEY_A):
		direction -= aim[0];
	if Input.is_key_pressed(KEY_D):
		direction += aim[0];
	
	direction = direction.normalized()*speed;
	translate(direction)
