class_name CraftRecipe
extends Resource

@export var uid: String = ""
@export var result_item: ItemData = null
@export var result_quantity: int = 1
@export var cost: Array[ItemStack] = []
@export var steps: Array[CraftRecipeStep] = []
