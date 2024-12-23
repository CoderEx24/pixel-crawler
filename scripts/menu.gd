extends Control

# Dictionary to store hero data
var heroes = {
	"Hero": {
		"description": "Hero",
	},
	"Knight": {
		"description": "Knight",
	},
	"Wizard": {
		"description": "Wizzard",
	}
}

# Variable to track selected hero
var selected_hero = "Hero"  # Default selection
@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_button as Button
@onready var next_level = preload("res://scenes/Levels_selection.tscn") as PackedScene
func _ready():
	# Connect button signals for hero selection
	$MarginContainer/HBoxContainer/VBoxContainer/Hero_button.connect("pressed", Callable(self, "_on_hero_selected_hero"))
	$MarginContainer/HBoxContainer/VBoxContainer/Knight_button.connect("pressed", Callable(self, "_on_hero_selected_knight"))
	$MarginContainer/HBoxContainer/VBoxContainer/Wizzard_button.connect("pressed", Callable(self, "_on_hero_selected_Wizzard"))

	# Start Game button
	start_button.button_down.connect(on_start_pressed1)

	# Update the display for the default hero
	update_selected_hero_display()

func _on_hero_selected_hero():
	_on_hero_selected("Hero")

func _on_hero_selected_knight():
	_on_hero_selected("Knight")

func _on_hero_selected_wizard():
	_on_hero_selected("Wizzard")

func _on_hero_selected(hero_name):
	# Update the selected hero
	selected_hero = hero_name
	update_selected_hero_display()

func update_selected_hero_display():
	# Update the label to show the selected hero and description
	var hero_data = heroes[selected_hero]
	#%Description.text = "Selected Hero: %s\n%s" % [selected_hero, hero_data["description"]]

func on_start_pressed1() -> void:
	get_tree().change_scene_to_packed(next_level)

	# Start the game by changing the scene
	# get_tree().change_scene("res://menu.gd")  # Update this to your actual game scene path
