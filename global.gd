extends Node

const LIZARD_TYPE_MAP: Dictionary[Lizard.SELECTION, String] = {
	Lizard.SELECTION.ROCK: "rock",
	Lizard.SELECTION.PAPER: "paper",
	Lizard.SELECTION.SCISSORS: "scissors",
	Lizard.SELECTION.SPOCK: "spock",
	Lizard.SELECTION.LIZARD: "lizard",
}

@export var info_display: InfoDisplay
@export var my_team: PackedStringArray
@export var opponent_team: PackedStringArray

var config_resource: GlobalConfig
var info_stack: Array[InfoInstance]


func random_team() -> PackedStringArray:
	var result: PackedStringArray
	var keys := config_resource.sprite_data.keys()
	for i in config_resource.team_size:
		keys.shuffle()
		result.push_back(keys[0])
	return result


func clear_info() -> void:
	info_stack.clear()
	if null != info_display:
		info_display.configure(null)


func push_info(info: InfoInstance) -> void:
	print("push info ", info.title)
	info_stack.push_back(info)
	if null != info_display:
		info_display.configure(info_stack.back())


func pop_info(info: InfoInstance) -> void:
	print("pop info ", info.title)
	info_stack.erase(info)
	if null != info_display:
		info_display.configure(null if info_stack.is_empty() else info_stack.back())


func configure(config: GlobalConfig) -> void:
	config_resource = config
	my_team.resize(config.team_size)
	opponent_team.resize(config.team_size)


func set_lizard_team(selected_team_node: Node2D) -> void:
	var all_positions = selected_team_node.get_children()
	for i in range(0, all_positions.size()) :
		my_team[i] = LIZARD_TYPE_MAP.get(all_positions[i].get_node("Lizard").selection, "paper")


func generate_hints() -> PackedStringArray:
	var result: PackedStringArray
	var checked: Array
	result.resize(my_team.size())
	checked.resize(my_team.size())
	
	# Initially assigning red or green based on matchup
	for i in my_team.size():
		var mine := config_resource.sprite_data.get(my_team[i]) as LizardConfig
		var theirs := config_resource.sprite_data.get(opponent_team[i]) as LizardConfig
		if mine.beats(opponent_team[i]):
			result.set(i, "green")
			checked.set(i, true)
		elif theirs.beats(my_team[i]):
			result.set(i, "red")
		else:
			result.set(i, "blue")
			checked.set(i, true)
	
	# Going through red results and checking if my team in that slot can beat opp team
	# in any other slot
	for i in result.size():
		if result[i] == "red":
			var mine := config_resource.sprite_data.get(my_team[i]) as LizardConfig
			for j in result.size():
				if j != i and not checked[j]:
					var theirs := config_resource.sprite_data.get(opponent_team[j]) as LizardConfig
					if mine.beats(opponent_team[j]):
						result.set(i, "yellow")
	
	return result
	
