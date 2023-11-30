extends Node3D

var previous_ticks_usec := Time.get_ticks_usec()
var frametimes := PackedFloat32Array()
var frametimes_cpu := PackedFloat32Array()
var frametimes_gpu := PackedFloat32Array()

@onready var viewport_rid := get_viewport().get_viewport_rid()

func _ready() -> void:
	# Only run this script in benchmark mode.
	if not "--benchmark" in OS.get_cmdline_user_args():
		queue_free()

	RenderingServer.viewport_set_measure_render_time(viewport_rid, true)

	$CameraPath/PathFollow3D/Camera3D.make_current()
	$AnimationPlayer.play(&"benchmark")


func _process(_delta: float) -> void:
	frametimes.push_back((Time.get_ticks_usec() - previous_ticks_usec) * 0.001)
	frametimes_cpu.push_back(RenderingServer.viewport_get_measured_render_time_cpu(viewport_rid) + RenderingServer.get_frame_setup_time_cpu())
	frametimes_gpu.push_back(RenderingServer.viewport_get_measured_render_time_gpu(viewport_rid))
	previous_ticks_usec = Time.get_ticks_usec()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	var frametime_average := 0.0
	for frametime in frametimes:
		frametime_average += frametime
	frametime_average /= frametimes.size()

	var frametime_cpu_average := 0.0
	for frametime in frametimes_cpu:
		frametime_cpu_average += frametime
	frametime_cpu_average /= frametimes_cpu.size()

	var frametime_gpu_average := 0.0
	for frametime in frametimes_gpu:
		frametime_gpu_average += frametime
	frametime_gpu_average /= frametimes_gpu.size()

	frametimes.sort()
	var frametime_1_percent_low := frametimes[round(frametimes.size() * 0.99)]
	var frametime_01_percent_low := frametimes[round(frametimes.size() * 0.999)]

	frametimes_cpu.sort()
	var frametime_cpu_1_percent_low := frametimes_cpu[round(frametimes_cpu.size() * 0.99)]
	var frametime_cpu_01_percent_low := frametimes_cpu[round(frametimes_cpu.size() * 0.999)]

	frametimes_gpu.sort()
	var frametime_gpu_1_percent_low := frametimes_gpu[round(frametimes_gpu.size() * 0.99)]
	var frametime_gpu_01_percent_low := frametimes_gpu[round(frametimes_gpu.size() * 0.999)]


	print_rich("[color=green]Done running benchmark ([b]%d[/b] frames rendered in [b]%.2f[/b] seconds).\n" % [Engine.get_frames_drawn(), Time.get_ticks_msec() * 0.001])
	print_rich("          | [b]Average[/b]             | [b]1% low[/b]              | [b]0.1% low[/b]")
	print_rich("---------:|---------------------|---------------------|------------------------")
	print_rich("[b]Frametime[/b] | [color=yellow]%d FPS (%.2f mspf)[/color] | %d FPS (%.2f mspf) | %d FPS (%.2f mspf)" % [1000.0 / frametime_average, frametime_average, 1000.0 / frametime_1_percent_low, frametime_1_percent_low, 1000.0 / frametime_01_percent_low, frametime_01_percent_low])
	print_rich(" [b]CPU Time[/b] | [color=blue]%d FPS (%.2f mspf)[/color] | %d FPS (%.2f mspf) | %d FPS (%.2f mspf)" % [1000.0 / frametime_cpu_average, frametime_cpu_average, 1000.0 / frametime_cpu_1_percent_low, frametime_cpu_1_percent_low, 1000.0 / frametime_cpu_01_percent_low, frametime_cpu_01_percent_low])
	print_rich(" [b]GPU Time[/b] | [color=red]%d FPS (%.2f mspf)[/color] | %d FPS (%.2f mspf) | %d FPS (%.2f mspf)" % [1000.0 / frametime_gpu_average, frametime_gpu_average, 1000.0 / frametime_gpu_1_percent_low, frametime_gpu_1_percent_low, 1000.0 / frametime_gpu_01_percent_low, frametime_gpu_01_percent_low])
	get_tree().quit()
