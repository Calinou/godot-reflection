# Camera freelook and movement script
#
# Copyright © 2020-present Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.
extends Camera3D

const MOUSE_SENSITIVITY = 0.0005

# The camera movement speed (tweakable using the mouse wheel).
var move_speed := 0.1

# Stores where the camera is wanting to go (based on pressed keys and speed modifier).
var motion := Vector3()

# Stores the effective camera velocity.
var velocity := Vector3()

# The initial camera node rotation.
var initial_rotation := rotation.y

# The rotation to lerp to (for mouse smoothing).
var rotation_dest := rotation

func _ready() -> void:
	if "--fsr1" in OS.get_cmdline_user_args():
		print_rich("[color=blue]FSR 1[/code] scaling mode")
		get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR
	elif "--fsr2" in OS.get_cmdline_user_args():
		print_rich("[color=cyan]FSR 2[/color] scaling mode")
		get_viewport().scaling_3d_mode = int(RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR2)
	else:
		print_rich("[color=gray]Bilinear[/color] scaling mode")

	if "--quality" in OS.get_cmdline_user_args():
		print_rich("[color=green]Quality[/color] scaling resolution")
		get_viewport().scaling_3d_scale = 1.0 / 1.5
	elif "--balanced" in OS.get_cmdline_user_args():
		print_rich("[color=yellow]Balanced[/color] scaling resolution")
		get_viewport().scaling_3d_scale = 1.0 / 1.7
	elif "--performance" in OS.get_cmdline_user_args():
		print_rich("[color=red]Performance[/color] scaling resolution")
		get_viewport().scaling_3d_scale = 1.0 / 2.0
	elif "--ultra-performance" in OS.get_cmdline_user_args():
		print_rich("[color=magenta]Ultra Performance[/color] scaling resolution")
		get_viewport().scaling_3d_scale = 1.0 / 3.0
	else:
		print_rich("[color=gray]Native[/code] scaling resolution")

	if not "--spin" in OS.get_cmdline_user_args():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	# Mouse look (effective only if the mouse is captured).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Horizontal mouse look.
		rotation_dest.y -= event.relative.x * MOUSE_SENSITIVITY
		# Vertical mouse look, clamped to -90..90 degrees.
		rotation_dest.x = clamp(rotation_dest.x - event.relative.y * MOUSE_SENSITIVITY, deg_to_rad(-90), deg_to_rad(90))

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if event.is_action_pressed("toggle_mouse_capture"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event.is_action_pressed("movement_speed_increase"):
		move_speed = min(1.5, move_speed + 0.1)

	if event.is_action_pressed("movement_speed_decrease"):
		move_speed = max(0.1, move_speed - 0.1)


func _process(delta: float) -> void:
	if "--spin" in OS.get_cmdline_user_args():
		set_process_input(false)
		rotation_dest.y += TAU / 360

	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	rotation = rotation.lerp(rotation_dest, 0.1)

	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	motion.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")

	# Normalize motion
	# (prevents diagonal movement from being `sqrt(2)` times faster than straight movement).
	motion = motion.normalized()

	# Speed modifier
	if Input.is_action_pressed("move_speed"):
		motion *= 2

	# Transform the motion by the camera's transform.
	motion = transform.basis.x * motion.x + transform.basis.y * motion.y + transform.basis.z * motion.z

	# Add motion, apply friction and velocity.
	velocity += motion * move_speed
	velocity *= 0.98
	position += velocity * delta


func _exit_tree() -> void:
	# Restore the mouse cursor upon quitting.
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
