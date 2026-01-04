@tool
extends StaticBody2D

enum Items {barrelBlack_side, barrelBlack_top, barrelGreen_side,
			barrelGreen_top, barrelRed_side, barrelRed_top, barrelRust_side,
			barrelRust_top, barricadeMetal, barricadeWood, fenceRed, fenceYellow,
			sandbagBeige, sandbagBeige_open, sandbagBrown, sandbagBrown_open,
			treeBrown_large, treeBrown_small, treeGreen_large, treeGreen_small}

var regions = {
	Items.barrelBlack_side: Rect2(532, 90, 56, 40),
	Items.barrelBlack_top: Rect2(220, 89, 48, 48),
	Items.barrelGreen_side: Rect2(476, 90, 56, 40),
	Items.barrelGreen_top: Rect2(220, 137, 48, 48),
	Items.barrelRed_side: Rect2(420, 94, 56, 40),
	Items.barrelRed_top: Rect2(172, 89, 48, 48),
	Items.barrelRust_side: Rect2(588, 90, 56, 40),
	Items.barrelRust_top: Rect2(172, 137, 48, 48),
	Items.barricadeMetal: Rect2(532, 130, 56, 56),
	Items.barricadeWood: Rect2(72, 130, 56, 56),
	Items.fenceRed: Rect2(336, 443, 32, 96),
	Items.fenceYellow: Rect2(216, 550, 32, 104),
	Items.sandbagBeige: Rect2(164, 282, 44, 64),
	Items.sandbagBeige_open: Rect2(518, 350, 55, 84),
	Items.sandbagBrown: Rect2(622, 278, 44, 64),
	Items.sandbagBrown_open: Rect2(596, 450, 55, 84),
	Items.treeBrown_large: Rect2(0, 654, 128, 128),
	Items.treeBrown_small: Rect2(694, 118, 72, 72),
	Items.treeGreen_large: Rect2(128, 654, 128, 128),
	Items.treeGreen_small: Rect2(694, 190, 72, 72)
}

@export var type: Items = Items.barrelBlack_side:
	set(value):
		type = value
		_update_type()

func _ready():
	if Engine.is_editor_hint():
		# Update in editor
		_update_type()
	elif is_node_ready():
		# Update in game
		_update_type()
	else:
		# Wait for node to be ready if called before _ready()
		await ready
		_update_type()

func _update_type():
	if not is_inside_tree():
		return
	
	if has_node("Sprite2D"):
		$Sprite2D.region_rect = regions[type]
		
		var rect = RectangleShape2D.new()
		rect.size = $Sprite2D.region_rect.size
		
		if has_node("CollisionShape2D"):
			$CollisionShape2D.shape = rect
