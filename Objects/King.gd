extends Spatial

var time = 0
var tick = 0
var direction = 1

var health = 30
var maxHealth = 10

var shootDirection = 0
var attackspeed = 6
var shootimer = 0
var shootrange = 100

var maxrange = 0.2
var shotdmg = 0

var target = null
var target_distance = 9999
var throw_target = null
var throw_target_distance = 9999

onready var line = $Line2D
onready var orb = preload("res://Objects/Sphere.tscn")
onready var growseed = preload("res://Objects/GrowSeed.tscn")

var redTeam = false

var grown = false
var growtime = 5
var growtimer = 0

var idlecheck = 0
var idleflag = false

var deltamodloc = null

var activated = false

var animator = null
var animationTree = null

var target_rotation = null

var queuedX = null
var queuedY = null

var seedlanded = true

var seedinflight = false

var pacifist = true

var diecheck = false
var landcheck = false

var waittime=0
var waitbool = false

var firstshot = true


var attackanimationspeed = 0
var dieanimationspeed = 0
var growanimationspeed = 0

func _ready():

	deltamodloc = get_node("../")
	$KingBody.visible=false
	randomize()
	#$KingBody.scale.x=0
	#$KingBody.scale.y=0
	#$KingBody.scale.z=0
	$KingBody/ModelRotator/Brock.visible=false #King
	$KingBody/ModelRotator/Celly.visible=false #Knight
	$KingBody/ModelRotator/Cat.visible=false #Archer
	$KingBody/ModelRotator/Pitch.visible=false #Wizard
	if("King" in name):
		maxrange = 0.6
		health = 50
		shotdmg = 3
		growtime = 3
		$Label3D.text="King"
		$KingBody/ModelRotator/Brock.name="Model"
		attackanimationspeed = 2.7
		dieanimationspeed = 0
		growanimationspeed = 0
	if("Wizard" in name): #PITCH
		maxrange = 1.4
		health = 20
		shotdmg = 10
		growtime = 18
		$Label3D.text="Wizard"
		$KingBody/ModelRotator/Pitch.name="Model"
		attackanimationspeed = 1.04
	if("Archer" in name):  #CAT
		maxrange = 1
		health = 40
		shotdmg = 3
		growtime = 9
		$Label3D.text="Archer"
		$KingBody/ModelRotator/Cat.name="Model"
		attackanimationspeed = 2.08
		dieanimationspeed = 0.83
		growanimationspeed = 2.5
	if("Knight" in name): #Celly
		maxrange = 0.6
		health = 80
		shotdmg = 5
		growtime = 6
		$Label3D.text="Knight"
		$KingBody/ModelRotator/Celly.name="Model"
		attackanimationspeed = 2.08
		dieanimationspeed = 0.83
		growanimationspeed = 2.5
	$KingBody/ModelRotator/Model.visible=true
	if(is_instance_valid($KingBody/ModelRotator/Brock)):
		pass
		#$KingBody/ModelRotator/Brock.queue_free()
	if(is_instance_valid($KingBody/ModelRotator/Celly)):
		pass
		#$KingBody/ModelRotator/Celly.queue_free()
	if(is_instance_valid($KingBody/ModelRotator/Cat)):
		pass
		#$KingBody/ModelRotator/Cat.queue_free()
	if(is_instance_valid($KingBody/ModelRotator/Pitch)):
		pass
		#$KingBody/ModelRotator/Pitch.queue_free()
	animator = $KingBody/ModelRotator/Model/AnimationPlayer
	animationTree = $KingBody/ModelRotator/Model/AnimationTree
	growtime += float((randi() % 20) / float(10))
	if("Red" in name):
		redTeam=true
	if(redTeam):
		pass 
		#$KingBody/ModelRotator/Model/BroccoliArm/Skeleton/IcosphereRed.visible=true
		#$KingBody/RedMesh.visible=true
	else:
		pass
		#$KingBody/ModelRotator/Brock/BroccoliArm/Skeleton/Icosphere.visible=true
		#$KingBody/BlueMesh.visible=true
	$KingBody/Spinner.scale.x=maxrange
	$KingBody/Sitedisk.scale.x=maxrange*10
	$KingBody/Sitedisk.scale.z=maxrange*10
	$HP.text = "HP: " + str(health)
	#animator.play("Grow")
	growtimer=growtime-3.5
	animator.playback_speed = 2.5/growtime
	if("Blue" in name):
		animationTree.set("parameters/ts/scale", 3)
	else:
		animationTree.set("parameters/ts/scale", 3)
	#animationTree.set("parameters/Grow/active", true)
	#visible=true
	

