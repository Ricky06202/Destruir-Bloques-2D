extends RigidBody2D
class_name Bola

@export var rapidez = 600
@onready var imagen : Sprite2D = get_node("Sprite2D")
@onready var sonido_rebotar : AudioStreamPlayer2D = get_node("Rebotar")
@onready var sonido_morir : AudioStreamPlayer2D = get_node("Morir")

func _on_body_exited(body:Node):
	sonido_rebotar.play()
	if is_instance_of(body, Bloque):
		var bloque = body as Bloque
		bloque.recibir_dano(1)

func _physics_process(_delta):
	linear_velocity = linear_velocity.normalized() * rapidez

func destruir():
	sonido_morir.play()
	imagen.visible = false
	await sonido_morir.finished
	queue_free()