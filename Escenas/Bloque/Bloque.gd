extends StaticBody2D
class_name Bloque

@onready var imagen : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var vida : Vida = get_node("Vida")
@onready var colision: CollisionShape2D = get_node("CollisionShape2D")
@onready var sonido_romper : AudioStreamPlayer2D = get_node("AudioStreamPlayer2D")

var esDeOro = false
var esDePlata = false

var animacion := EstadoGlobal.COLOR_ANIMACION_BLOQUE[0]
var es_destructible := true
@export var vida_inicial := 1
var puntosGanados := 5

func _ready():
	actualizar_color()
	imagen.frame = 0
	if vida_inicial == 3:
		esDeOro = true
	elif vida_inicial == 2:
		esDePlata = true
	vida.puntos_de_vida = vida_inicial
	puntosGanados *= vida_inicial
	if not es_destructible:
		colision.disabled = true

func actualizar_color():
	imagen.animation = animacion

func cambiar_color(id_color):
	animacion = EstadoGlobal.COLOR_ANIMACION_BLOQUE[id_color]

func cambiar_color_aleatorio():
	randomize()
	var id_color = randi() % 8
	cambiar_color(id_color)

func recibir_dano(cantidad):
	if es_destructible:
		vida.hacer_dano(cantidad)

func _al_recibir_dano(): # esta funcion se ejecuta cada vez q el componente vida recibe dano
	sonido_romper.play()
	imagen.frame += 1
	#Todo Animacion de recebir dano

func _al_morir():
	EstadoGlobal.puntuacion += puntosGanados * vida_inicial
	EstadoGlobal.bloquesRestantes -= 1
	EstadoGlobal.seObtubieronPuntos.emit()
	#Todo Animacion de morir
	imagen.visible = false
	colision.queue_free()
	await sonido_romper.finished
	queue_free()
