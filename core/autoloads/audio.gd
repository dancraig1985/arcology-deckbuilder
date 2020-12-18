extends Node

var music_track = "MusicIntro"

func play(sound):
	# get list of AudioStream children references
	var children = get_children()
	for i in children:
		# if the name matches our given sound string, play it
		if i.name == sound:
			get_node(sound).play()
			return
	# No node with name found
	print(str("Sound node to play not found: ", sound, ". Available Nodes: ", children.size()))

func stop(sound):
	var children = get_children()
	for i in children:
		# if the name matches our given sound string, play it
		if i.name == sound:
			get_node(sound).stop()
			return
	# No node with name found
	print(str("Sound node to stop not found: ", sound, ". Available Nodes: ", children.size()))

func play_music(_sound):
	var _current_music_node = get_node(music_track)
	if _current_music_node.playing:
		_current_music_node.stop()
	
	music_track = _sound
	play(music_track)