func _process(delta):
	if(waitbool):
		if(waittime > 1):
			show_grow()
			waitbool=false
		else:
			waittime+=(delta)
	if(grown==false):
		if(pacifist==false or firstshot):
			if(firstshot==false):
				activated=false
			if(growtimer<growtime and seedlanded):
				if(firstshot):
					growtimer+=(delta*deltamodloc.get_deltamod()*2)
				else:
					growtimer+=(delta*deltamodloc.get_deltamod())
				#$KingBody.scale.x=(growtimer/growtime)
				#$KingBody.scale.y=(growtimer/growtime)
				#$KingBody.scale.z=(growtimer/growtime)
			else:
				if(redTeam == false and firstshot==true):
					throw_seed((randi()%20)-10,(randi()%20)-22)
					firstshot=false
					get_node("../").spawn_player_unit()
					get_node("../").redturn=true
				grown=true
				seedlanded=false
	else:
		if(pacifist==false or firstshot):
			if(Input.is_action_pressed("ui_leftclick")):
				if(activated==true):
					var tempmaxrange = maxrange
					if(firstshot):
						maxrange=2.5
						get_node("../").redturn=false
					#$KingBody/Sitedisk.visible=true
					$KingBody/Spinner.visible=true
					$KingBody/Slingshot.visible=true
					var throwtarget = get_node("../").selected
					var angel = rad2deg(Vector2(-(throwtarget.transform.origin.x - transform.origin.x), throwtarget.transform.origin.z - transform.origin.z).angle())
					$KingBody/Slingshot.rotation_degrees.y=angel
					var distancex = (throwtarget.transform.origin.x - transform.origin.x)
					var distancez = (throwtarget.transform.origin.z - transform.origin.z)
					if(abs(distancex) > maxrange*10):
						if(distancex>0):
							distancex = (maxrange*10)
						else:
							distancex = (maxrange*-10)
					if(abs(distancez) > maxrange*10):
						if(distancez>0):
							distancez = (maxrange*10)
						else:
							distancez = (maxrange*-10)
					$KingBody/Slingshot.scale.x=sqrt(distancex*distancex + distancez*distancez)#/1.4
					$KingBody/Slingshot.scale.z=sqrt(distancex*distancex + distancez*distancez)#/1.4
					$KingBody/Slingshot.scale.y=sqrt(distancex*distancex + distancez*distancez)/3#/1.4
					var a = sqrt(distancex*distancex + distancez*distancez)/1.4
					var b = maxrange*10
					var c = a/b
					var d = c*60
					$KingBody/ModelRotator.rotation_degrees.y=angel
					$KingBody/ModelRotator/Model.rotation_degrees.x=(-d)
					maxrange=tempmaxrange
			else:
				if(activated):
					var tempmaxrange = maxrange
					if(firstshot):
						get_node("../").spawn_enemy_unit()
						firstshot=false
						maxrange=2.5
					$KingBody/ModelRotator/Model.rotation_degrees.x=0
					$KingBody/Slingshot.visible=false
					var angle = $KingBody/Spinner.rotation_degrees.y
					var throwtarget = get_node("../").selected
					var distancex = (throwtarget.transform.origin.x - transform.origin.x)
					var distancez = (throwtarget.transform.origin.z - transform.origin.z)
					if(abs(distancex) > maxrange*10):
						if(distancex>0):
							distancex = (maxrange*10)
						else:
							distancex = (maxrange*-10)
					if(abs(distancez) > maxrange*10):
						if(distancez>0):
							distancez = (maxrange*10)
						else:
							distancez = (maxrange*-10)
					var dirx = (-distancex)
					var dirz = (-distancez)
					#var yeetdirection = Vector2(cos(deg2rad(angle)), sin(deg2rad(angle)))
					#var a = yeetdirection.x
					#var b = yeetdirection.y
					#var dirx = yeetdirection.x*maxrange*(randi()%4+8)
					#var dirz = yeetdirection.y*(-1)*maxrange*(randi()%4+8)
					throw_seed(dirx,dirz)
					#throw_seed(2,0)
					maxrange=tempmaxrange
				activated=false
				#$KingBody/Sitedisk.visible=false
				$KingBody/Spinner.visible=false
			$KingBody/Spinner.rotation_degrees.y+=(180*(delta*deltamodloc.get_deltamod()))
			if(is_instance_valid(target)):
				pass
				#$KingBody/ModelRotator.rotation_degrees.y=target_rotation
				#if(rad2deg($KingBody/ModelRotator.rotation_degrees.y)<target_rotation+1):
				#	#$KingBody/ModelRotator.rotation_degrees.y=target_rotation
				#	$KingBody/ModelRotator.rotation_degrees.y+=(180*(delta*deltamod))
				#elif(rad2deg($KingBody/ModelRotator.rotation_degrees.y)>target_rotation-1):
				#	#$KingBody/ModelRotator.rotation_degrees.y=target_rotation
				#	$KingBody/ModelRotator.rotation_degrees.y-=(180*(delta*deltamod))
			if(idlecheck>3 and redTeam==false):
				if(is_instance_valid(throw_target) and seedinflight == false):
					ai_throw_seed(throw_target)
				else:
					idlecheck=0
			else:
				if(is_instance_valid(target)==false):
					idlecheck+=(delta*deltamodloc.get_deltamod())
					if(idlecheck>1.5 and idleflag == false):
						#animator.play("Idle")
						#animator.playback_speed=1
						idleflag = true
				var targetFound = false
				var newtarget = null
				if($KingBody/Spinner/RayCast.is_colliding()==true):
					var collider = $KingBody/Spinner/RayCast.get_collider()
					if(is_instance_valid(collider)):
						if("KingBody" in collider.name):
							newtarget=collider.get_parent()
							if(newtarget.redTeam!=redTeam and newtarget.grown == true):
								targetFound=true
						else:
							pass
				if(targetFound==true):
					if(newtarget.transform.origin.distance_to(transform.origin) < target_distance):
						target_distance = newtarget.transform.origin.distance_to(transform.origin)
						target = newtarget
						target_rotation=$KingBody/Spinner.rotation_degrees.y
						$KingBody/ModelRotator.rotation_degrees.y=$KingBody/Spinner.rotation_degrees.y
				if(is_instance_valid(target) and target.grown==true):
					if(shootimer>(attackspeed)):
						shootimer=0
						shoot(target)
					else:
						shootimer+=((delta*deltamodloc.get_deltamod()))
				else:
					var target = null
					target_distance = 9999
				if($KingBody/Spinner/ThrowRayCast.is_colliding()==true):
					var collider = $KingBody/Spinner/ThrowRayCast.get_collider()
					if(is_instance_valid(collider)):
						if("KingBody" in collider.name):
							newtarget=collider.get_parent()
							if(newtarget.redTeam!=redTeam and newtarget.grown == true):
								targetFound=true
						else:
							pass
				if(targetFound==true):
					if(newtarget.transform.origin.distance_to(transform.origin) < throw_target_distance):
						throw_target_distance = newtarget.transform.origin.distance_to(transform.origin)
						throw_target = newtarget
						if(is_instance_valid(target)==false):
							pass
							#$KingBody/ModelRotator.rotation_degrees.y=$KingBody/Spinner.rotation_degrees.y
				if(is_instance_valid(target)  and target.grown==true):
					pass
				else:
					var throw_target = null
					throw_target_distance = 9999
			if(is_instance_valid(throw_target)==false):
				pass
				target_rotation=$KingBody/Spinner.rotation_degrees.y
				#$KingBody/ModelRotator.rotation_degrees.y=$KingBody/Spinner.rotation_degrees.y

