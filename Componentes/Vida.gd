extends Node2D
class_name Vida

signal recibir_dano
signal morir

@export var puntos_de_vida : int:
	set(valor):
		puntos_de_vida = clamp(valor, 0, 100)

func hacer_dano(cantidad:int):
	puntos_de_vida -= cantidad
	recibir_dano.emit()
	if puntos_de_vida == 0:
		morir.emit()
