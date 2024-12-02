extends Node3D

var current_state: String = "main"  
var first_scene = 100
var finish = false

func wait_for_seconds(seconds: float):
	var timer = Timer.new()
	add_child(timer)  # Add the timer to the current node
	timer.wait_time = seconds
	timer.one_shot = true
	timer.start()

	# Wait until the timer times out
	await timer.timeout
	timer.queue_free()  # Clean up the timer after it's done


	
func _unhandled_input(event):
	if Input.is_action_just_pressed("accept"):
		await start_game()
		#post_minigame_1()
		return


func start_game():
	
	DialogueManager.show_example_dialogue_balloon(load("res://dialogue/main.dialogue"), "start")
	await get_tree().create_timer(first_scene).timeout
	get_tree().change_scene_to_file("res://minigame.tscn")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	finish = true;
	reset_scene()
	#emit_signal("prev_game_done")

func post_minigame_1():
	get_tree().change_scene_to_file("res://test2.tscn")
	DialogueManager.show_example_dialogue_balloon(load("res://dialogue/main.dialogue"), "post_minigame")
	wait_for_seconds(10)
	DialogueManager.show_example_dialogue_balloon(load("res://dialogue/main.dialogue"), "deep_emotion")

func reset_scene():
	var current_scene = get_tree().current_scene
	var scene_path = current_scene.scene_file_path
	var new_scene = load(scene_path)
	
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(new_scene)
