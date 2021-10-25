extends HBoxContainer
class_name PlayControls

enum {
	Paused = 0,
	Playing = 1
}

var state := Paused


func play_pause():
	_on_ButtonPlay_pressed()
	return state


func _on_ButtonNext_pressed() -> void:
	GameManager.compute_next_generation()


func _on_ButtonPlay_pressed() -> void:
	if state == Paused:
		state = Playing
		$ButtonPlay.self_modulate = Color.green
		GameManager.start_timer()
	else:
		state = Paused
		$ButtonPlay.self_modulate = Color.white
		GameManager.stop_timer()


func _on_ButtonPrev_pressed() -> void:
	GameManager.step_back_generation()

