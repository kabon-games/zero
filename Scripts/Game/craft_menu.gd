class_name CraftMenu
extends Control

const required_item_prefab = preload("res://Scenes/Game/hud/required_item.tscn")

var current_recipe: CraftRecipe = CraftRecipes.CRAFT_TABLE_RECIPE
var current_recipe_index: int = 0

var current_recipe_texture: TextureRect = null
var required_container: Control = null

var control_disabled: bool = false

func update_recipe_display():
	current_recipe_texture.texture = current_recipe.result_item.sprite
	for child in required_container.get_children():
		child.queue_free()
	for stack in current_recipe.cost:
		var ri: RequiredItem = required_item_prefab.instantiate()
		ri.set_stack(stack)
		required_container.add_child(ri)

func _controls():
	if control_disabled:
		return
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_accept_mouse"):
		var me = GameData.game_manager.get_me()
		var enough: bool = true
		for cost_stack in current_recipe.cost:
			if me.inventory.get_item_quantity(cost_stack.item) < cost_stack.quantity:
				enough = false
				break
		if (enough):
			for cost_stack in current_recipe.cost:
				me.inventory.remove(cost_stack)
			control_disabled = true
			for step in current_recipe.steps:
				var result = await step.craft()
				if not result:
					control_disabled = false
					return
			control_disabled = false
			me.inventory.try_grab(ItemStack.create(current_recipe.result_item, current_recipe.result_quantity, null))
	
	if Input.is_action_just_pressed("item_next"):
		current_recipe_index += 1
		if CraftRecipes.hand_recipes.size() <= current_recipe_index:
			current_recipe_index = 0
		current_recipe = CraftRecipes.hand_recipes[current_recipe_index]
		update_recipe_display()
	
	if Input.is_action_just_pressed("item_previous"):
		current_recipe_index -= 1
		if current_recipe_index < 0:
			current_recipe_index = CraftRecipes.hand_recipes.size() - 1
		current_recipe = CraftRecipes.hand_recipes[current_recipe_index]
		update_recipe_display()
		
	
func _ready() -> void:
	current_recipe_texture = get_node("Background/item")
	required_container = get_node("Background/RequiredContainer")
	update_recipe_display()

func _process(_delta: float) -> void:
	if self.visible:
		_controls()
