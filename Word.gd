extends Node2D

var word
var lettersOfWord = []
var possibleNextPlays = []
var widthToSubtract
var heightToSubtract
# Declare member variables here. Examples:
# var a = 2
# var b = "text
# Called when the node enters the scene tree for the first time.
func _ready():
	widthToSubtract = ((word.length() * 150) - (word.length() * 50))/2
	heightToSubtract = 50
	for character in word.to_upper():
		lettersOfWord.append(character)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func calculateNextPlays(tilesInPlay, scrabbleWords):
	possibleNextPlays.clear()
	
	var subset
	
	for i in range(1<<(tilesInPlay.size() + 1) - 1):
		subset = dec2binArray((1<<(tilesInPlay.size() + 1) - 1) - (i + 1), tilesInPlay.size())
		if subset.empty():
			continue
		var wordToCheck = lettersOfWord.duplicate(true)
		for k in range(subset.size()):
			if subset[k] == 1:
				wordToCheck.append(tilesInPlay[k])
		if wordToCheck.size() == word.length():
			continue
		wordToCheck.sort()
		var stringOfWord = ""
		for character in wordToCheck:
			stringOfWord += character
		if scrabbleWords.has(stringOfWord):
			var wordsToInclude = []
			match Global.difficulty:
				1:
					for option in scrabbleWords[stringOfWord]:
						if scrabbleWords[stringOfWord][option] > 0 and scrabbleWords[stringOfWord][option] < 10000:
							wordsToInclude.append(option)
				2:
					for option in scrabbleWords[stringOfWord]:
						if scrabbleWords[stringOfWord][option] > 0 and scrabbleWords[stringOfWord][option] < 25000:
							wordsToInclude.append(option)
				3:
					for option in scrabbleWords[stringOfWord]:
						if scrabbleWords[stringOfWord][option] > 0:
							wordsToInclude.append(option)
				4:
					pass
					
			if wordsToInclude.size() != 0:
				if not wordsToInclude[0] in possibleNextPlays:
					possibleNextPlays += wordsToInclude
		subset = dec2binArray((1<<(tilesInPlay.size() + 1) - 1) - (i + 1), tilesInPlay.size())
	
	var toRemove = []
	for possible in possibleNextPlays:
		if possible == word + 'S':
			toRemove.append(possible)
	
	for element in toRemove:
		possibleNextPlays.erase(element)
			
		
				
	#for i in range(tilesOnBoard.size()):
		
		
	#make copy of tilesonboard
	#for i in range(tilesOnBoard.size()):
	pass	

func dec2binArray(num, length):
	var result = []
	while num > 0:
		result.push_front(num%2)
		num /= 2
	while result.size() < length:
		result.push_front(0)
	return result
	


func _on_Tween_tween_all_completed():
	for tile in get_children():
		if tile is Tween:
			continue
		tile.globalPos = tile.global_position
	pass # Replace with function body.