func shoot(target):
	#animator.play("Attack")
	animationTree.set("parameters/ts/scale", 1)
	animationTree.set("parameters/Attack/active", true)
	animator.playback_speed=2

func attack():
	var instance = orb.instance()
	instance.movespeed = 10
	instance.target = target
	instance.damage = shotdmg
	instance.set_global_transform(get_global_transform())
	if("Knight" in name):
		instance.bulletparent = ""
	if("King" in name):
		instance.bulletparent = "King"
	if("Archer" in name):
		instance.bulletparent = "Archer"
	if("Wizard" in name):
		instance.bulletparent = "Wizard"
	instance.scale.x=0.5
	instance.scale.y=0.5
	instance.scale.z=0.5
	var angel = rad2deg(Vector2(-(target.transform.origin.x - transform.origin.x), target.transform.origin.z - transform.origin.z).angle())
	instance.rotation_degrees.y=angel

	get_node("../Orbs").add_child(instance)

func show_grow():
	$KingBody.visible=true

func die():
	diecheck = true
	if(queuedX!=null):
		$KingBody.visible=false
	elif(health<=0):
		self.queue_free()
	if(landcheck and diecheck):
		startgrow()

func take_damage(damage):
	health-=damage
	if(health<=0):
		health=0
		#animator.play("Die")
		animationTree.set("parameters/ts/scale", 1)
		animationTree.set("parameters/Die/active", true)
		animator.playback_speed=1
	else:
		pass
		#animator.play("Hurt")
		#animationTree.set("parameters/Hurt/active", true)
		animationTree.set("parameters/ts/scale", 1)
		animator.playback_speed=1
	$HP.text = "HP: " + str(health)

func ai_throw_seed(throw_target):
	var start = Vector2(transform.origin.x,transform.origin.z)
	var end = Vector2(throw_target.transform.origin.x,throw_target.transform.origin.z)
	var yeetdirection = Vector2(end.x, end.y) - Vector2(start.x, start.y)
	var dirx = yeetdirection.x*((maxrange*((randi()%40+80)/float(100))))
	var dirz = yeetdirection.y*((maxrange*((randi()%40+80)/float(100))))
	throw_seed(dirx,dirz)
	seedinflight=true

