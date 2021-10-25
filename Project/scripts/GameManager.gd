extends Node


const EXAMPLES = {
		STABLE = [
			[0,0,0,0,0],
			[0,0,1,0,0],
			[0,1,0,1,0],
			[0,1,0,1,0],
			[0,0,1,0,0],
			[0,0,0,0,0],
		],

		GLIDER = [
			[0,0,0,0,0,0],
			[0,0,0,0,0,0],
			[0,0,1,0,0,0],
			[0,0,0,1,1,0],
			[0,0,1,1,0,0],
			[0,0,0,0,0,0]
		],

		SMALL_EXPLODER = [
			[0,0,0,0,0],
			[0,0,1,0,0],
			[0,1,1,1,0],
			[0,1,0,1,0],
			[0,0,1,0,0],
			[0,0,0,0,0]
		]
}


const CELL := preload("res://scenes/Cell.tscn")
var CELL_SIZE := Vector2(48,48)
var clicked_cell = null
var cells_dict : Dictionary
var cells_neighbors := {}
var mouse_click_held := false
var mouse_drag_state := true
var touch_event_mode = -1 # 0: remove mode, 1: add mode, -1: both
var timer : Timer
signal next_generation

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = 0.3
	get_node("/root/Main").add_child(timer)
	var _err = timer.connect("timeout", self, "compute_next_generation")

func create_grid(viewport) -> Dictionary:
	var count_x = floor(viewport.rect_size.x / cell_size.x)
	var count_y = floor(viewport.rect_size.y / cell_size.y) - 1
	var cell_needs_count = count_x * count_y
	var cell_current_count = len(cells_dict.values())
	#print("Grid has now: ", cell_current_count, " cell nodes, and needs: ", cell_needs_count)
	var gpos : Vector2
	var rpos : Vector2
	for y in range(count_y):
		for x in range(count_x):
			gpos = Vector2(x,y)
			if gpos in cells_dict.keys():
				pass
			rpos = gpos * GameManager.cell_size + GameManager.cell_size / 2
			cells_dict[gpos] = CELL.instance()
			cells_dict[gpos].position = rpos
			cells_dict[gpos].grid_position = gpos
			cells_dict[gpos].connect("out_of_view", self, "_on_cell_out_of_view")
	return cells_dict

func _on_cell_out_of_view(cell) -> void:
	cells_dict.erase(cell.grid_position)
	cell.queue_free()

func update_cells_colors(alive : Color, dead : Color) -> void:
	for cell in cells_dict.values():
		cell.dead_color = dead
		cell.alive_color = alive
		cell.state = !cell.state
		cell.state = !cell.state


func select_cell(cell) -> bool:
	clicked_cell = cell
	if touch_event_mode == 0:
		clicked_cell.state = false
	elif touch_event_mode == 1:
		clicked_cell.state = true
	else:
		clicked_cell.state = !clicked_cell.state
	return clicked_cell.state


func get_neighbors(cell) -> Array:
	if !(cell in cells_neighbors):
		var gp = cell.grid_position
		var ngp := [
			Vector2(gp.x - 1, gp.y - 1),
			Vector2(gp.x - 1, gp.y),
			Vector2(gp.x - 1, gp.y + 1),
			Vector2(gp.x, gp.y + 1),
			Vector2(gp.x, gp.y - 1),
			Vector2(gp.x + 1, gp.y - 1),
			Vector2(gp.x + 1, gp.y),
			Vector2(gp.x + 1, gp.y + 1)
		]
		cells_neighbors[cell] = []
		for p in ngp:
			if p in cells_dict:
				cells_neighbors[cell].append(p)
	return cells_neighbors[cell]


func toggle_add_cell_mode():
	touch_event_mode = 1

func toggle_remove_cell_mode():
	touch_event_mode = 0

func toggle_dual_cell_mode():
	touch_event_mode = -1

func reset_grid():
	for cell in cells_dict.values():
		cell.state = false

func start_timer() -> void:
	timer.start()

func stop_timer() -> void:
	timer.stop()	

func compute_next_generation() -> void:
	var cells_to_turn_alive := []
	var cells_to_turn_dead := []
	for cell_pos in cells_dict:
		var ns_pos = get_neighbors(cells_dict[cell_pos])
		var ns_state := {true:0, false:0}
		for nsp in ns_pos:
			ns_state[cells_dict[nsp].state] += 1
		if (cells_dict[cell_pos].state and (ns_state[true] == 2 or ns_state[true] == 3)) or (!cells_dict[cell_pos].state and ns_state[true] == 3):
			cells_to_turn_alive.append(cells_dict[cell_pos])
		else:
			cells_to_turn_dead.append(cells_dict[cell_pos])
	for cell in cells_to_turn_alive:
		cell.state = true
	for cell in cells_to_turn_dead:
		cell.state = false
	emit_signal("next_generation")

