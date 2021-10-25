extends Node

export(Color) var dead_color := Color.gray
export(Color) var alive_color := Color.cyan


func _ready() -> void:
	init_grid()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_GameView_resized() -> void:
	var win = $GameView.get_rect().size
	print("Redrawing the grid")
	init_grid()


func init_grid() -> void:
	var grid = GameManager.create_grid($GameView)
	for cell in grid.values():
		$GameView/Viewport/Grid.add_child(cell)
	GameManager.update_cells_colors(alive_color, dead_color)
