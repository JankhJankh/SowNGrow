extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var oretype=0
var damage=0
var movespeed=2

var targetx = null
var targetz = null

var xdistance = 0
var zdistance = 0

var startx = null
var startz = null

var daddy = null
var deltamodloc = null
# Called when the node enters the scene tree for the first time.

var shovex = 0
var shovey = 0

func _ready():
	deltamodloc = get_node("../../")
	xdistance=abs(transform.origin.x-targetx)/10
	zdistance=abs(transform.origin.z-targetz)/10
	scale.x=1
	scale.y=1
	scale.z=1
	#targetx = 1
	#targetz = 1
	shovex = randi()%150+25
	shovey = randi()%150+25

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Spatial/seed.rotation_degrees.x+=delta*shovex
	$Spatial/seed.rotation_degrees.y+=delta*shovey
	if(abs((startx-(targetx))/2)<abs(startx-transform.origin.x)):
		pass
		transform.origin.y-=(3*delta*deltamodloc.get_deltamod())
	else:
		pass
		transform.origin.y+=(3*delta*deltamodloc.get_deltamod())
	if(abs(transform.origin.x-targetx)<1 and abs(transform.origin.z-targetz)<1):
		if(is_instance_valid(daddy)==true):
			daddy.seed_landed()
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
