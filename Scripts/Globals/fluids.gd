extends Node

var WATER_FLUID: FluidData = load("res://Resources/FluidData/water_fluid.tres")

var fluids: Array[FluidData] = []

func get_fluid_by_id(id: String) -> FluidData:
	for fluid in fluids:
		if fluid.uid == id:
			return fluid
	return null

func register_fluid(fluid: FluidData):
	fluids.append(fluid)
	
func _ready() -> void:
	register_fluid(WATER_FLUID)
