extends CanvasLayer
class_name HUDUI

@export var lane_id: int = 0

@export var unit_costs := {
	&"clubman": 25
}

@onready var root: Control = $Root

@onready var top_bar: HBoxContainer = $Root/TopBar
@onready var gold_label: Label = $Root/TopBar/GoldLabel

@onready var bottom_bar: HBoxContainer = $Root/BottomBar
@onready var unit_buttons: HBoxContainer = $Root/BottomBar/UnitButtons

@onready var clubman_btn: Button = $Root/BottomBar/UnitButtons/UnitButton_Clubman

@onready var overlay: Control = $Root/Overlay
@onready var tooltip_panel: PanelContainer = $Root/Overlay/ToolTip
@onready var tooltip_text: Label = $Root/Overlay/ToolTip/Text

var _gold: int = 0


func _enter_tree() -> void:
	if is_instance_valid(tooltip_panel):
		tooltip_panel.visible = false


func _ready() -> void:
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tooltip_panel.mouse_filter = Control.MOUSE_FILTER_STOP

	Events.gold_changed.connect(_on_gold_changed)

	_setup_unit_button(
		clubman_btn,
		&"clubman",
		"Clubman",
		"Basic melee unit.\nCost: %d" % int(unit_costs.get(&"clubman", 0))
	)

	# Initialize UI
	_set_gold(0)
	_update_unit_buttons()


func _setup_unit_button(btn: Button, unit_id: StringName, title: String, tip: String) -> void:
	btn.text = "%s (%d)" % [title, int(unit_costs.get(unit_id, 0))]

	btn.pressed.connect(func():
		_try_spawn(unit_id)
	)

	btn.mouse_entered.connect(func():
		_show_tooltip(btn, tip)
	)

	btn.mouse_exited.connect(func():
		_hide_tooltip()
	)


func _try_spawn(unit_id: StringName) -> void:
	var cost := int(unit_costs.get(unit_id, 0))
	if _gold < cost:
		return

	Events.spawn_unit_requested.emit(unit_id, lane_id)


func _on_gold_changed(new_gold: int, _delta: int) -> void:
	_set_gold(new_gold)
	_update_unit_buttons()


func _set_gold(value: int) -> void:
	_gold = value
	gold_label.text = "Gold: %d" % _gold


func _update_unit_buttons() -> void:
	clubman_btn.disabled = _gold < int(unit_costs.get(&"clubman", 0))


func _show_tooltip(anchor_control: Control, text: String) -> void:
	tooltip_text.text = text
	tooltip_panel.visible = true

	var rect := anchor_control.get_global_rect()
	var pos := rect.position + Vector2(0, -tooltip_panel.size.y - 8)

	tooltip_panel.global_position = pos


func _hide_tooltip() -> void:
	tooltip_panel.visible = false
