extends Node3D

var current_state: String = "main"  
var first_scene = 10
var finish = false
var first_run = true
	
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("accept"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		DialogueManager.show_dialogue_balloon(load("res://dialogue/main.dialogue"), "start")