func throw_seed(dirx, dirz):
	grown = false
	growtimer = 0
	idlecheck = 0
	idleflag = false
	target=null
	#animator.play("Grow")
	queuedX = dirx
	queuedY = dirz
	animationTree.set("parameters/ts/scale", 1)
	animationTree.set("parameters/Die/active", true)
	animator.playback_speed=1
	var instance = growseed.instance()
	instance.targetx = transform.origin.x+dirx
	instance.targetz = transform.origin.z+dirz
	instance.startx = transform.origin.x
	instance.startz = transform.origin.z
	instance.movespeed = 8
	instance.transform.origin.x=transform.origin.x
	instance.transform.origin.z=transform.origin.z
	instance.transform.origin.y=transform.origin.y
	instance.daddy = self
	#instance.set_global_transform(get_global_transform())
	get_node("../Orbs").add_child(instance)

func _on_KingBody_input_event(camera, event, position, normal, shape_idx):
	if(redTeam):
		var mouse_click = event as InputEventMouseButton
		if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed:
			activated=true

func _on_KingBody_mouse_entered():
	if(activated):
		$KingBody/Sitedisk.visible=false
	else:
		$KingBody/Sitedisk.visible=true
	activated=false
	$KingBody/Slingshot.visible=false

func _on_KingBody_mouse_exited():
	$KingBody/Sitedisk.visible=false

func get_unit_locations():
	var locations = []
	var board = get_node("../")
	for i in board.get_children():
		if("Blue" in i.name or "Red" in i.name):
			locations.append(Vector2(i.transform.origin.x, i.transform.origin.z))
	return(locations)

func seed_landed():
	landcheck = true
	if(landcheck and diecheck):
		startgrow()

func grow_animation():
	animationTree.set("parameters/ts/scale", 2.5/growtime)
	animationTree.set("parameters/SGTS/scale", 1)
	animator.playback_speed = 2.5/growtime

func fast_grow():
	animator.playback_speed = 3

func startgrow():
	diecheck = false
	landcheck = false
	grown = false
	growtimer = 0
	seedinflight=false
	idlecheck = 0
	idleflag = false
	if(pacifist==false):
		animationTree.set("parameters/ts/scale", 2.5/growtime)
		animationTree.set("parameters/Grow/active", true)
		animator.playback_speed = 2.5/growtime
	else:
		#animationTree.set("parameters/ts/scale", 2.5/growtime)
		animationTree.set("parameters/FirstGrow/active", true)
		waitbool = true
		#animator.playback_speed = 2.5/growtime
	#$KingBody.scale.x=0
	#$KingBody.scale.y=0
	#$KingBody.scale.z=0
	var yeet = transform.origin
	var testloc = Vector2(transform.origin.x, transform.origin.z) + Vector2(queuedX, queuedY)
	var mapheight = get_node("../").mapheight
	var mapwidth = get_node("../").mapwidth
	if(testloc.x<(-mapheight)):
		testloc.x=(-mapheight)
	elif(testloc.x>(mapheight)):
		testloc.x=(mapheight)
	if(testloc.y<(-mapwidth)):
		testloc.y=(-mapwidth)
	elif(testloc.y>(mapwidth)):
		testloc.y=(mapwidth)
	#transform.origin.x=(int(transform.origin.x*10))/10
	#transform.origin.z=(int(transform.origin.z*10))/10
	var roundingsize = 2
	testloc.x=(int(testloc.x/roundingsize))*roundingsize#*100)/10
	testloc.y=(int(testloc.y/roundingsize))*roundingsize#*100)/10
	var locations = get_unit_locations()
	var dupes = false
	for i in locations:
		if(i == testloc):
			dupes=true
	print(dupes)
	if(dupes==false):
		transform.origin.x=testloc.x
		transform.origin.z=testloc.y
	else:
		var testx = 0
		var testy = 0
		var a = [1,0,-1,-1,0,0,1,1,1,0,0,0,-1,-1,-1,-1,0,0,0,0]
		var b = [0,1,0,0,-1,-1,0,0,0,1,1,1,0,0,0,0,-1,-1,-1,-1]
		var ctr = 0
		while(dupes==true):
			if(ctr==20):
				self.queue_free()
			testloc.x += (a[ctr]*roundingsize)
			testloc.y += (b[ctr]*roundingsize)
			dupes=false
			for i in locations:
				if(i == testloc):
					dupes=true
			if(dupes==false):
				transform.origin.x=testloc.x
				transform.origin.z=testloc.y
				break
			ctr+=1
	queuedX = null
	queuedY = null
	seedlanded = true
