extends AudioStreamPlayer

const level_music = preload("res://Assets/My Song.mp3")

func _ready():
	#_play_music_level()
	pass

func _play_music(music: AudioStream, volume = 0.0):
	play()
	
func _play_music_level():
	_play_music(level_music)


func _on_finished() -> void:
	_play_music_level()
