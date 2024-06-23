extends Node2D

signal seObtubieronPuntos
signal perderVida
signal asignarDificultad

var siguiente_nivel

enum COLORES{
	ROJO,
	AZUL,
	VERDE,
	NARANJA,
	MORADO,
	ROSA,
	BLANCO,
	NEGRO,
	PLATA,
	ORO,
	ROJO_REFORSADO,
	AZUL_REFORSADO,
	VERDE_REFORSADO,
	ALEATORIO,
}

const COLOR_ANIMACION_BLOQUE = [
	"Rojo",
	"Azul",
	"Verde",
	"Naranja",
	"Morado",
	"Rosa",
	"Blanco",
	"Negro",
	"Plata",
	"Oro",
	"Rojo_Reforsado",
	"Azul_Reforsado",
	"Verde_Reforsado",
]

var puntuacion : int :
	set(valor):
		puntuacion = 0 if valor < 0 else valor

var vidas : int :
	set(valor):
		vidas = clamp(valor, 0, 3)

var dificultad : int :
	set(valor):
		dificultad = clamp(valor, 0, 10)

func reiniciarEstados():
	puntuacion = 0
	vidas = 3

func _ready():
	reiniciarEstados()