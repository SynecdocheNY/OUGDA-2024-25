extends TileMapLayer

var levelnum: int
var size: Vector2i
var start: Vector2i
var goal: Array[Vector2i]
var ban: Array[Vector2i]
var timelength: float
var leveltime: float
var popreq: bool
var popcount: int

var startarray = [] #reformatted start
var goallist = [] #reformatted goal var
var banlist = [] #reformatted ban var
var array = [] #total array
var nArray = [] #neighbor array for selected cell
var currentcell = [] #selected cell
var wincheck = []  #checks win condition
var usedarray = [] #used cells
var allowed = true #timer check for gameplay
var timeout = false #level time check
var winflag = false #win flag for timer
var spritepos
var popcount2 = 0
var check


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_level()
	currentcell = startarray #makes the starting cell the first current cell
	popcount2 = popcount
	spritepos = to_global(map_to_local(Vector2i(currentcell[1],currentcell[0])))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_wincon()
	_leveltimer()


#handles inputs
func _unhandled_input(event):
	if event is InputEventKey:
		
		#restart
		if event.pressed and event.keycode == KEY_T:
			get_tree().reload_current_scene()
			
		#even columns
		if currentcell[1] % 2 == 0 and allowed == true and event.is_echo() == false:
			
			if currentcell in goallist and currentcell not in wincheck:
				wincheck.append(currentcell)
		
			if event.pressed and event.keycode == KEY_Q:
				if currentcell[0] != 0 and currentcell[1] != 0 and nArray[0] not in usedarray:
					_pop_func(0)

			if event.pressed and event.keycode == KEY_W:
				if currentcell[0] != 0 and nArray[1] not in usedarray:
					_pop_func(1)

			if event.pressed and event.keycode == KEY_E:
				if currentcell[0] != 0 and currentcell[1] != size.y-1 and nArray[2] not in usedarray:
					_pop_func(2)

			if event.pressed and event.keycode == KEY_A:
				if currentcell[1] != 0 and nArray[3] not in usedarray:
					_pop_func(3)

			if event.pressed and event.keycode == KEY_S:
				if currentcell[0] != size.x-1 and nArray[5] not in usedarray:
					_pop_func(5)

			if event.pressed and event.keycode == KEY_D:
				if currentcell[1] != size.y-1 and nArray[4] not in usedarray:
					_pop_func(4)

		#odd columns
		elif currentcell[1] % 2 != 0 and allowed == true and event.is_echo() == false:
			
			if currentcell in goallist and currentcell not in wincheck:
				wincheck.append(currentcell)
	
			if event.pressed and event.keycode == KEY_Q:
				if currentcell[1] != 0 and nArray[1] not in usedarray:
					_pop_func(1)

			if event.pressed and event.keycode == KEY_W:
				if currentcell[0] != 0 and nArray[0] not in usedarray:
					_pop_func(0)

			if event.pressed and event.keycode == KEY_E:
				if currentcell[1] != size.y-1 and nArray[2] not in usedarray:
					_pop_func(2)

			if event.pressed and event.keycode == KEY_A:
				if currentcell[0] != size.x-1 and currentcell[1] != 0 and nArray[3] not in usedarray:
					_pop_func(3)

			if event.pressed and event.keycode == KEY_S:
				if currentcell[0] != size.x-1 and nArray[4] not in usedarray:
					_pop_func(4)

			if event.pressed and event.keycode == KEY_D:
				if currentcell[0] != size.x-1 and currentcell[1] != size.y-1 and nArray[5] not in usedarray:
					_pop_func(5)


#reformats values and calls the filling func
func _create_level():
	startarray = [start.x, start.y]
	for item in goal:
		goallist.append([item.x, item.y])
	for item in ban:
		banlist.append([item.x, item.y])
		
	_fill(size, startarray, goal)
	check = 0


#fills the board, creates cell array, calls neighbor func
func _fill(size, start, goal):
	for x in range(size.y):
		var tempRow = [] #temporary row created for neighbor array
		for y in range(size.x):
			
			#if cell is starting cell
			if [y,x] == startarray:
				set_cell(Vector2i(x,y),3,Vector2i(0,0))
				tempRow.append(1)
				
			#if cell is a goal cell
			elif [y,x] in goallist:
				set_cell(Vector2i(x,y),5,Vector2i(0,0))
				tempRow.append(2)
			
			#if cell is banned cell
			elif [y,x] in banlist:
				set_cell(Vector2i(x,y),7,Vector2i(0,0))
				tempRow.append(4)
			#every other cell
			else:
				set_cell(Vector2i(x,y),1,Vector2i(0,0))
				tempRow.append(3)
				
		array.append(tempRow)
		
	_neighbors([startarray[0],startarray[1]])


