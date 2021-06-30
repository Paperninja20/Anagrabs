extends Node2D

const word = preload("res://Word.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var possibleTilePlays = []
var possibleStealPlays = {}
var possibleTransformPlays = {}

var currentX = 0
var currentY = 0

# Called when the node enters the scene tree for the first time.
func _ready():	
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	makePlay()
	pass # Replace with function body.


func calculatePlays():
	possibleTilePlays.clear()
	possibleStealPlays.clear()
	possibleTransformPlays.clear()
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
		if subset.empty():
			continue
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
		
		for word in get_children():
			if word is Timer:
				continue
			for possibleWord in word.possibleNextPlays:
				if !possibleTransformPlays.has(possibleWord):
					possibleTransformPlays[possibleWord] = word
	
	
func makePlay():
	calculatePlays()
	var newWord
	var play
	var tileArray = []
	var tileArraySorted = []
	if !possibleStealPlays.empty():
		print('stealing')
		play = possibleStealPlays.keys()[rand_range(0, possibleStealPlays.size() - 1)]
		print(play)
		var copyOfPlay = play
		possibleStealPlays[play].get_parent().remove_child(possibleStealPlays[play])
		#instance new word and add it to computerwords as a child
		for tile in possibleStealPlays[play].get_children():
			tileArray.append(tile)
			
		for character in possibleStealPlays[play].word:
			play.erase(play.find(character), 1)
			
		for tile in get_node("../Board").get_children():
			if tile.tileLetter in play:
				play.erase(play.find(tile.tileLetter), 1)
				tileArray.append(tile)
			
		newWord = word.instance()
		newWord.word = copyOfPlay
		
		for character in copyOfPlay:
			for tile in tileArray:
				if tile.tileLetter == character:
					tileArraySorted.append(tile)
					tileArray.erase(tile)
					break
		
		for tile in tileArraySorted:
			tile.get_parent().remove_child(tile)
			get_node("../Board").removeTile(tile)
			get_node("../Board").lettersInPlay.remove(tile.tileLetter)
			newWord.add_child(tile)
	
		
	elif !possibleTransformPlays.empty():
		print('transforming')
		
		play = possibleTransformPlays.keys()[rand_range(0, possibleTransformPlays.size() - 1)]
		var copyOfPlay = play
		possibleTransformPlays[play].get_parent().remove_child(possibleTransformPlays[play])
		#instance new word and add it to computerwords as a child
		for tile in possibleTransformPlays[play].get_children():
			tileArray.append(tile)
			
		for character in possibleTransformPlays[play].word:
			play.erase(play.find(character), 1)
			
		for tile in get_node("../Board").get_children():
			if tile.tileLetter in play:
				play.erase(play.find(tile.tileLetter), 1)
				tileArray.append(tile)
			
		newWord = word.instance()
		newWord.word = copyOfPlay
		
		for character in copyOfPlay:
			for tile in tileArray:
				if tile.tileLetter == character:
					tileArraySorted.append(tile)
					tileArray.erase(tile)
					break
		
		for tile in tileArraySorted:
			tile.get_parent().remove_child(tile)
			get_node("../Board").removeTile(tile)
			get_node("../Board").lettersInPlay.remove(tile.tileLetter)
			newWord.add_child(tile)
		
		
	elif !possibleTilePlays.empty():
		print('normal')
		
		play = possibleTilePlays[rand_range(0, possibleTilePlays.size() - 1)]
		var copyOfPlay = play
		for tile in get_node("../Board").get_children():
			for character in copyOfPlay:
				if tile.tileLetter == character:
					tileArray.append(tile)
					copyOfPlay.erase(copyOfPlay.find(character), 1)
					break
					
		newWord = word.instance()
		newWord.word = play
		
		for character in play:
			for tile in tileArray:
				if tile.tileLetter == character:
					tileArraySorted.append(tile)
					tileArray.erase(tile)
					break
					
		for tile in tileArraySorted:
			tile.get_parent().remove_child(tile)
			get_node("../Board").removeTile(tile)
			get_node("../Board").lettersInPlay.remove(tile.tileLetter)
			newWord.add_child(tile)
		
		
	else:
		print('none')
		return
	
	print(newWord.word, " is play")
	add_child(newWord)
	arrangeWords()
	addWord(tileArraySorted)
	calculatePlays()
	
func addWord(tileArray):
	#if (tileArray.size() * 40) + currentX > 1920:
	#	currentY += 60
	#	currentX = 80
	for tile in tileArray:
		var tween = tile.get_node("Tween")
		#print(str(tile.position.x) + " is old pos")
		#print(str(tile.position.y) + " is old pos")
		tween.interpolate_property(tile, "position", Vector2(tile.position.x, tile.position.y), Vector2(currentX, currentY), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
		#print(str(tile.position.x) + " is new pos")
		#print(str(tile.position.y) + " is new pos")
		currentX += 40
	currentX = 0
	currentY = 0
	
func arrangeWords():
	var currX = 80
	var currY = 80
	for word in self.get_children():
		if word is Timer:
			continue
		if (word.word.length() * 40 + currX > 1920):
			currY += 80
			currX = 80
		word.position.x = currX
		word.position.y = currY
		currX += (word.word.length() * 40) + 60
	
func dec2binArray(num, length):
	var result = []
	while num > 0:
		result.push_front(num%2)
		num /= 2
	while result.size() < length:
		result.push_front(0)
	return result
	
	
	
