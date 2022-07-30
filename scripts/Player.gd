extends Sprite

export var speed = 150
export var hp = 3

var velocity = Vector2.ZERO
var can_shoot = true
var dead = false

var projectile = preload("res://scenes/Projectile.tscn")

func _ready() -> void:
	Global.player = self

func _exit_tree() -> void:
	Global.player = null

func get_direction(x: String, y: String) -> int:
	return int(Input.is_action_pressed(x)) - int(Input.is_action_pressed(y))

func process_velocity(delta: float) -> void:	
	velocity.x = get_direction('ui_right', 'ui_left')
	velocity.y = get_direction('ui_down', 'ui_up')

	global_position += speed * velocity * delta
	
func control_shoot() -> void:
	if Input.is_action_pressed('shoot') and Global.global_parent and can_shoot:
		Global.instance_node(projectile, global_position)
		can_shoot = false
		$reload_timer.start()

func _process(delta: float) -> void:
	if not dead:
		process_velocity(delta)
		
		control_shoot()

func _on_reload_timer_timeout():
	can_shoot = true

func _on_hitbox_area_entered(area: Area2D):
	if area.is_in_group('enemy'):
		visible = false
		dead = true
		
		$restart_timer.start()

func _on_restart_timer_timeout():
	get_tree().reload_current_scene()