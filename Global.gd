extends Node


var winner = 'P'
var difficulty = 2
var tutorialPhase = 1

var scrabbleWords = {}


func _ready():
	
	var file = File.new()
	file.open("res://ScrabbleWords.json", file.READ)
	var json = file.get_as_text()
	var json_result = JSON.parse(json)
	file.close()
	scrabbleWords = json_result.get_result()
	
#	var medium = File.new()
#	medium.open("res://MediumDictionary.json", file.READ)
#	json = medium.get_as_text()
#	json_result = JSON.parse(json)
#	file.close()
#	mediumDictionary = json_result.get_result()
#
#	var hard = File.new()
#	hard.open("res://HardDictionary.json", file.READ)
#	json = hard.get_as_text()
#	json_result = JSON.parse(json)
#	file.close()
#	hardDictionary = json_result.get_result()
