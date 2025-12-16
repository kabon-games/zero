class_name NailCraftRecipeStep
extends CraftRecipeStep

@export var speed: float = 50

func craft():
	var minigame: NailMinigame = GameData.game_manager.hud.nail_minigame
	minigame.visible = true
	minigame.start()
	minigame.speed = speed
	await minigame.finished
	minigame.visible = false
	return true
