extends Node
class_name GameSaveNode

var music_vol = -10					# music volume in db (default is -10)
var effects_vol = -10				# effects volume in db (default is -10)

# read parameters from savefile if it exists
func read_game_parameters():
	var save_file = File.new()		# check if settings file exists
	if not save_file.file_exists("user://AMBAsettings.save"):
		return
	# if settings file exists, open it
	save_file.open("user://AMBAsettings.save", File.READ)
	var current_line = parse_json(save_file.get_line())			# parse json object
	for i in current_line.keys():
		self.set(i, int(current_line[i]))						# set saved variables
	save_file.close()											# close the file

# apply parameters in the game
func apply_settings():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_vol)
	if effects_vol > -50:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Effects"), false)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Effects"), true)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), effects_vol)

# save game parameters to the savefile
func save_game_parameters():
	var save_file = File.new()
	var save_dict = {"music_vol":music_vol, "effects_vol":effects_vol}
	save_file.open("user://AMBAsettings.save", File.WRITE)
	save_file.store_line(to_json(save_dict))
	save_file.close()

# read and apply secret parameters for easter eggs and different features
func apply_secret_parameters():
	var save_file = File.new()		# check if settings file exists
	if not save_file.file_exists("user://AMBASecretSettings.save"):
		return
	var mirza = get_node_or_null("Mirza")
	if not mirza:					# do nothing if there is no character on the scene
		return
	# if settings file exists, open it
	save_file.open("user://AMBASecretSettings.save", File.READ)
	var current_line = parse_json(save_file.get_line())			# parse json object
	for i in current_line.keys():
		$Mirza.set(i, int(current_line[i]))						# set saved variables in character node
	save_file.close()											# close the file
