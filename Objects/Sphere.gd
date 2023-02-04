extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var oretype=0
var damage=0
var movespeed=2
var target = null

var xdistance = 0
var zdistance = 0

var startx = null
var startz = null

var deltamodloc = null
# Called when the node enters the scene tree for the first time.
var bulletparent = ""
func _ready():
	deltamodloc = get_node("../../")
	if(is_instance_valid(target)):
		var targetx = target.transform.origin.x
		var targetz = target.transform.origin.z
		xdistance=abs(transform.origin.x-targetx)/10
		zdistance=abs(transform.origin.z-targetz)/10
		scale.x=0.3
		scale.y=0.3
		scale.z=0.3
	else:
		self.queue_free()
	startx = transform.origin.x
	startz = transform.origin.z
	if(bulletparent == "King"):
		$Brock_bullet.visible=true
	elif(bulletparent == "Archer"):
		$Celly_bullet.visible=true
	elif(bulletparent == "Wizard"):
		$Pitch_bullet.visible=true
	else:
		$Sphere.visible=true



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(is_instance_valid(target)):
		var targetx = target.transform.origin.x
		var targetz = target.transform.origin.z
		if(abs((startx-(targetx))/2)<abs(startx-transform.origin.x)):
			transform.origin.y-=(3*delta*deltamodloc.get_deltamod())
		else:
			transform.origin.y+=(3*delta*deltamodloc.get_deltamod())
		if(abs(transform.origin.x-targetx)<0.3 and abs(transform.origin.z-targetz)<0.3):
			target.take_damage(damage)
			self.queue_free()
		var totaldistance = xdistance + zdistance
		if(transform.origin.x<targetx):
			transform.origin=transform.origin+Vector3((xdistance/totaldistance)*movespeed*(delta*deltamodloc.get_deltamod()),0,0)
		elif(transform.origin.x>targetx):
			transform.origin=transform.origin-Vector3((xdistance/totaldistance)*movespeed*(delta*deltamodloc.get_deltamod()),0,0)
		if(transform.origin.z<targetz):
			transform.origin=transform.origin+Vector3(0,0,(zdistance/totaldistance)*movespeed*(delta*deltamodloc.get_deltamod()))
		elif(transform.origin.z>targetz):
			transform.origin=(transform.origin-Vector3(0,0,(zdistance/totaldistance)*movespeed*(delta*deltamodloc.get_deltamod())))
	else: 
		self.queue_free()
	
	#if(target.get_global_transform().x<get_global_transform().x):
	#	set_global_transform().x+=get_global_transform().x
	#transform.basis=transform.basis+(vector3(cos(transform.rotation.x),sin(transform.rotation.y),0)*movespeed)
