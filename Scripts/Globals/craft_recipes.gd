extends Node

var CRAFT_TABLE_RECIPE: CraftRecipe = load("res://Resources/Recipes/craft_table_recipe.tres")
var WOOD_DOOR_RECIPE: CraftRecipe = load("res://Resources/Recipes/wood_door_recipe.tres")
var TORCH_RECIPE: CraftRecipe = load("res://Resources/Recipes/torch_recipe.tres")
var WOOD_WALL_RECIPE: CraftRecipe = load("res://Resources/Recipes/wood_wall_recipe.tres")
var BARREL_RECIPE: CraftRecipe = load("res://Resources/Recipes/barrel_recipe.tres")
var WOOD_BUCKET_RECIPE: CraftRecipe = load("res://Resources/Recipes/wood_bucket_recipe.tres")
var WOOD_SHOVEL_RECIPE: CraftRecipe = load("res://Resources/Recipes/wood_shovel_recipe.tres")
var WOOD_PICKAXE_RECIPE: CraftRecipe = load("res://Resources/Recipes/wood_pickaxe_recipe.tres")
var WOOD_AXE_RECIPE: CraftRecipe = load("res://Resources/Recipes/wood_axe_recipe.tres")
var WOOD_HOE_RECIPE: CraftRecipe = load("res://Resources/Recipes/wood_hoe_recipe.tres")
var SIEVE_RECiPE: CraftRecipe = load("res://Resources/Recipes/sieve_recipe.tres")
var BACKPACK_RECIPE: CraftRecipe = load("res://Resources/Recipes/backpack_recipe.tres")

enum CraftType {HAND, CRAFT_TABLE}

var recipes: Array[CraftRecipe] = []
var hand_recipes: Array[CraftRecipe] = []
var craft_table_recipes: Array[CraftRecipe] = []

func register_recipe(recipe: CraftRecipe, type: Array[CraftType]):
	recipes.append(recipe)
	if type.has(CraftType.HAND):
		hand_recipes.append(recipe)
	if type.has(CraftType.CRAFT_TABLE):
		craft_table_recipes.append(recipe)
	
func get_recipe_by_id(id: String):
	for recipe in recipes:
		if recipe.uid == id:
			return recipe
	return null

func _ready() -> void:
	register_recipe(CRAFT_TABLE_RECIPE, [CraftType.HAND, CraftType.CRAFT_TABLE])
	register_recipe(WOOD_DOOR_RECIPE, [CraftType.CRAFT_TABLE])
	register_recipe(TORCH_RECIPE, [CraftType.HAND, CraftType.CRAFT_TABLE])
	register_recipe(WOOD_WALL_RECIPE, [CraftType.CRAFT_TABLE])
	register_recipe(BARREL_RECIPE, [CraftType.CRAFT_TABLE])
	register_recipe(WOOD_BUCKET_RECIPE, [CraftType.CRAFT_TABLE])
	register_recipe(WOOD_SHOVEL_RECIPE, [CraftType.CRAFT_TABLE])
	register_recipe(WOOD_PICKAXE_RECIPE, [CraftType.CRAFT_TABLE])
	register_recipe(WOOD_AXE_RECIPE, [CraftType.CRAFT_TABLE])
	register_recipe(WOOD_HOE_RECIPE, [CraftType.CRAFT_TABLE])
	register_recipe(SIEVE_RECiPE, [CraftType.CRAFT_TABLE])
	register_recipe(BACKPACK_RECIPE, [CraftType.CRAFT_TABLE])
