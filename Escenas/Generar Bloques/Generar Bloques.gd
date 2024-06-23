extends TileMap

var bloque = preload("res://Escenas/Bloque/Bloque.tscn")
@export var tamano := Vector2i(200, 100)
var dificultad := 0
var aumento_por_dificultad := 5
var maximo_vida_por_bloque = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	dificultad = EstadoGlobal.dificultad
	var capas = get_layers_count()
	for capa in range(capas):
		var nombre_capa = get_layer_name(capa)
		
		for celda in get_used_cells(capa):
			var nuevo_bloque = bloque.instantiate() as Bloque
			
			ajustar_propiedades(nuevo_bloque, capa, nombre_capa, celda)

			#TODO guardar en un objeto {capa, celda, id_atlas, coord_atlas} para poder volver a aparecer los bloques y poder aumentar la dificultad
			#TODO hacer funcion guardar_informacion_bloques()
			#TODO hacer funcion colocar_informacion_bloques_en_celdas() => usar en otro lado (signal)
			#TODO convertir todo esto a una funcion que se pueda llamar en otro lado (signal) 

			set_cell(capa, celda)

			add_child(nuevo_bloque)
			nuevo_bloque.position = celda * tamano + tamano / 2

func acierta_la_probabilidad_del(probabilidad: int) -> bool:
	probabilidad = clamp(probabilidad, 0, 100)
	randomize()
	var numero = randf_range(0,1)
	# print("numero " + str(numero))
	# print("prob " + str(probabilidad/100.0))
	# print(numero <= probabilidad / 100.0)
	return numero <= probabilidad / 100.0

func aumentar_vida(nuevo_bloque):
	var probabilidad = dificultad * aumento_por_dificultad
	# print("probabilidad es: " + str(probabilidad))
	while acierta_la_probabilidad_del(probabilidad):
		if nuevo_bloque.vida_inicial >= maximo_vida_por_bloque: break
		# print("aumentando vida")
		nuevo_bloque.vida_inicial += 1

func ajustar_propiedades(nuevo_bloque, capa, nombre_capa, celda):
	var id_bloque = get_cell_source_id(capa, celda)
	if id_bloque == -1: return
	match nombre_capa:
		"Obstaculos":
			nuevo_bloque.es_destructible = false
			nuevo_bloque.cambiar_color(id_bloque)
		"Color":
			aumentar_vida(nuevo_bloque)

			# print("tile map id bloque " + str(id_bloque))
			if id_bloque == EstadoGlobal.COLORES.ALEATORIO:
				nuevo_bloque.cambiar_color_aleatorio()
			else:
				nuevo_bloque.cambiar_color(id_bloque)

			# print(nuevo_bloque.vida_inicial)
			if nuevo_bloque.vida_inicial == 3:
					nuevo_bloque.cambiar_color(EstadoGlobal.COLORES.ORO)
			elif nuevo_bloque.vida_inicial == 2:
					nuevo_bloque.cambiar_color(EstadoGlobal.COLORES.PLATA)
					
