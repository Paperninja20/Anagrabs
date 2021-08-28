extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const tile = preload("res://Tile.tscn")
const word = preload("res://Word.tscn")

var requiredWords = ['WHAT', 'WHEAT', 'WEATHERED']
var currentRequiredWord = requiredWords.pop_front()
var canClick = false
var canPluck = false
var lastPhase = 0
var tileCount = 0
var currentOverrideTile = 1
var currX = 640
var currY = 440
onready var letters = $WordBag.letters
var scrabbleWords = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.tutorialPhase == 1:
		var tween = Tween.new()
		tween.interpolate_property($WordBag, "scale", $WordBag.scale, Vector2(0.65, 0.65), 0.5, Tween.TRANS_LINEAR)
		tween.name = "bagTween"
		$WordBag.add_child(tween)
		tween.start()
		yield(get_tree().create_timer(3), "timeout")
		$ClickPrompt.visible = true
		canClick = true
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
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if not canClick:
				return
			Global.tutorialPhase += 1
			$ClickPrompt.visible = false
			if Global.tutorialPhase == 2 and lastPhase != 2:
				canClick = false
				canPluck = true
				lastPhase = 2
				var bagTween = $WordBag.get_node("bagTween")
				bagTween.interpolate_property($WordBag, "scale", $WordBag.scale, Vector2(0.45, 0.45), 0.5, Tween.TRANS_LINEAR)
				bagTween.start()
				
				$TutorialBubble.moveInOut()
				yield(get_tree().create_timer(0.5), "timeout")
				$TutorialBubble.text = "Every few seconds, a tile will be plucked from the bag."
				yield(get_tree().create_timer(6.5), "timeout")
				$TutorialBubble.moveInOut()
				yield(get_tree().create_timer(0.5), "timeout")
				$TutorialBubble.text = "They will be placed clockwise and form a circle around the bag."
				yield(get_tree().create_timer(6.5), "timeout")
				$TutorialBubble.moveInOut()
				yield(get_tree().create_timer(0.5), "timeout")
				$TutorialBubble.text = "Once there are 8 tiles around the bag, tiles will start to be replaced with new ones."
				yield(get_tree().create_timer(5), "timeout")
				$TutorialBubble.moveInOut()
				yield(get_tree().create_timer(0.5), "timeout")
				$TutorialBubble.text = "Look! The word \"what\" can be formed from the tiles on board. Type it into the text box and hit enter to claim it. Words must be at least 4 letters long."
				$LineEdit.set("custom_colors/font_color_undeditable", Color("#910000"))
				$LineEdit.editable = true
				
			if Global.tutorialPhase == 3 and lastPhase != 3:
				canClick = false
				lastPhase = 3
				$TutorialBubble.moveInOut()
				yield(get_tree().create_timer(0.5), "timeout")
				$TutorialBubble.text = "As you can see, you now have a score of 4! Your score is the total number of tiles that you own."
				yield(get_tree().create_timer(3), "timeout")
				$ClickPrompt.visible = true
				canClick = true
				
			if Global.tutorialPhase == 4 and lastPhase != 4:
				lastPhase = 4
				canClick = false
				canPluck = true
				$TutorialBubble.moveInOut()
				yield(get_tree().create_timer(0.5), "timeout")
				$TutorialBubble.text = "You can also transform your words by adding letters from the middle of the board to the word to create a longer word or a new anagram of the word! Try transforming \"What\" into \"Wheat!\""
				$LineEdit.editable = true
			
			if Global.tutorialPhase == 5 and lastPhase != 5:
				lastPhase = 5
				canPluck = true
				canClick = false
				yield(get_tree().create_timer(4), "timeout")
				$ComputerWords.makePlay()
				$TutorialBubble.moveInOut()
				yield(get_tree().create_timer(0.5), "timeout")
				$TutorialBubble.text = "Words can be stolen in the same manner. Your opponent just stole your word by turning \"Wheat\" into \"Weather!\" Now they have 7 points and you have 0!"
				yield(get_tree().create_timer(3), "timeout")
				$ClickPrompt.visible = true
				canClick = true
			
			if Global.tutorialPhase == 6 and lastPhase != 6:
				lastPhase = 6
				canClick = false
				canPluck = true
				$TutorialBubble.moveInOut()
				yield(get_tree().create_timer(0.5), "timeout")
				$TutorialBubble.text = "Don't worry, an opportunity may come where we can steal it back."
				yield(get_tree().create_timer(3.5), "timeout")
				$TutorialBubble.moveInOut()
				yield(get_tree().create_timer(0.5), "timeout")
				$TutorialBubble.text = "And there it is! With the \'E\' and the \'D\' we can take it back by turning \"weather\" into \"weathered!\""
				$LineEdit.editable = true
			
			if Global.tutorialPhase >= 7:
				get_tree().change_scene("res://MainMenu.tscn")
			
			
