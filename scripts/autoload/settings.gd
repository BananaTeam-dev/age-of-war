## User settings persistence + application layer.
## Stores per-user/per-machine preferences.
class_name UserSettings
extends Node

signal changed(key: StringName, value: Variant)
signal loaded()
signal saved()

const SETTINGS_PATH := "user://settings.cfg"
const SCHEMA_VERSION := 1

var _data: Dictionary = {}

func _ready() -> void:
	load_from_disk()
	apply_all()

func _defaults() -> Dictionary:
	return {
		"meta": {
			"schema_version": SCHEMA_VERSION,
		},

		"video": {
			"fullscreen": true,
			"max_fps": 0,
		},

		"audio": {
			"master_db": 0.0,
			"music_db": -6.0,
			"sfx_db": -3.0,
			"mute": false,
		},
	}

func _migrate_if_needed() -> void:
	var meta := _data.get("meta", {}) as Dictionary
	var v := int(meta.get("schema_version", 0))

	if v < 1:
		pass

	meta["schema_version"] = SCHEMA_VERSION
	_data["meta"] = meta

func _merge_defaults(base: Dictionary, incoming: Dictionary) -> Dictionary:
	var out: Dictionary = base.duplicate(true)

	for k in incoming.keys():
		var bv: Variant = out.get(k)
		var iv: Variant = incoming[k]

		if bv is Dictionary and iv is Dictionary:
			out[k] = _merge_defaults(bv as Dictionary, iv as Dictionary)
		else:
			out[k] = iv

	return out

func get_value(path: String) -> Variant:
	var parts := path.split("/", false)
	var cur: Variant = _data
	for p in parts:
		if cur is Dictionary and (cur as Dictionary).has(p):
			cur = (cur as Dictionary)[p]
		else:
			return null
	return cur

func set_value(path: String, value: Variant, apply := true, persist := true) -> void:
	var parts := path.split("/", false)
	if parts.is_empty():
		return

	var cur := _data
	for i in range(parts.size() - 1):
		var key := parts[i]
		if not cur.has(key) or not (cur[key] is Dictionary):
			cur[key] = {}
		cur = cur[key]

	var leaf := parts[parts.size() - 1]
	cur[leaf] = value

	changed.emit(StringName(path), value)

	if apply:
		apply_for_path(path)
	if persist:
		save_to_disk()

func load_from_disk() -> void:
	var defaults := _defaults()
	var cfg := ConfigFile.new()
	var err := cfg.load(SETTINGS_PATH)

	var incoming := {}
	if err == OK:
		for section in cfg.get_sections():
			incoming[section] = {}
			for key in cfg.get_section_keys(section):
				incoming[section][key] = cfg.get_value(section, key)
	else:
		incoming = {}

	_data = _merge_defaults(defaults, incoming)
	_migrate_if_needed()

	loaded.emit()

func save_to_disk() -> void:
	var cfg := ConfigFile.new()

	for section in _data.keys():
		var val: Variant = _data[section]
		if val is Dictionary:
			for key in (val as Dictionary).keys():
				cfg.set_value(str(section), str(key), (val as Dictionary)[key])

	var err := cfg.save(SETTINGS_PATH)
	if err != OK:
		push_error("Failed to save settings: %s" % SETTINGS_PATH)
		return

	saved.emit()

func apply_all() -> void:
	apply_video()
	apply_audio()

func apply_for_path(path: String) -> void:
	if path.begins_with("video/"):
		apply_video()
	elif path.begins_with("audio/"):
		apply_audio()

func apply_video() -> void:
	var video := _data["video"] as Dictionary
	var fullscreen := bool(video["fullscreen"])
	var max_fps := int(video["max_fps"])

	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	if max_fps <= 0:
		Engine.max_fps = 0
	else:
		Engine.max_fps = max_fps

func apply_audio() -> void:
	var audio := _data["audio"] as Dictionary
	var mute := bool(audio["mute"])

	var master := AudioServer.get_bus_index("Master")
	if master == -1:
		push_warning("Audio bus 'Master' not found.")
		return

	var music := AudioServer.get_bus_index("Music")
	var sfx := AudioServer.get_bus_index("SFX")

	AudioServer.set_bus_mute(master, mute)
	AudioServer.set_bus_volume_db(master, float(audio["master_db"]))

	if music != -1:
		AudioServer.set_bus_volume_db(music, float(audio["music_db"]))
	if sfx != -1:
		AudioServer.set_bus_volume_db(sfx, float(audio["sfx_db"]))
