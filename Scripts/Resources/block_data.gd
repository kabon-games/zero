class_name BlockData
extends Resource

enum BreakLevel {UNBREAKABLE = 0, HAND = 1, WOOD = 2}
enum ToolBreak {NONE, PICKAXE, AXE, SHOVEL}

@export var uid: String = ""
@export var display: BlockDisplay = null
@export var break_level: BreakLevel = BreakLevel.HAND
@export var tool_break: ToolBreak = ToolBreak.NONE
@export var drop: DropData = null
@export var block_state_id: String = "DEFAULT"
@export var break_sound_id: String = "BREAK_DIRT"
@export var walk_sound_id: String = "WALK_DIRT"
@export var resistance: float = 3
@export var is_background: bool = false
