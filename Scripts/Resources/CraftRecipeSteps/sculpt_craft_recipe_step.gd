class_name SculptCraftRecipeStep
extends CraftRecipeStep

@export var schema: Array[int] = [1,2,3]

func craft():
	var minigame: SculptMinigame = GameData.game_manager.hud.sculpt_minigame
	minigame.visible = true
	minigame.start(schema)
	await minigame.finished
	minigame.visible = false
	return not minigame.failed
