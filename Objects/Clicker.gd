extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var xloc = 0
var zloc = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("ui_leftclick"):
		pass
		
func _on_Clicker_input_event(camera, event, position, normal, shape_idx):
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed == false:
		pass

func _on_Clicker_mouse_exited():
	#$RedMesh.visible=true
	$BlueMesh.visible=false

func _on_Clicker_mouse_entered():
	$RedMesh.visible=false
	#$BlueMesh.visible=true
	get_node("../../").selectedx=xloc
	get_node("../../").selectedz=zloc
	get_node("../../").selected=self
	#print(xloc-20)
	#print(zloc-12)

