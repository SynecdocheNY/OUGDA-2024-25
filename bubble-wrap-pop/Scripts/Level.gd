extends Control

#Level Number
@export var LevelNum: int

#board length. X is the row count and Y is the column count
@export var Size: Vector2i

#starting tile. X is the row and Y is the column
@export var Start: Vector2i

#goal tiles. There can be multiple. X is the row and Y is the column
@export var Goal: Array[Vector2i]

#banned tiles. There can be multiple. X is the row and Y is the column
@export var Ban: Array[Vector2i]

#Length of time between one input and the next
@export var TimeLength: float

#Length of time for the whole Level
@export var LevelTime: float

#If level has a pop count requirement, turn On
@export var PopReq: bool

#Set pop count requirement as needed
@export var PopCount: int

var spritepos
var vis = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$CenterContainer/TileMapLayer.levelnum = LevelNum
	$CenterContainer/TileMapLayer.size.x = Size.x
	$CenterContainer/TileMapLayer.size.y = Size.y
	$CenterContainer/TileMapLayer.start = Start
	$CenterContainer/TileMapLayer.goal = Goal
	$CenterContainer/TileMapLayer.ban = Ban
	$CenterContainer/TileMapLayer.timelength = TimeLength
	$CenterContainer/TileMapLayer.leveltime = LevelTime
	$CenterContainer/TileMapLayer.popreq = PopReq
	$CenterContainer/TileMapLayer.popcount = PopCount
	
	var posx = 0
	var posy = 0
	var temp = 0
	if Size.y % 2 == 0:
		temp = Size.y/2
		posx = (1920 - (134 * temp)) /2
	else:
		temp = (Size.y -1) / 2
		posx = (1920 - ((134 * temp) + 89))/2
	posy = (925 - (89 * (Size.x) + 45))/2

	$CenterContainer/TileMapLayer.position.x = posx
	$CenterContainer/TileMapLayer.position.y = posy
	$CenterContainer/TileMapLayer._ready()
	spritepos = $CenterContainer/TileMapLayer.spritepos
	$BPMIndicator.position = spritepos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_vis_check()


func _vis_check():
	vis = $CenterContainer/TileMapLayer.allowed
	if vis == false:
		$BPMIndicator.visible = false
	else:
		$BPMIndicator.visible = true


func _on_spritetimer_timeout() -> void:
	spritepos = $CenterContainer/TileMapLayer.spritepos
	$BPMIndicator.position = spritepos
