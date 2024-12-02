extends Node3D

var current_state: String = "main"  
var first_scene = 10
var finish = false
var first_run = true
	
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
		if (first_run):
			await start_game()
			#post_minigame_1()
			return

#func _process(delta):
	#start_game()

func start_game():
	first_run = false
	DialogueManager.show_dialogue_balloon(load("res://dialogue/main.dialogue"), "start")
	#change to length of dialogue
	await get_tree().create_timer(20).timeout
	
	#change to length of minigame
	await get_tree().create_timer(5).timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	DialogueManager.show_dialogue_balloon(load("res://dialogue/main.dialogue"), "post_minigame")
	
	
	#reset_scene()
	#emit_signal("prev_game_done")

func post_minigame_1():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$"Game Layer".visible = true
	DialogueManager.show_example_dialogue_balloon(load("res://dialogue/main.dialogue"), "post_minigame")
	DialogueManager.show_example_dialogue_balloon(load("res://dialogue/main.dialogue"), "deep_emotion")

func reset_scene():
	var current_scene = get_tree().current_scene
	var scene_path = current_scene.scene_file_path
	var new_scene = load(scene_path)
	
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(new_scene)
