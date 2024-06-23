extends Area2D

signal perderVida

func _on_body_entered(body:Node2D):
	if is_instance_of(body, Bola):
		var bola = body as Bola
		bola.destruir()
		EstadoGlobal.perderVida.emit()