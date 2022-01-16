extends Node2D

const DEFAULT_IP = '69.181.251.248'
const DEFAULT_PORT = 9999
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerNode = preload("res://Player.tscn")

var playerNick = ""

var currentOverrideTile = 1
var currX = 640
var currY = 440

const tile = preload("res://Tile.tscn")
const word = preload("res://Word.tscn")

var tileDictionary = {}


func JoinLobby(ip):
# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, '_connected_to_server')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(peer)
	
func _connected_to_server():
	rpc_id(1, 'createPlayer', playerNick ,get_tree().get_network_unique_id())
	
remote func initializePlayer(name):
	var newPlayer = playerNode.instance()
	newPlayer.get_node("Name").text = name
	if name == playerNick:
		newPlayer.position = Vector2(700, 400)
		newPlayer.get_node("Name").align = 2
		newPlayer.get_node("Name").set("custom_colors/font_color", Color("#5da9e9"))
	else:
		newPlayer.position = Vector2(-700, 400)
		newPlayer.get_node("Name").align = 0
		newPlayer.get_node("Name").set("custom_colors/font_color", Color("#ff6e6e"))
	newPlayer.z_index = 100
	add_child(newPlayer)
	
remote func pluck(letter, id):
	var newTile = tile.instance()
	newTile.tileLetter = letter
	newTile.position = Vector2(960, 420)
	newTile.scale = Vector2(0.25, 0.25)
	newTile.tileID = id
	tileDictionary[id] = newTile
	var board = get_node("../Playspace/Board")
	var tileCoords = board.placeTile(newTile)
	if !(tileCoords):
		var firstKey
		var count = 1
		for key in board.tileSlots:
			if count < currentOverrideTile:
				count += 1
				continue
			firstKey = key
			if currentOverrideTile < 8:
				currentOverrideTile += 1
			else:
				currentOverrideTile = 1
			break
		board.replaceTile(firstKey, newTile)
	else:
		currentOverrideTile = 1
		board.lettersInPlay.append(newTile.tileLetter)
		#print($Board.lettersInPlay)
		board.add_child(newTile)
		var tween = newTile.get_node("Tween")
		tween.interpolate_property(newTile, "position", Vector2(960, 420), tileCoords, 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.interpolate_property(newTile, "scale", Vector2(0.25, 0.25), Vector2(0.5, 0.5), 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
		get_node("../Playspace/WordBag").updateTileCount(-1)
		var lettersOut = []
	get_node("../Playspace/TileSound").play()
#		for tile in $Board.get_children():
#			if !(tile is Node2D):
#				continue
#			lettersOut.append(tile.tileLetter)
#		for word in $PlayerWords.get_children():
#			word.calculateNextPlays(lettersOut, scrabbleWords)
#		for word in $ComputerWords.get_children():
#			if word is Timer:
#				continue
#			word.calculateNextPlays(lettersOut, scrabbleWords)
#
#		$ComputerWords.calculatePlays()
	
	pass # Replace with function body.
	
remote func clearLineEdit():
	get_node("../Playspace/LineEdit").text = ""
	
remote func lineEditInvalid(invalid):
	if invalid:
		get_node("../Playspace/LineEdit").invalid()
	else:
		get_node("../Playspace/LineEdit").unformable()
	
remote func removeTileFromBoard(tileID):
	var board = get_node("../Playspace/Board")
	for key in board.tileSlots:
		if board.tileSlots[key] != null:
			if board.tileSlots[key].tileID == tileID:
				board.tileSlots[key] = null
				break
			
remote func addWord(playerName, tileIDArray, new_text):
	
	var newWord = word.instance()
	newWord.word = new_text
	newWord.position.x = 960 - (new_text.length() * 25) + 25
	newWord.position.y = 540
	
	for id in tileIDArray:
		if tileDictionary[id] == null:
			continue
		tileDictionary[id].get_parent().remove_child(tileDictionary[id])
		get_node("../Playspace/Board").removeTile(tileDictionary[id])
		#$Board.lettersInPlay.remove(tileDictionary[id].tileLetter)
		newWord.add_child(tileDictionary[id])
	
	var tileArray = []
	for id in tileIDArray:
		tileArray.append(tileDictionary[id])
		
	if playerNick == playerName:
		get_node("../Playspace/PlayerWords").add_child(newWord)
		get_node("../Playspace/PlayerWords").addWord(tileArray)
	else:
		get_node("../Playspace/ComputerWords").add_child(newWord)
		get_node("../Playspace/ComputerWords").addWord(tileArray)
	get_node("../Playspace/WordForm").play()

remote func removePlayerWord(wordToRemove, playerName):
	if playerName == playerNick:
		print(get_node("../Playspace/PlayerWords").get_children())
		for child in get_node("../Playspace/PlayerWords").get_children():
			print(child.word, " vs ", wordToRemove)
			if child.word == wordToRemove:
				print("removing ", child.word, " from ", playerName)
				get_node("../Playspace/PlayerWords").remove_child(child)
	else:
		print(get_node("../Playspace/ComputerWords").get_children())
		for child in get_node("../Playspace/ComputerWords").get_children():
			print(child.word, " vs ", wordToRemove)
			if child.word == wordToRemove:
				print("removing ", child.word, " from ", playerName)
				get_node("../Playspace/ComputerWords").remove_child(child)

remote func arrangeWords():
	get_node("../Playspace/PlayerWords").arrangeWords()
	get_node("../Playspace/ComputerWords").arrangeWords()
	
func sendWord(word):
	rpc_id(1, 'wordEntered', word, Server.playerNick, get_tree().get_network_unique_id())
	
func removeTileFromServerBoard(tileID):
	rpc_id(1, 'removeTile', tileID)
# Called when the node enters the scene tree for the first time.
func reinsertLetterToServerBag(letter):
	rpc_id(1, 'reinsertLetter', letter.tileLetter, playerNick)


remote func gameOver():
	if get_node("../Playspace/PlayerScore").tileCount > get_node("../Playspace/OppScore").tileCount:
		Global.winner = 'P'
	elif get_node("../Playspace/OppScore").tileCount > get_node("../Playspace/PlayerScore").tileCount:
		Global.winner = 'O'
	else:
		Global.winner = 'T'
		
	for child in get_children():
		remove_child(child)
		child.queue_free()
		
	get_tree().change_scene("res://GameOverMultiplayer.tscn")
	
remote func kicked():
	get_tree().network_peer = null
	
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
