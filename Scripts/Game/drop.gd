class_name Drop
extends RigidBody2D

static var counter: int = 0

var stack: ItemStack = null

var _sprite: Sprite2D = null
var _trigger_area: Area2D = null

func set_stack(stck: ItemStack):
	stack = stck
	if stck and stck.item:
		_sprite.texture = stck.item.sprite
	else:
		self.queue_free()

@rpc("authority", "call_local")
func delete_self():
	self.queue_free()

func player_detected(area: Area2D):
	if not multiplayer.is_server():
		return
		
	if area.name == "PlayerArea":
		var player: Player = area.get_parent()
		var res: Vector2i = player.inventory.try_grab(stack)
		var remaining: int = res.x
		var slot_idx: int = res.y
		if slot_idx >= 0:
			player.update_inventory.rpc_id(player.id,slot_idx, stack.item.uid, player.inventory.slots[slot_idx].quantity, player.inventory.slots[slot_idx].item_state.encode())
		if remaining <= 0:
			delete_self.rpc()
		else:
			stack.quantity = remaining
		
func _ready() -> void:
	_sprite = get_node("Sprite")
	_trigger_area = get_node("CollisionItem")
	_trigger_area.area_entered.connect(player_detected)
	
func _physics_process(_delta: float) -> void:
	var gravity_angle: float = Vector2.RIGHT.angle_to(self.position)
	var gravity_direction: Vector2 = Vector2(-cos(gravity_angle), -sin(gravity_angle))
	self.apply_force(gravity_direction * 6)
