extends Node
class_name IRespawnable

func _init()->void: InterfaceUtils.report_interface_instantiated_error(self, IRespawnable)

func is_respawn_point_set()->bool: return InterfaceUtils.report_not_implemented_error(is_respawn_point_set)
func set_respawn_point(point: Node2D)->void: InterfaceUtils.report_not_implemented_error(set_respawn_point)

func respawn()->void: InterfaceUtils.report_not_implemented_error(respawn)
