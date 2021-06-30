extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var possibleTilePlays = []
var possibleStealPlays = {}
var possibleTransformPlays = {}

# Called when the node enters the scene tree for the first time.
func _ready():	
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	calculatePlays()
	print(possibleTilePlays)
	print(possibleStealPlays, " steals")
	pass # Replace with function body.


func calculatePlays():
	possibleTilePlays = []
	possibleStealPlays = {}
	possibleTransformPlays = {}
	var scrabbleWords = get_parent().scrabbleWords
	var subset
	
	var tilesInPlay = []
	for tile in get_node("../Board").get_children():
		tilesInPlay.append(tile.tileLetter)
	
	if tilesInPlay.empty():
		return
	
	for i in range((1<<tilesInPlay.size()) - 1):
		subset = dec2binArray((1<<(tilesInPlay.size() + 1) - 1) - (i + 1), tilesInPlay.size())
		#print(subset, " is subset")
		if subset == []:
			break
		var wordToCheck = []
		for k in range(subset.size()):
			if subset[k] == 1:
				wordToCheck.append(tilesInPlay[k])
		wordToCheck.sort()
		#print(wordToCheck)
		var stringOfWord = ""
		for character in wordToCheck:
			stringOfWord += character
		if scrabbleWords.has(stringOfWord):
			if not scrabbleWords[stringOfWord][0] in possibleTilePlays:
				possibleTilePlays += scrabbleWords[stringOfWord]
	
		for word in get_node("../PlayerWords").get_children():
			for possibleWord in word.possibleNextPlays:
				if !possibleStealPlays.has(possibleWord):
					possibleStealPlays[possibleWord] = word
	
	
func makePlay():
	var play
	if !possibleStealPlays.empty():
		play = possibleStealPlays.keys()[rand_range(0, possibleStealPlays.size() - 1)]
		#instance new word and add it to computerwords as a child
				
		
	elif !possibleTransformPlays.empty():
		play = possibleTransformPlays.keys()[rand_range(0, possibleTransformPlays.size() - 1)]
		
		
	elif !possibleTilePlays.empty():
		play = possibleTilePlays[rand_range(0, possibleTilePlays.size() - 1)]
		
		
	else:
		return
	
	
	
	
func dec2binArray(num, length):
	var result = []
	while num > 0:
		result.push_front(num%2)
		num /= 2
	while result.size() < length:
		result.push_front(0)
	return result
	
	
	
