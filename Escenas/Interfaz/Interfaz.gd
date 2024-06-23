extends CanvasLayer
class_name Interfaz

@onready var puntuacion_ganar : Label= get_node("Control/Ganar/Panel/CenterContainer/VBoxContainer/Puntuacion")
@onready var puntuacion_perder : Label= get_node("Control/Perder/Panel/CenterContainer/VBoxContainer/Puntuacion")

@onready var boton_siguiente : Button = get_node("Control/Ganar/Panel/CenterContainer/VBoxContainer/HBoxContainer/Siguiente")

@onready var puntuacion : Label = get_node("Control/Estatus/Margen/Divisor/Puntuacion")
@onready var vidas = get_node("Control/Estatus/Margen/Divisor/Vidas")
@onready var dificultad : HSlider = get_node("Control/Selector de nivel/Dificultad/MarginContainer/HBoxContainer/Dificultad")

@onready var pantalla_ganar : Control= get_node("Control/Ganar")
@onready var pantalla_perder : Control = get_node("Control/Perder")
@onready var pantalla_menu : Control = get_node("Control/Menu")

@export_file() var escena_principal
@export_file() var escena_seleccion_niveles

@export_dir var escenas_niveles

func archivo_escena_nivel(nivel):
	return escenas_niveles + "/Nivel " + str(nivel) + ".tscn" 

func accionBotonesNiveles(nivel):
	cambiarEscena(archivo_escena_nivel(nivel), true, false)

signal ganar
signal perder
signal pausar

func _ready():
	EstadoGlobal.reiniciarEstados()
	EstadoGlobal.seObtubieronPuntos.connect(actualizarPuntuacion)
	EstadoGlobal.perderVida.connect(al_perderVida)

func _input(_event):
	if Input.is_action_pressed("Menu"):
		pausar.emit()

func actualizarPuntuacion():
	puntuacion.text = "Puntuacion: " + str(EstadoGlobal.puntuacion)
	if EstadoGlobal.bloquesRestantes == 0:
		ganar.emit()

func al_perderVida():
	EstadoGlobal.vidas -= 1
	vidas.get_children()[0].queue_free()
	print(EstadoGlobal.vidas)
	if EstadoGlobal.vidas == 0:
		perder.emit()

var esta_jugando = true

func _on_ganar():
	get_tree().paused = true
	boton_siguiente.visible = EstadoGlobal.siguiente_nivel != null
	puntuacion_ganar.text = "Puntuacion: " + str(EstadoGlobal.puntuacion)
	pantalla_ganar.visible = true
	esta_jugando = false

func _on_perder():
	get_tree().paused = true
	puntuacion_perder.text = "Puntuacion: " + str(EstadoGlobal.puntuacion)
	pantalla_perder.visible = true
	esta_jugando = false

func _on_pausar():
	if esta_jugando:
		accionPausa()

func accionPausa():
	get_tree().paused = !get_tree().paused
	pantalla_menu.visible = !pantalla_menu.visible

func accionInicio():
	cambiarEscena(escena_principal, false, true)

func accionReintentar():
	esta_jugando = true
	get_tree().paused = false
	get_tree().reload_current_scene()

func cambiarEscena(escena : String, jugara : bool, pausara : bool):
	esta_jugando = jugara
	get_tree().paused = pausara
	get_tree().change_scene_to_file(escena)

func _on_siguiente_pressed():
	cambiarEscena(EstadoGlobal.siguiente_nivel, true, false)


func _on_inicio_pressed():
	accionInicio()


func _on_reintentar_pressed():
	accionReintentar()

# este boton esta en el menu de pausa
func _on_continuar_pressed():
	accionPausa()

func comenzarNivel(nivel):
	accionBotonesNiveles(nivel)
	EstadoGlobal.dificultad = int(dificultad.value)


func _on_nivel_1_pressed():
	comenzarNivel(1)

func _on_nivel_2_pressed():
	comenzarNivel(2)

func _on_nivel_3_pressed():
	comenzarNivel(3)

func _on_nivel_4_pressed():
	comenzarNivel(4)

func _on_nivel_5_pressed():
	comenzarNivel(5)

func accionSalir():
	get_tree().quit()


func _on_salir_pressed():
	accionSalir()


func _on_jugar_pressed():
	cambiarEscena(escena_seleccion_niveles, false, true)



func _on_menu_pressed():
	accionPausa()