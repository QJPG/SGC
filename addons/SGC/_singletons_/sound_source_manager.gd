extends Node

#ALERT: UNSAFE TO CHANGE
var _source_counted : int = 0

#WARNING: SAFE TO CHANGE
var max_sources : int = 12

func play_from_source(source : AudioStream, from : float = 0.0, local := false) -> AudioStreamPlayer:
	if _source_counted >= max_sources:
		return AudioStreamPlayer.new()
	
	var _audio_player = AudioStreamPlayer.new()
	_audio_player.stream = source
	
	if local:
		if get_tree().current_scene:
			get_tree().current_scene.add_child(_audio_player)
	else:
		add_child(_audio_player)
	
	_audio_player.name = "*DontDestroyAudioSource"
	_audio_player.play(from)
	_audio_player.finished.connect(
		func():
			_source_counted -= 1
			_audio_player.queue_free())
	
	_source_counted += 1
	
	return _audio_player
