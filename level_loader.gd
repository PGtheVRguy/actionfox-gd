extends Node2D
var loading = true

var player : Node = null


func _ready() -> void:
	var currentScene = Global.level.instantiate()
	get_tree().root.get_node("game").add_child.call_deferred(currentScene)
	
	
	print("LOADED LEVEL, restarting nodes...")
	
	#reset things to ensure the nodes exist
	
	
	
	
	
func _process(delta: float) -> void:
	if player == null:
		player = get_node_or_null("/root/game/Player")
		if player == null:
			print("PLAYER NOT FOUND!!!")
			return
		else:
			print("PLAYER FOUND!")

	if loading:
		var bullets = get_node_or_null("/root/game/level/bullets")
		if bullets != null:
			loading = false
			await get_tree().process_frame
			var gamenode = get_tree().root.get_node("game").get_node("level")
			get_tree().root.get_node("game").move_child(gamenode, 0)
			get_tree().get_root().print_tree_pretty()
			
			player.get_node("body").reset()
			Global.reset()
			print("LOADING DONE!!! :3 :3 :3")
