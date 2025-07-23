extends Control

@onready var button = $CanvasLayer/MainMenu/HBoxContainer/VBoxContainer/Button
@onready var canvas = $CanvasLayer





func _ready() -> void:
	button.pressed.connect(startGame)
	
	
func _process(delta: float) -> void:
	if(!Global.inMenu):
		startGame()
	if(Input.is_action_just_pressed("jump")):
		startGame()

func startGame():
	Global.inMenu = false
	canvas.visible = false
