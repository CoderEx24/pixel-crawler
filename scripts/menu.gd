extends Control

# Dictionary to store hero data
var heroes = {
	"Hero": {
		"description": "A balanced hero with average stats.",
	},
	"Knight": {
		"description": "A strong and resilient fighter.",
	},
	"Wizard": {
		"description": "A master of magic with high damage.",
	}
}

# Variable to track selected hero
var selected_hero = "Hero"  # Default selection

func _ready():
	# Connect button signals for hero selection
	$MarginContainer/HBoxContainer/VBoxContainer/Hero_button.connect("pressed", Callable(self, "_on_hero_selected_hero"))
	$MarginContainer/HBoxContainer/VBoxContainer/Knight_button.connect("pressed", Callable(self, "_on_hero_selected_knight"))
	$MarginContainer/HBoxContainer/VBoxContainer/Wizzard_button.connect("pressed", Callable(self, "_on_hero_selected_Wizzard"))

	# Start Game button
	$MarginContainer/HBoxContainer/VBoxContainer/Start_button.connect("pressed", Callable(self, "_on_start_game_pressed"))

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
	%Description.text = "Selected Hero: %s\n%s" % [selected_hero, hero_data["description"]]

func _on_start_game_pressed():
	# Pass the selected hero to the Globals singleton
	var selected_hero = "Hero"

	# Start the game by changing the scene
	# get_tree().change_scene("res://menu.gd")  # Update this to your actual game scene path
