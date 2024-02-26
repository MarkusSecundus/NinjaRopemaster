extends Node
class_name Damageable

@export var MaxHP: float = 100;
@onready var HP:float = MaxHP;

@export var seconds_between_damage : float = 0.3;


var is_dead: bool:
	get: return HP <= 0

signal on_health_update();
signal on_damaged();
signal on_death();

var next_allowed_damage_time : float = -INF;
func do_damage(dmg: float)->void:
	if self.is_dead: return
	if TimeUtils.seconds_elapsed < next_allowed_damage_time: return
	print("{0} damaged for {1} hp".format([name, dmg]));
	_change_hp(-dmg);
	on_damaged.emit();
	next_allowed_damage_time = TimeUtils.seconds_elapsed + seconds_between_damage
	

func _change_hp(to_change: float)->void:
	if self.is_dead: return;
	var new_hp = clampf(HP + to_change, 0, MaxHP);
	
	self.HP = new_hp;
	on_health_update.emit();
	if self.is_dead:
		print("{0} died!".format([name]))
		on_death.emit();
