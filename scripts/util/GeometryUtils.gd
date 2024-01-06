class_name GeometryUtils


static func look_at_rotation_rad(direction: Vector2)->float:
	return atan2(direction.x, direction.y)
