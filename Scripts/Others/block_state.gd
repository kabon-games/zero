class_name BlockState
extends Object

var life: float = 1
var dirty: bool = false
var display_idx: int = 0

func damage(block: BlockData, tool_level: int) -> bool:
	if block.break_level == BlockData.BreakLevel.UNBREAKABLE:
		return false
	life -= 0.03 * tool_level / block.resistance
	dirty = true
	return is_broken()
	
func is_broken() -> bool:
	if life <= 0:
		return true
	return false
	
func is_block_dirty():
	return dirty

func get_life() -> float:
	return life
	

func get_id() -> String:
	return "DEFAULT"

func process(_dt: float, _pos: Vector2i):
	pass
	
func on_break(_pos: Vector2i):
	pass

func on_use(_pos: Vector2i):
	pass

func encode() -> String:
	return ""
	
func decode(_str: String):
	pass
	
func instanciate(_pos: Vector2i):
	return BlockState.new()
