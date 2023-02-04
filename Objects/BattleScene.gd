extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var king = preload("res://Objects/King.tscn")

var mapheight = 20
var mapwidth = 12
var padding = 20
# Called when the node enters the scene tree for the first time.
var setup = true

var selectedx = null
var selectedz = null
var selected = null

var deltamod = 1
onready var clicker = preload("res://Objects/Clicker.tscn")
onready var growseed = preload("res://Objects/GrowSeed.tscn")

var dragging = false
var unitselect = "King"
var gamestarted = false

var current_unit = null

var redturn=true



func _ready():
	randomize()
	for i in range(-mapheight-padding,mapheight+padding):
		for j in range(-mapwidth-padding,mapwidth+padding):
			var instance = clicker.instance()
			instance.transform.origin.x = i
			instance.transform.origin.z = j
			instance.transform.origin.y = 0.1
			instance.xloc=i+mapheight
			instance.zloc=j+mapwidth
			instance.name = "Clicker_"+str(i+mapheight)+"_"+str(j+mapwidth)
			get_node("ClickBox").add_child(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_pressed("ui_leftclick")):
		if(dragging==true and selected.transform.origin.z > 12):
			pass
			#Dragging animation
			$Control/Area2D/Arrow.visible=true
			var throwtarget = selected
			var angel = rad2deg(Vector2((throwtarget.transform.origin.x), throwtarget.transform.origin.z - 13).angle())
			$Control/Area2D/Arrow.rotation_degrees=angel-90
			var distancex = (throwtarget.transform.origin.x - 0)
			var distancez = (throwtarget.transform.origin.z - 13)
			$Control/Area2D/Arrow.scale.x=sqrt(distancex*distancex + distancez*distancez)/30#/1.4
			$Control/Area2D/Arrow.scale.y=sqrt(distancex*distancex + distancez*distancez)/30#/1.4
		else:
			$Control/Area2D/Arrow.visible=false
	else:
		if(dragging and selected.transform.origin.z > 12):
			#Throw
			pass
			$Control/Area2D/Arrow.visible=false
			var throwtarget = selected
			var distancex = (throwtarget.transform.origin.x - 0)
			var distancez = (throwtarget.transform.origin.z - 13)
			#if(distancex > mapwidth-2):
			#	distancex = mapwidth
			#elif(distancex < -mapwidth+2):
			#	distancex = mapwidth
			#if(distancex > mapheight-2):
			#	distancex = mapheight
			#elif(distancex < -mapheight+2):
			#	distancex = mapheight
			#var locations = get_unit_locations()
			#var dupes = false
			#var testx = 0
			#var testy = 0
			#var a = [1,0,-1,-1,0,0,1,1,1,0,0,0,-1,-1,-1,-1,0,0,0,0]
			#var b = [0,1,0,0,-1,-1,0,0,0,1,1,1,0,0,0,0,-1,-1,-1,-1]
			#var ctr = 0
			#var roundingsize = 2
			#while(dupes==true):
			#	distancex += (a[ctr]*roundingsize)
			#	distancez += (b[ctr]*roundingsize)
			#	var testloc = Vector2(distancex,distancez)
			#	dupes=false
			#	for i in locations:
			#		if(i == testloc):
			#			dupes=true
			#	if(dupes==false):
			#		break
			#	ctr+=1
			var dirx = (-distancex)
			var dirz = (-distancez)
			throw_seed(dirx,dirz)
		dragging=false
	if(redturn):
		if($Control/Knight.pressed==true):
			if(is_instance_valid(current_unit)):
				unitselect = "Knight"
				current_unit.queue_free()
				current_unit = spawn_unit("Red"+unitselect, 0, 13)
		elif($Control/Archer.pressed==true):
			if(is_instance_valid(current_unit)):
				unitselect = "Archer"
				current_unit.queue_free()
				current_unit = spawn_unit("Red"+unitselect, 0, 13)
		elif($Control/King.pressed==true):
			if(is_instance_valid(current_unit)):
				unitselect = "King"
				current_unit.queue_free()
				current_unit = spawn_unit("Red"+unitselect, 0, 13)
		elif($Control/Wizard.pressed==true):
			if(is_instance_valid(current_unit)):
				unitselect = "Wizard"
				current_unit.queue_free()
				current_unit = spawn_unit("Red"+unitselect, 0, 13)
		elif($Control/Start.pressed==true):
			if(is_instance_valid(current_unit)):
				current_unit.queue_free()
				for i in get_children():
					if("Blue" in i.name or "Red" in i.name):
						i.grow_animation()
						i.pacifist=false
		if(Input.is_action_pressed("ui_right")):
			deltamod+=1
		if(Input.is_action_pressed("ui_left")):
			deltamod-=1
		if(Input.is_action_pressed("ui_select")):
			if(is_instance_valid(current_unit)):
				for i in get_children():
					if("Blue" in i.name or "Red" in i.name):
						i.grow_animation()
						i.pacifist=false
				current_unit.queue_free()
		#get_tree().paused != get_tree().paused
	if(setup):
		#spawn_unit("RedKing", -((randi() % (mapheight))), ((randi() % (mapwidth*2))-mapwidth))
		#spawn_unit("RedWizard", -((randi() % (mapheight))), ((randi() % (mapwidth*2))-mapwidth))
		current_unit = spawn_unit("RedKing", 0, 13)
		#spawn_unit("RedArcher", -((randi() % (mapheight))), ((randi() % (mapwidth*2))-mapwidth))
		#spawn_unit("RedArcher", -((randi() % (mapheight))), ((randi() % (mapwidth*2))-mapwidth))
		#spawn_unit("RedKnight", -((randi() % (mapheight))), ((randi() % (mapwidth*2))-mapwidth))
		#spawn_unit("RedKnight", -((randi() % (mapheight))), ((randi() % (mapwidth*2))-mapwidth))

		#spawn_unit("BlueKing", ((randi() % (mapheight))), ((randi() % (mapwidth*2))-mapwidth))
		#spawn_unit("BlueWizard", ((randi() % (mapheight))), ((randi() % (mapwidth*2))-mapwidth))
		#spawn_unit("BlueArcher", ((randi() % (mapheight))), ((randi() % (mapwidth*2))-mapwidth))
		#spawn_unit("BlueArcher", ((randi() % (mapheight))), ((randi() % (mapwidth*2))-mapwidth))
		#spawn_unit("BlueKnight", ((randi() % (mapheight))), ((randi() % (mapwidth*2))-mapwidth))
		#spawn_unit("BlueKnight", ((randi() % (mapheight))), ((randi() % (mapwidth*2))-mapwidth))
		#spawn_unit("BlueKnight", ((randi() % (mapheight))), ((randi() % (mapwidth*2))-mapwidth))
		#spawn_unit("BlueKnight", ((randi() % (mapheight))), ((randi() % (mapwidth*2))-mapwidth))
		#spawn_unit("BlueKnight", ((randi() % (mapheight))), ((randi() % (mapwidth*2))-mapwidth))
		#spawn_unit("BlueKnight", ((randi() % (mapheight))), ((randi() % (mapwidth*2))-mapwidth))
		setup=false
	else:
		if(gamestarted):
			var redcount = 0
			var bluecount = 0
			for i in get_children():
				if("Blue" in i.name):
					bluecount+=1
				if("Red" in i.name):
					redcount+=1
			if(redcount==0 and bluecount == 0):
				$Label3D.text="Draw"
				get_tree().paused = true
			elif(redcount==0):
				$Label3D.text="BLUE WINZ"
				get_tree().paused = true
			elif(bluecount==0):
				$Label3D.text="RED WINZ"
				get_tree().paused = true
			

