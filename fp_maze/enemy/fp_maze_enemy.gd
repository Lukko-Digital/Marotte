extends CharacterBody3D

@export var player : CharacterBody3D
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D

var SPEED = 7

func _physics_process(delta):
	
	nav_agent.target_position = player.position
	
	var path = nav_agent.get_next_path_position()
	
	var step_size = delta * SPEED
	var direction
	
	if path:
		# Direction is the difference between where we are now
		# and where we want to go.
		direction = path - position

		# Move the robot towards the path node, by how far we want to travel.
		# Note: For a KinematicBody, we would instead use move_and_slide
		# so collisions work properly.
		velocity = direction.normalized() * SPEED
		nav_agent.set_velocity_forced(velocity)

	move_and_slide()
