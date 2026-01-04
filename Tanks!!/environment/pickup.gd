extends Area2D

enum Items {health,spread} #No add ammo yet?
@export var type = Items.health
@export var amount = Vector2(20,30)
var icon_textures = [preload("res://assets/PickupAssets/wrench_white.png"),preload("res://assets/PickupAssets/Bullet.png")]

func _ready():
	$Icon.texture=icon_textures[type]

func _on_body_entered(body: Node2D) -> void:
	match type:
		Items.health:
			if body.has_method("heal"):
				body.heal(int(randi_range(amount.x,amount.y)))
		Items.spread:
			if body.has_method("spreadshot"):
				body.spreadshot(3)
			# Probably never gonna happen
	var respawn_location = get_point_inside(Vector2(100,100),Vector2(6000,5500))
	set_position(respawn_location)
	# Add respawning code here?
	
func get_point_inside(p1: Vector2, p2: Vector2) -> Vector2:
	var x: float = randf_range(p1.x,p2.x)
	var y: float = randf_range(p1.y,p2.y)
	var random_point = Vector2(x,y)
	return(random_point)
	