func spawn_unit(unitname, x, z):
	var instance = king.instance()
	instance.name = unitname
	instance.transform.origin.x=x
	instance.transform.origin.z=z
	instance.transform.origin.y=(2)
	instance.queuedX=x
	instance.queuedY=z
	add_child(instance)
	return instance

func get_deltamod():
	return deltamod


func _on_Area2D_mouse_entered():
	dragging=false

func _on_Area2D_mouse_exited():
	pass

func _on_Area2D_input_event(viewport, event, shape_idx):
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed:
		dragging=true
		
func throw_seed(dirx, dirz):
	var instance = growseed.instance()
	instance.targetx = 0+dirx
	instance.targetz = 0+dirz
	instance.startx = 0
	instance.startz = (13)
	instance.movespeed = 8
	instance.transform.origin.x=0
	instance.transform.origin.z=(13)
	instance.transform.origin.y=1
	instance.daddy = spawn_unit("RedKing", dirx, dirz)
	#instance.set_global_transform(get_global_transform())
	get_node("Orbs").add_child(instance)


func seed_landed():
	pass

func get_unit_locations():
	var locations = []
	for i in get_children():
		if("Blue" in i.name or "Red" in i.name):
			locations.append(Vector2(i.transform.origin.x, i.transform.origin.z))
	return(locations)

func spawn_enemy_unit():
	if(len(get_unit_locations())<10):
		current_unit = spawn_unit("Blue"+unitselect, 0, 13)

func spawn_player_unit():
	if(len(get_unit_locations())<10):
		current_unit = spawn_unit("Red"+unitselect, 0, 13)
