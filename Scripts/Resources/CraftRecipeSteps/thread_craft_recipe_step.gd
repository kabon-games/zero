class_name ThreadCraftRecipeStep
extends CraftRecipeStep

func craft():
	var minigame: ThreadMinigame = GameData.game_manager.hud.thread_minigame
	minigame.visible = true
	minigame.start()
	await minigame.finished
	minigame.visible = false
	return true
