class_name BasicControlState
extends PlayerController.IControlState


@export var max_speed: int = 450
@export var acceleration : float = 3
@export var jump_force: Vector2 = Vector2(0,-600)
@export var air_control_factor : float = 0.3

@export var jump_press_tolerance_seconds : float = 0.3
@export var climb_speed : float = 10.0;

var rope_prefab = preload("res://prefabs/rope/ShootableRope.tscn")

var base : PlayerController:
	get: return base_controller as RigidBody2D

var _helper_body: AnimatableBody2D
var _helper_joint: PinJoint2D;

func initialize(baseController: PlayerController):
	super.initialize(baseController)
	_helper_body = AnimatableBody2D.new()
	_helper_joint = PinJoint2D.new();
	_helper_body.add_child(_helper_joint)
	base.get_tree().root.add_child(_helper_body)
	_helper_joint.node_a = _helper_body.get_path()

func activate():
	pass

func deactivate():
	handle_rope_drop()
	base.linear_velocity = Vector2.ZERO
	base.angular_velocity = 0

func physics_process(delta):
	handle_rope_stuff(delta)
	handle_basic_movement(delta)
	

var _to_invoke_in_integrate_forces : Array[Callable] = []	
func integrate_forces(state: PhysicsDirectBodyState2D)->void:
	for c in _to_invoke_in_integrate_forces:
		c.call(state);
	_to_invoke_in_integrate_forces.clear()
		
#region BasicMovement
func handle_basic_movement(delta: float)->void:
	if Input.is_action_pressed("Left"):
		move_direction(-max_speed)
	elif Input.is_action_pressed("Right"):
		move_direction(max_speed)
	else:
		move_direction(0)
	handle_jumping(Input.is_action_just_pressed("Jump"))


func move_direction(direction: float)->void:
	if direction != 0: base._to_rotate.scale.x = sign(direction)# base._sprite.flip_h = (direction < 0)
	
	var velocity_direction = direction - base.linear_velocity.x
	var to_apply = Vector2(velocity_direction * acceleration, 0)
	if !is_grounded(): 
		if direction == 0: return
		to_apply *= air_control_factor
	base.apply_force(to_apply * base.mass)
	
	
var _last_jump_request_end : float = -INF
func handle_jumping(jump_was_requested : bool)->void:
	if is_grounded() || (_rope && _rope.is_frozen):
		if jump_was_requested || (_last_jump_request_end > TimeUtils.seconds_elapsed && is_grounded()):
			_last_jump_request_end = -INF
			base.apply_impulse(jump_force*base.mass)
			if !is_grounded():
				handle_rope_drop()
			#print("applying jump {0} - velocity is {1}".format([jump_force, base.linear_velocity]))
	elif jump_was_requested:
		_last_jump_request_end = TimeUtils.seconds_elapsed + jump_press_tolerance_seconds
		

func is_grounded()->bool: return base.is_grounded()
		
#endregion

#region Rope
var _rope : ShootableRopeController;
func handle_rope_stuff(delta: float)->void:
	var mouse_position = base.get_global_mouse_position()
	if !_rope:
		if(Input.is_action_just_pressed("Throw")):
			handle_rope_throw(mouse_position)
	else:
		if(Input.is_action_just_pressed("Drop")):
			handle_rope_drop()
		elif(_rope.is_finished && (Input.is_action_pressed("Throw") || Input.is_action_pressed("Climb"))):
			handle_rope_climb(delta)

func handle_rope_throw(mouse_position: Vector2)->void:
	var connect_to_rope := func (last_segment: RigidBody2D):
		base._hand_joint.node_b = last_segment.get_path()
		
	_rope = rope_prefab.instantiate() as ShootableRopeController;
	base.add_child(_rope);
	_rope.on_hook_hit.connect(connect_to_rope)
	_rope.create_the_rope(base._hand, mouse_position);

func handle_rope_drop()->void:
	if !_rope : return
	base._hand_joint.position = Vector2.ZERO
	base._hand_joint.node_b = NodePath()
	_rope.destroy_self()
	_rope = null
	



func handle_rope_climb(delta:float)->void:
	
	_to_invoke_in_integrate_forces.append(func (state: PhysicsDirectBodyState2D):
		if !_rope: return
		var distance_climbed = climb_speed*delta
		if _rope.progress_the_climb(distance_climbed, 2):
			var new_position = _rope.get_climb_point()
			base.global_position = new_position
			base._hand_joint.node_b = _rope.last_body.get_path()
		#else: handle_rope_drop()
		
		return
		var shift := ((base._hand_joint.get_parent()as Node2D).global_position - _rope.last_body.global_position).normalized() * climb_speed;
		var new_joint_pos := base._hand_joint.global_position + shift * delta
		base.global_position -= shift*delta;
		base._hand_joint.global_position = new_joint_pos
		if base._hand_joint.position.length() >= _rope.segment_length:
			var next := _rope.destroy_last_segment()
			if !next:
				handle_rope_drop()
			else:
				base._hand_joint.position -= base._hand_joint.position.normalized()*_rope.segment_length
				base._hand_joint.node_b = next.get_path()
		print("shift: {0}".format([shift]))
	);
	
	

func _position_climbing(global_pos: Vector2)->void:
	pass

#endregion

