extends HBoxContainer
class_name DrawControls

enum {
	AddButton,
	RemoveButton,
	BothButton,
}

func toggle_button(btn) -> void:
	if btn == AddButton:
		$Add.self_modulate = Color.green
		$Remove.self_modulate = Color.white
		$Both.self_modulate = Color.white
	elif btn == RemoveButton:
		$Remove.self_modulate = Color.green
		$Add.self_modulate = Color.white
		$Both.self_modulate = Color.white
	elif btn == BothButton:
		$Both.self_modulate = Color.green
		$Add.self_modulate = Color.white
		$Remove.self_modulate = Color.white

