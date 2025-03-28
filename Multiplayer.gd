extends Node2D

const PLAYER1 = preload("res://Scenes/player_1.tscn")
const PLAYER2 = preload("res://Scenes/player_2.tscn")
var peer = ENetMultiplayerPeer.new()

func _ready():
	Global.hud_ref = $CanvasLayer #global var to hide canvas

func _on_host_pressed():
	peer.create_server(25565)
	multiplayer.multiplayer_peer = peer
	%Multiplayer.hide()
	$UI2/Multiplayer.hide()
	multiplayer.peer_connected.connect(func(pid):
		print("Peer " + str(pid) + " has joined!")

		# send info of all players to all peers
		for p in get_tree().get_nodes_in_group("players"):
			rpc_id(pid, "add_existing_player", int(p.name), p.is_in_group("thieves"))

		# assign role
		rpc_id(pid, "request_player_spawn", pid)
	)

	# spawn players for host
	add_player1(multiplayer.get_unique_id())
	add_player2(multiplayer.get_unique_id())

func _on_join_pressed():
	peer.create_client("localhost", 25565)  #localhost ip (to change if needed)
	multiplayer.multiplayer_peer = peer
	%Multiplayer.hide()
	$UI2/Multiplayer.hide()
	await get_tree().process_frame
	rpc_id(1, "request_player_spawn", multiplayer.get_unique_id())

@rpc("authority", "call_remote")
func request_player_spawn(pid):
	# no dupli
	if get_node_or_null(str(pid)):
		print("Player", pid, "already exists, skipping spawn.")
		return
	
	# assign 1 or 2
	if get_tree().get_nodes_in_group("players").size() == 0:
		rpc_id(pid, "add_player1", pid)
	else:
		rpc_id(pid, "add_player2", pid)

@rpc("any_peer", "call_local")
func add_player1(pid):
	if get_node_or_null(str(pid)):
		return
	
	var player1 = PLAYER1.instantiate()
	player1.name = str(pid)
	player1.add_to_group("players")
	player1.add_to_group("thieves")
	player1.set_multiplayer_authority(pid)  # correct authority is set

	var spawn_point = $TileMap/SpawnPoint.position if $TileMap.has_node("SpawnPoint") else Vector2.ZERO
	player1.position = spawn_point
	add_child(player1, true)

	print("Spawned Player1 with ID:", pid, "at", spawn_point)

@rpc("any_peer", "call_local")
func add_player2(pid):
	if get_node_or_null(str(pid)):
		return
	
	var player2 = PLAYER2.instantiate()
	player2.name = str(pid)
	player2.add_to_group("players")
	player2.add_to_group("thieves")
	player2.set_multiplayer_authority(pid)  # correct authority is set

	var spawn_point2 = $TileMap/PoliceSpawn.position if $TileMap.has_node("PoliceSpawn") else Vector2.ZERO
	player2.position = spawn_point2
	add_child(player2, true)

	# make players see each other
	rpc_id(1, "sync_player2_for_player1", pid, player2.position)

	print("Spawned Player2 with ID:", pid, "at", spawn_point2)

@rpc("authority", "call_local")
func add_existing_player(pid, is_thief):
	if get_node_or_null(str(pid)):
		return  # prevent duplicate spawns

	var player
	if is_thief:
		player = PLAYER1.instantiate()
	else:
		player = PLAYER2.instantiate()

	player.name = str(pid)
	player.add_to_group("players")
	player.set_multiplayer_authority(pid)

	var spawn_position = $TileMap/SpawnPoint.position if is_thief else $TileMap/PoliceSpawn.position
	player.position = spawn_position

	add_child(player, true)

	print("Added existing player with ID:", pid, "Thief:", is_thief)

#Player2 is synced with Player1's screen
@rpc("any_peer", "call_local")
func sync_player2_for_player1(pid, player2_position):
	var player2 = PLAYER2.instantiate()
	player2.name = str(pid)
	player2_position = $TileMap/PoliceSpawn.position if $TileMap.has_node("PoliceSpawn") else Vector2.ZERO
	player2.position = player2_position  # position provided from Player2 spawn
	player2.add_to_group("players")
	player2.add_to_group("thieves")
	player2.set_multiplayer_authority(pid)  # Player1 sees Player2 as an authority
	
	add_child(player2, true)

	print("Synced Player2 with ID:", pid, "at", player2_position)
