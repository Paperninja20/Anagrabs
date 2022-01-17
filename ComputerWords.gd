extends Node2D

const word = preload("res://Word.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var possibleTilePlays = []
var possibleStealPlays = {}
var possibleTransformPlays = {}

var animationSpeed = 0.5
var currentX = 0
var currentY = 0

# Called when the node enters the scene tree for the first time.
func _ready():	
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	var dice
	if Global.difficulty == 1:
		dice = 6
	elif Global.difficulty == 2:
		dice = 4
	elif Global.difficulty == 3:
		dice = 3
	else:
		dice = 2
	var diceRoll = randi()%dice + 1
	if diceRoll == 1:
		makePlay()
	pass # Replace with function body.


func calculatePlays():
	possibleTilePlays.clear()
	possibleStealPlays.clear()
	possibleTransformPlays.clear()
	var scrabbleWords = Global.scrabbleWords
	var subset
	
	var tilesInPlay = []
	for tile in get_node("../Board").get_children():
		if !(tile is Node2D):
			continue
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
			if wordsToInclude.size() > 0:
				if not wordsToInclude[0] in possibleTilePlays:
					possibleTilePlays += wordsToInclude
	
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
	while get_parent().playBeingMade:
		continue
	get_parent().playBeingMade = true
	#print("making play")
	calculatePlays()
	var newWord
	var play
	var tileArray = []
	var tileArraySorted = []
	var stolen = false
	var easyWeightedDice = [1,2,2,3,3,3,3,3,3,3,3]
	var mediumWeightedDice = [1,1,2,2,3,3,3,3,3,3,3]
	var hardWeightedDice = [1,1,1,2,2,2,3,3,3,3]
	var playType
	if Global.difficulty == 1:
		playType = easyWeightedDice[rand_range(0, easyWeightedDice.size() - 1)]
	elif Global.difficulty == 2:
		playType = mediumWeightedDice[rand_range(0, mediumWeightedDice.size() - 1)]
	else:
		playType = hardWeightedDice[rand_range(0, hardWeightedDice.size() - 1)]
	if possibleStealPlays.empty() and possibleTransformPlays.empty():
		playType = 3
	elif possibleStealPlays.empty():
		playType = randi()%2 + 2
		
	match playType:
		1:
			#print("stealing")
			if !possibleStealPlays.empty():
				stolen = true
				play = possibleStealPlays.keys()[rand_range(0, possibleStealPlays.size() - 1)]
				
				if Global.difficulty == 1:
					if possibleStealPlays[play].word.length() > 4:
						get_parent().playBeingMade = false
						return
				elif Global.difficulty == 2:
					if possibleStealPlays[play].word.length() > 5:
						get_parent().playBeingMade = false
						return
				
				var copyOfPlay = play
				possibleStealPlays[play].get_parent().remove_child(possibleStealPlays[play])
				#instance new word and add it to computerwords as a child
				for tile in possibleStealPlays[play].get_children():
					if tile is Tween:
						continue
					tileArray.append(tile)
					
				for character in possibleStealPlays[play].word:
					play.erase(play.find(character), 1)
					
				for tile in get_node("../Board").get_children():
					if !(tile is Node2D):
						continue
					if tile.tileLetter in play:
						play.erase(play.find(tile.tileLetter), 1)
						tileArray.append(tile)
					
				newWord = word.instance()
				newWord.word = copyOfPlay
				newWord.position.x = 960 - (copyOfPlay.length() * 25) + 25
				newWord.position.y = 540
				
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
			else:
				get_parent().playBeingMade = false
				return
	
		
		2:
			#print("transforming")
			if !possibleTransformPlays.empty():
				play = possibleTransformPlays.keys()[rand_range(0, possibleTransformPlays.size() - 1)]
				var copyOfPlay = play
				possibleTransformPlays[play].get_parent().remove_child(possibleTransformPlays[play])
				#instance new word and add it to computerwords as a child
				for tile in possibleTransformPlays[play].get_children():
					if tile is Tween:
						continue
					tileArray.append(tile)
					
				for character in possibleTransformPlays[play].word:
					play.erase(play.find(character), 1)
					
				for tile in get_node("../Board").get_children():
					if !(tile is Node2D):
						continue
					if tile.tileLetter in play:
						play.erase(play.find(tile.tileLetter), 1)
						tileArray.append(tile)
					
				newWord = word.instance()
				newWord.word = copyOfPlay
				newWord.position.x = 960 - (copyOfPlay.length() * 25) + 25
				newWord.position.y = 540
				
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
			else:
				get_parent().playBeingMade = false
				return
		
		
		3:
			#print("normal")
			if !possibleTilePlays.empty():
				play = possibleTilePlays[rand_range(0, possibleTilePlays.size() - 1)]
				var copyOfPlay = play
				
				if Global.difficulty == 1:
					if play.length() > 4:
						get_parent().playBeingMade = false
						return
				if Global.difficulty == 2:
					if play.length() > 5:
						get_parent().playBeingMade = false
						return
						
				for tile in get_node("../Board").get_children():
					if !(tile is Node2D):
						continue
					for character in copyOfPlay:
						if tile.tileLetter == character:
							tileArray.append(tile)
							copyOfPlay.erase(copyOfPlay.find(character), 1)
							break
							
				newWord = word.instance()
				newWord.word = play
				newWord.position.x = 960 - (play.length() * 25) + 25
				newWord.position.y = 540
				
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
				get_parent().playBeingMade = false
				return
		
	print(newWord.word, " is play") 
		
	add_child(newWord)
	arrangeWords()
	addWord(tileArraySorted)
	if stolen:
		get_node("../PlayerWords").arrangeWords()
	calculatePlays()
	get_parent().playBeingMade = false
	
func addWord(tileArray):
	get_node("../WordForm").play()
	for tile in tileArray:
		var tween = tile.get_node("Tween")

		tween.interpolate_property(tile, "position", tile.globalPos - tile.get_parent().position, Vector2(currentX, currentY), animationSpeed, Tween.TRANS_QUAD, Tween.EASE_IN)
		tween.interpolate_property(tile.get_parent(), "scale", Vector2(1, 1), Vector2(3, 3), animationSpeed, Tween.TRANS_QUAD, Tween.EASE_IN)
		tween.interpolate_property(tile.get_parent(), "position", tile.get_parent().position, 
			tile.get_parent().position - Vector2((tile.get_parent().widthToSubtract), (tile.get_parent().heightToSubtract)), animationSpeed, Tween.TRANS_QUAD, Tween.EASE_IN)
		tween.start()

		currentX += 50
	currentX = 0
	currentY = 0
	
	get_node("../AnimationTimerComputer").wait_time = animationSpeed + 0.1
	get_node("../AnimationTimerComputer").start()
	
func arrangeWords():
	var newScore = 0
	var startX = 50
	var currX = 50
	var currY = 50
	var tweenArray = []
	
	for word in get_children():
		if word is Timer:
			continue
		if word.get_child_count() <= 1:
			remove_child(word)
			word.queue_free()	
			
	for word in self.get_children():
		if word is Timer:
			continue
		newScore += word.word.length()
		if word.scale.x > 1 or word.scale.y > 1:
			var tween = word.get_node("Tween")
			tween.interpolate_property(word, "scale", word.scale, Vector2(1, 1), animationSpeed, Tween.TRANS_LINEAR, Tween.EASE_IN)
			tweenArray.push_front(tween)
		if (word.word.length() * 50 + currX > 1920):
			currY += 75
			if startX == 50:
				startX = 100
			else:
				startX = 50
			currX = startX
		var tween = word.get_node("Tween")
		tween.interpolate_property(word, "position", Vector2(word.position.x, word.position.y), Vector2(currX, currY), animationSpeed, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tweenArray.push_front(tween)
		currX += (word.word.length() * 50) + 70
	
	get_node('../OppScore').updateScore(newScore)
	for element in tweenArray:
		element.start()
	
func dec2binArray(num, length):
	var result = []
	while num > 0:
		result.push_front(num%2)
		num /= 2
	while result.size() < length:
		result.push_front(0)
	return result
	
	
func _on_AnimationTimerComputer_timeout():
	arrangeWords()
	pass # Replace with function body.
