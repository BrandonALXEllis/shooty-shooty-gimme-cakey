extends KinematicBody

#=== feel free to experiment with export varriables {
export var Accelaration:float = 2
export var Speed:float = 10
export var Gravity:float = 9.8
#===}

#=== These vrriables are for input handling {
var up:bool = false
var down:bool = false
var left:bool = false
var right:bool = false
var move:bool = true
#===}

#=== Dont you dare to touch these varriables {}
var direction:Vector3 = Vector3()
var velocity:Vector3 = Vector3()
var gravitational_accelaration = 0
#=== }


onready var mesh = get_node("mesh")


func _input(event):
	if event.is_action_pressed("up"):
		up = true
	if event.is_action_pressed("down"):
		down = true
	if event.is_action_pressed("left"):
		left = true
	if event.is_action_pressed("right"):
		right = true
	
	if event.is_action_released("up"):
		up = false
	if event.is_action_released("down"):
		down = false
	if event.is_action_released("left"):
		left = false
	if event.is_action_released("right"):
		right = false
	calculate_direction()


func calculate_direction():
	direction = Vector3()
	move = false
	if up:
		move = true
		direction.z += 1
	if down:
		move = true
		direction.z -= 1
	if left:
		move = true
		direction.x += 1
	if right:
		move = true
		direction.x -= 1
	direction = direction.normalized()


func _physics_process(delta):#handle wth care this is physics process
	velocity = velocity.linear_interpolate(direction*Speed, Accelaration*Speed*delta)
	move_and_slide(velocity, Vector3.UP)
	
	if is_on_floor():
		gravitational_accelaration = 0
	else:
		gravitational_accelaration -= Gravity*delta
		velocity.y += gravitational_accelaration
	

func _process(delta):
	if move:
		mesh.rotation.y = Vector2(velocity.z,velocity.x).angle()
		run(true)
	else:run(false)


func run(r):
	if r:
		mesh.get_node("AnimationPlayer").play("run")
	else:
		mesh.get_node("AnimationPlayer").play("ideal")
		



