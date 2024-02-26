extends Area2D

@export var Damage: float = 1;

func _body_entered(body: Node2D):
	var damageable := NodeUtils.get_child_of_type(body, Damageable) as Damageable
	if !damageable: return
	damageable.do_damage(Damage);
