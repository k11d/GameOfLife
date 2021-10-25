extends CanvasLayer
class_name UI


onready var gen_value = $TopBar/HBoxContainer/GenCounter/Value as Label
onready var play_controls = $TopBar/HBoxContainer/PlayControls as PlayControls
onready var draw_controls = $TopBar/HBoxContainer/DrawControls as DrawControls


func _ready() -> void:
	var _err = GameManager.connect("next_generation", self, 
									"_on_next_generation_update")
	_err = GameManager.connect("prev_generation", self, 
									"_on_prev_generation_update")

func _on_Both_pressed() -> void:
	GameManager.toggle_dual_cell_mode()
	draw_controls.toggle_button(draw_controls.BothButton)


func _on_Add_pressed() -> void:
	GameManager.toggle_add_cell_mode()
	draw_controls.toggle_button(draw_controls.AddButton)


func _on_Remove_pressed() -> void:
	GameManager.toggle_remove_cell_mode()
	draw_controls.toggle_button(draw_controls.RemoveButton)


func _on_ButtonReset_pressed() -> void:
	gen_value.text = "0"
	GameManager.reset_grid()
	if play_controls.state == play_controls.Paused:
		GameManager.compute_next_generation()


func _on_next_generation_update() -> void:
	gen_value.text = str(int(gen_value.text) + 1)

func _on_prev_generation_update() -> void:
	gen_value.text = str(max(0, int(gen_value.text) - 1))
