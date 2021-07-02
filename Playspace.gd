extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const tile = preload("res://Tile.tscn")
const word = preload("res://Word.tscn")

var currentOverrideTile = 1
var currX = 640
var currY = 440
onready var letters = $WordBag.letters
var scrabbleWords = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	var file = File.new()
	file.open("res://ScrabbleWords.json", file.READ)
	var json = file.get_as_text()
	var json_result = JSON.parse(json)
	file.close()
	scrabbleWords = json_result.get_result()
	$PlayerScore.left = false
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_PluckTileTimer_timeout():
	if $WordBag.letterBag.empty():
		print("no more tiles!")
		return
	var newTile = tile.instance()
	newTile.tileLetter = pluckLetter()
	newTile.position = Vector2(960, 420)
	newTile.scale = Vector2(0.25, 0.25)
	var tileCoords = $Board.placeTile(newTile)
	if !(tileCoords):
		var firstKey
		var count = 1
		for key in $Board.tileSlots:
			if count < currentOverrideTile:
				count += 1
				continue
			firstKey = key
			if currentOverrideTile < 8:
				currentOverrideTile += 1
			else:
				currentOverrideTile = 1
			break
		$Board.replaceTile(firstKey, newTile)
	else:
		currentOverrideTile = 1
		$Board.lettersInPlay.append(newTile.tileLetter)
		#print($Board.lettersInPlay)
		$Board.add_child(newTile)
		var tween = newTile.get_node("Tween")
		tween.interpolate_property(newTile, "position", Vector2(960, 420), tileCoords, 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.interpolate_property(newTile, "scale", Vector2(0.25, 0.25), Vector2(0.5, 0.5), 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
		$WordBag.updateTileCount(-1)
	var lettersOut = []
	for tile in $Board.get_children():
		if !(tile is Node2D):
			continue
		lettersOut.append(tile.tileLetter)
	for word in $PlayerWords.get_children():
		word.calculateNextPlays(lettersOut, scrabbleWords)
	for word in $ComputerWords.get_children():
		if word is Timer:
			continue
		word.calculateNextPlays(lettersOut, scrabbleWords)
	
	$ComputerWords.calculatePlays()
	
	pass # Replace with function body.
	
func pluckLetter():
	if $WordBag.letterBag.empty():
		return
	var randIndex = randi() % $WordBag.letterBag.size()
	var choice = $WordBag.letterBag[randIndex]
	$WordBag.letterBag.remove(randIndex)
	return choice
		
func checkWordonBoard(word):
	var tempresult = []
	var result = []
	var wordToCheck = word.to_upper()
	var wordDict = {}
	for character in wordToCheck:
		if !(wordDict.has(character)):
			wordDict[character] = 1
		else:
			wordDict[character] += 1
	for tile in $Board.get_children():
		if !(tile is Node2D):
			continue
		if wordDict.has(tile.tileLetter):
			if wordDict[tile.tileLetter] > 0:
				wordDict[tile.tileLetter] -= 1
				tempresult.append(tile)
				
	for key in wordDict:
		if wordDict[key] != 0:
			return []
	for character in wordToCheck:
		for tile in tempresult:
			if tile.tileLetter == character:
				result.append(tile)
				tempresult.erase(tile)
	return result
	
func checkForTransforms(wordToBeChecked):
	var result = []
	var tempresult = []
	var wordToCheck = []
	for character in wordToBeChecked.to_upper():
		wordToCheck.append(character)
	
	for playerWord in $PlayerWords.get_children():
		if playerWord.word.length() >= wordToBeChecked.length():
			continue
		var playerWordArray = []
		for character in playerWord.word.to_upper():
			playerWordArray.append(character)
		
		var remainingString = checkSubarray(playerWordArray, wordToCheck)
		if remainingString == "":
			continue
		tempresult = checkWordonBoard(remainingString)
		if tempresult.empty():
			continue
		for tile in playerWord.get_children():
			if tile is Tween:
				continue
			tempresult.append(tile)
		playerWord.get_parent().remove_child(playerWord)
		break
		
	print(wordToBeChecked.to_upper())
	for character in wordToBeChecked.to_upper():
		for tile in tempresult:
			if tile.tileLetter == character:
				result.append(tile)
				tempresult.erase(tile)
				break
				
	return result

func checkForSteals(wordToBeChecked):
	var result = []
	var tempresult = []
	var wordToCheck = []
	for character in wordToBeChecked.to_upper():
		wordToCheck.append(character)
	
	for computerWord in $ComputerWords.get_children():
		if computerWord is Timer:
			continue
		if computerWord.word.length() >= wordToBeChecked.length():
			continue
		var computerWordArray = []
		for character in computerWord.word.to_upper():
			computerWordArray.append(character)
		
		var remainingString = checkSubarray(computerWordArray, wordToCheck)
		if remainingString == "":
			continue
		tempresult = checkWordonBoard(remainingString)
		if tempresult.empty():
			continue
		for tile in computerWord.get_children():
			if tile is Tween:
				continue
			tempresult.append(tile)
		computerWord.get_parent().remove_child(computerWord)
		break
		
	print(wordToBeChecked.to_upper())
	for character in wordToBeChecked.to_upper():
		for tile in tempresult:
			if tile.tileLetter == character:
				result.append(tile)
				tempresult.erase(tile)
				break
				
	return result
		
func checkSubarray(subarray, array):
	var subarrayCopy = subarray.duplicate(true)
	var arrayCopy = array.duplicate(true)
	
	
	for element in subarray:
		if element in array:
			subarrayCopy.erase(element)
			arrayCopy.erase(element)
		else:
			return ""
	
	var stringresult = ""
	for character in arrayCopy:
		stringresult += character
	return stringresult
			

func _on_LineEdit_text_entered(new_text):
	var stolen = true
	print(new_text)
	$LineEdit.text = ''
	
	var sortedText = []
	var sortedTextString = ""
	for character in new_text.to_upper():
		sortedText.append(character)
	sortedText.sort()
	for element in sortedText:
		sortedTextString += element
	print(sortedTextString)
	if !(scrabbleWords.has(sortedTextString)):
		$LineEdit.invalid()
	elif !(new_text.to_upper() in scrabbleWords[sortedTextString]):
		$LineEdit.invalid()
	else:
		var tilesOnBoard = checkForSteals(new_text)
		if tilesOnBoard.empty():
			stolen = false
			tilesOnBoard = checkForTransforms(new_text)
		if tilesOnBoard.empty():
			tilesOnBoard = checkWordonBoard(new_text)
		if tilesOnBoard.empty():
			$LineEdit.unformable()
			return
		var newWord = word.instance()
		newWord.word = new_text
		newWord.position.x = 960 - (new_text.length() * 25) + 25
		newWord.position.y = 540
		
		for tile in tilesOnBoard:
			tile.get_parent().remove_child(tile)
			$Board.removeTile(tile)
			$Board.lettersInPlay.remove(tile.tileLetter)
			newWord.add_child(tile)
		
		$PlayerWords.add_child(newWord)
		#$PlayerWords.arrangeWords()
		$PlayerWords.addWord(tilesOnBoard)
		if stolen:
			$ComputerWords.arrangeWords()
		#for tile in tilesOnBoard:
			#print(tile.get_global_position())

		
	pass # Replace with function body.