#finds the neighbors of a cell, outputs neighbor array
func _neighbors(core):
	nArray = []
	var count = 1
	
	#even columns
	if core[1] % 2 == 0:
		for x in range (core[0]-1, core[0]+2):
			for y in range (core[1]-1, core[1]+2):
				if count !=7 and count != 9:
					if [x,y] != core:
						nArray.append([x,y])
				count += 1
				
	#odd columns
	elif core[1] % 2 != 0:
		for x in range (core[0]-1, core[0]+2):
			for y in range (core[1]-1, core[1]+2):
				if count !=1 and count != 3:
					if [x,y] != core:
						nArray.append([x,y])
				count +=1


#determines the cell type and reassets accordingly
func _pop_func(next):
	if check == 0:
		$LevelTime.start(leveltime)
		check = 1
	allowed = false
	var cellid = array[nArray[next][1]][nArray[next][0]]
	if cellid == 4:
		cellid = cellid
	else:
		if popcount2 > 0:
			popcount2 -=1
		if currentcell in goallist:
			set_cell(Vector2i(currentcell[1],currentcell[0]),6,Vector2i(0,0))
		else:
			set_cell(Vector2i(currentcell[1],currentcell[0]),2,Vector2i(0,0))
		usedarray.append(currentcell)
		currentcell = nArray[next]
		set_cell(Vector2i(currentcell[1],currentcell[0]),3,Vector2i(0,0))
		_neighbors(currentcell)
		$Timer.start(timelength)


#runs in-game timer display
func _leveltimer():
	var dumb = float(leveltime) + 0.0
	var temp = round($LevelTime.get_time_left() * 10)
	var timeleft = temp/10
	timeleft = timeleft + 0.0
	if len(wincheck) != len(goallist) and timeout == false:
		if popreq == true:
			if check == 1:
				$LevelTime/HBoxContainerL/PopReq.set_text('Required Pops: '+str(popcount2))
				$LevelTime/HBoxContainerR/TimeCount.set_text(str(timeleft))
			else:
				$LevelTime/HBoxContainerL/PopReq.set_text('Required Pops: '+str(popcount2))
				$LevelTime/HBoxContainerR/TimeCount.set_text(str(leveltime))
		else:
			if check == 1:
				$LevelTime/HBoxContainerR/TimeCount.set_text(str(timeleft))
			else:
				$LevelTime/HBoxContainerR/TimeCount.set_text(str(leveltime))


func _on_timer_timeout() -> void:
	if len(wincheck) != len(goallist) and timeout == false:
		allowed = true
		spritepos = to_global(map_to_local(Vector2i(currentcell[1],currentcell[0])))
		$Timer/spritetimer.start(0.0000000000001)


func _on_level_time_timeout() -> void:
	if winflag == false:
		timeout = true
		$LevelTime/HBoxContainerL/PopReq.set_text("Time's UP!")
		$LevelTime/HBoxContainerR/TimeCount.set_text("")
		$FinishTimer.start(3)


#checks win condition
func _wincon():
	if currentcell in goallist and currentcell not in wincheck and len(wincheck) == len(goallist)-1:
		winflag = true
		set_cell(Vector2i(currentcell[1],currentcell[0]),4,Vector2i(0,0))
		wincheck.append(currentcell)
		if popreq == true and len(usedarray) < popcount:
			$LevelTime/HBoxContainerL/PopReq.set_text('Not Enough Pops!')
			$LevelTime/HBoxContainerR/TimeCount.set_text("")
			$FinishTimer.start(3)
		else:
			$LevelTime/HBoxContainerL/PopReq.set_text('Yay!')
			$LevelTime/HBoxContainerR/TimeCount.set_text("")
			$FinishTimer.start(3)


func _on_finish_timer_timeout() -> void:
	var nextscene = load("res://Scenes/Levels/Level"+str(levelnum + 1)+".tscn")
	if timeout == true:
		get_tree().reload_current_scene()
	if popreq == true and len(usedarray) < popcount:
		get_tree().reload_current_scene()
	if nextscene != null:
		get_tree().change_scene_to_file("res://Scenes/Levels/Level"+str(levelnum + 1)+".tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/Win.tscn")