func _on_PluckTileTimer_timeout():
	if not canPluck:
		return
	if $WordBag.letterBag.empty():
		gameOver()
		return
	tileCount += 1
	if tileCount == 10:
		canPluck = false
	if tileCount == 11:
		canPluck = false
	if tileCount == 13:
		canPluck = false
	if tileCount == 15:
		canPluck = false
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
		$Board.replaceTile(firstKey, newTile, scrabbleWords)
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
		if tileCount == 4:
			pass
	pass # Replace with function body.
	
func pluckLetter():
	if $WordBag.letterBag.empty():
		return
	#var randIndex = randi() % $WordBag.letterBag.size()
	var choice = $WordBag.letterBag[0]
	$WordBag.letterBag.remove(0)
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
	if new_text.to_upper() != currentRequiredWord:
		$LineEdit.invalid()
		return
	else:
		currentRequiredWord = requiredWords.pop_front()
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
		for word in $PlayerWords.get_children():
			word.calculateNextPlays($Board.lettersInPlay, scrabbleWords)
		$ComputerWords.calculatePlays()
		#$PlayerWords.arrangeWords()
		$PlayerWords.addWord(tilesOnBoard)
		if stolen:
			$ComputerWords.arrangeWords()
		
		if newWord.word.to_upper() == "WHAT":
			$LineEdit.editable = false
			$TutorialBubble.moveInOut()
			yield(get_tree().create_timer(0.5), "timeout")
			$TutorialBubble.text = "Awesome! Your words will appear on the bottom of the screen from left to right."
			yield(get_tree().create_timer(3), "timeout")
			$ClickPrompt.visible = true
			canClick = true
			
		if newWord.word.to_upper() == "WHEAT":
			$LineEdit.editable = false
			$TutorialBubble.moveInOut()
			yield(get_tree().create_timer(0.5), "timeout")
			$TutorialBubble.text = "Nice! Now you have a longer word!"
			yield(get_tree().create_timer(1.5), "timeout")
			$ClickPrompt.visible = true
			canClick = true
			
		if newWord.word.to_upper() == "WEATHERED":
			$LineEdit.editable = false
			$TutorialBubble.moveInOut()
			yield(get_tree().create_timer(0.5), "timeout")
			$TutorialBubble.text = "Continue forming new words, transforming old words, and stealing your opponent's words until there are no tiles remaining. Once this happens, the player with the most tiles wins!"
			yield(get_tree().create_timer(3), "timeout")
			$ClickPrompt.text = "Click to return to main menu"
			$ClickPrompt.visible = true
			canClick = true
			
		#for tile in tilesOnBoard:
			#print(tile.get_global_position())

		
	pass # Replace with function body.

func gameOver():
	if $PlayerScore.tileCount > $OppScore.tileCount:
		Global.winner = 'P'
	elif $OppScore.tileCount > $PlayerScore.tileCount:
		Global.winner = 'O'
	else:
		Global.winner = 'T'
	get_tree().change_scene("res://GameOver.tscn")
