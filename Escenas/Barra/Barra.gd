extends CharacterBody2D
class_name Barra

@export var SPEED = 600.0
var altura_inicial : float
var bola = preload("res://Escenas/Bola/Bola.tscn")
@onready var posBola : Node2D= get_node("PosBola")
var nuevaBola: Bola
var tenemosVidas = true

@onready var imagen : AnimatedSprite2D = get_node("Sprite2D")

func _ready():
	EstadoGlobal.perderVida.connect(instanciarNuevaBola)
	instanciarNuevaBola()
	altura_inicial = position.y

func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Mover_Izquierda", "Mover_Derecha")
	if direction:
		velocity.x = direction * SPEED 
		imagen.play()
	else:
		velocity.x = 0
		imagen.pause()
	
	
	move_and_slide()
	velocity.y = 0
	position.y = altura_inicial

func _input(_event):
	if Input.is_action_pressed("Disparar") and tenemosVidas:
		nuevaBola.freeze = false
		nuevaBola.reparent(owner)


func instanciarNuevaBola():
	if EstadoGlobal.vidas == 0:
		tenemosVidas = false
		return
	nuevaBola = bola.instantiate() as Bola
	add_child(nuevaBola)
	nuevaBola.position = posBola.position
