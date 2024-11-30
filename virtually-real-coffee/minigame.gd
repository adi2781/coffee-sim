extends CanvasLayer


@export var required_clicks: int = 10
@export var time_limit: float = 5.0

var clicks = 0
var time_remaining = 0.0
var game_active = false

func start_game():
	clicks = 0
	time_remaining = time_limit
	game_active = true
	$Control/ProgressBar.value = 0
	$Control/ProgressBar.max_value = required_clicks
	$Control/Timer.start(time_limit)
	show()

func _on_Button_pressed():
	if game_active:
		clicks += 1
		$Control/ProgressBar.value = clicks
		
		$Control/VBoxContainer/Label2.text = "Clicks: %d / %d" % [clicks, required_clicks]
		if clicks >= required_clicks:
			end_game(true)

func _on_Timer_timeout():
	end_game(false)

func end_game(success: bool):
	game_active = false
	$Control/Timer.stop()
	emit_signal("minigame_result", success)
	hide()

signal minigame_result(success: bool)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game()
	# Example: Set initial values
	$Control/ProgressBar.value = 0

	# Example: Connect signals
	$Control/VBoxContainer/Button.pressed.connect(Callable(self, "_on_Button_pressed"))


	# Example: Adjust dynamic UI properties
	#if icon_texture:
		#$TextureRect.texture = icon_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_active:
		
		
		 # Example: Countdown Timer
		time_remaining -= delta
		if time_remaining > 0:
			$Control/VBoxContainer/Label.text = "Time Left: %d seconds" % int(time_remaining)
		else:
			end_game(false)  # End the game if time runs out
