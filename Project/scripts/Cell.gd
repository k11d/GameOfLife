extends Area2D
class_name Cell


export(Color) var dead_color := Color.white setget set_dead_color
export(Color) var alive_color := Color.aquamarine setget set_alive_color
export(bool) var state := false setget set_state
var grid_position : Vector2
signal out_of_view(me)


func _on_Area2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			var _st = GameManager.select_cell(self)
			GameManager.mouse_click_held = true
			GameManager.mouse_drag_state = _st
		else:
			GameManager.mouse_click_held = false
	if event.is_action_released("click"):
		GameManager.mouse_click_held = false


func set_dead_color(col : Color) -> void:
	dead_color = col


func set_alive_color(col : Color) -> void:
	alive_color = col


func set_state(st : bool) -> void:
	state = st
	if state:
		modulate = alive_color
	else:
		modulate = dead_color


func _on_Cell_mouse_entered() -> void:
	if GameManager.mouse_click_held:
		self.state = GameManager.mouse_drag_state


func _on_VisibilityNotifier2D_screen_exited() -> void:
	emit_signal("out_of_view", self)
