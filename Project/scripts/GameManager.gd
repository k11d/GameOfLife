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
var cell_size := Vector2(16, 16)
var clicked_cell = null
var cells_dict := {}
var cells_neighbors := {}
var cells_states_stack := []
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

func get_alive_neighbors(cell):
	var alive_neighbors := []
	for nsp in get_neighbors(cell):
		if cells_dict[nsp].state:
			alive_neighbors.append(cells_dict[nsp])
	return alive_neighbors

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
	var cells_to_switch := []
	for cell_pos in cells_dict:
		var cell = cells_dict[cell_pos]
		var alive_neighbors = get_alive_neighbors(cell)
		if (cell.state and (len(alive_neighbors) == 2 or len(alive_neighbors) == 3)) or (!cell.state and len(alive_neighbors) == 3):
			if !cell.state:
				cells_to_switch.append(cell)
		else:
			if cell.state:
				cells_to_switch.append(cell)
	var hist := []
	for cell in cells_to_switch:
		cell.state = !cell.state
		hist.append(cell)
	if len(hist) > 0:
		cells_states_stack.append(hist)
	emit_signal("next_generation")

