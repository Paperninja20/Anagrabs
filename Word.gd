extends Node2D

var word
var lettersOfWord = []
var possibleNextPlays = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text
# Called when the node enters the scene tree for the first time.
func _ready():
	for character in word.to_upper():
		lettersOfWord.append(character)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func calculateNextPlays(tilesInPlay, scrabbleWords):
	possibleNextPlays.clear()
	
	var subset = dec2binArray(1<<tilesInPlay.size() - 1, tilesInPlay.size())
	
	for i in range(1<<tilesInPlay.size() - 1):
		if subset == []:
			break
		var wordToCheck = lettersOfWord.duplicate(true)
		for k in range(subset.size()):
			if subset[k] == 1:
				wordToCheck.append(tilesInPlay[k])
		wordToCheck.sort()
		var stringOfWord = ""
		for character in wordToCheck:
			stringOfWord += character
		if scrabbleWords.has(stringOfWord):
			if not scrabbleWords[stringOfWord][0] in possibleNextPlays:
				possibleNextPlays += scrabbleWords[stringOfWord]
		subset = dec2binArray((1<<tilesInPlay.size() - 1) - (i + 1), tilesInPlay.size())
				
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
	
