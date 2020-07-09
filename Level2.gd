extends Node

export (PackedScene) var Bacteria
export (PackedScene) var Antibody
signal start_HUD2
signal hide_HUD2
#var Score
var cantAntbody=0
const cantAntbodyMax=10
onready var save = load("res://Saves.gd").new()

var player = {
#"username":"",
"score":0,
"level":0,
"lives":3
}

var ScoreInicial

func _ready():
	emit_signal("start_HUD2")
	$Nave.inicio($InitialPosition.position) #posicion de inicio del jugador
	$InicioTimer.start()
	$Nave.show()
	$background.show()
	player=save.load_game()
	ScoreInicial= player.score
	$HUD_game.actualizarScore(ScoreInicial)
	$HUD_game.actualizarVidas(player.lives)
	$HUD_game.actualizarAnticuerpos(cantAntbody)

func nuevo_juego():
	pass

func game_over():
	$BacteriaTimer.stop()
	$ScoreTimer.stop()
	emit_signal("hide_HUD2")
	$LevelLoose.visible=true
	$Again.disabled=false
	$Again.visible=true
	if(player.lives<=1):
		get_tree().change_scene("res://Game_over.tscn")
	else:
		save.save_game(ScoreInicial,player.level,player.lives-1)

func finish():		#Gana el nivel
	$BacteriaTimer.stop()
	$ScoreTimer.stop()
	emit_signal("hide_HUD2")
	$LevelWin.visible=true
	save.save_game(player.score,player.level+1,player.lives)
	$NextScene.start()

func _on_NextScene_timeout():
	get_tree().change_scene("res://body.tscn")

func _on_InicioTimer_timeout():
	$BacteriaTimer.start()
	$ScoreTimer.start()
	$AntibodyTimer.start()
	
func _on_ScoreTimer_timeout():
	player.score += 1
	$HUD_game.actualizarScore(player.score)

func _on_BacteriaTimer_timeout():
	#Seleccionar un lugar aleatorio en el camino
	$Camino/BacteriaPosicion.set_offset(randi())
	var B = Bacteria.instance()
	#var aux=get_node(B)
	B.change_bacteria_type(["grande3","chica3"])
	B.select_animation(randi() % B.tipo_bacteria.size())
	#aux.select_animation(randi() % tipo_bacteria.size())
	#$AnimatedSprite.animation= tipo_bacteria[randi() % tipo_bacteria.size()]
	add_child(B)
	
	#Seleccionar una direccion
	var d = $Camino/BacteriaPosicion.rotation + PI /2
	
	B.position = $Camino/BacteriaPosicion.position
	
	d += rand_range(-PI /4, PI /4)
	B.rotation = d
	B.set_linear_velocity(Vector2(rand_range(B.velocidad_min,B.velocidad_max), 0).rotated(d))

func play_again():
	get_tree().change_scene("res://Level2.tscn")

func _on_AntibodyTimer_timeout():
	var xPos
	var yPos
	var A=Antibody.instance()
	randomize()
	xPos=rand_range(328.479,802.522)
	yPos=rand_range(276.944,1031.992)
	add_child(A)
	#A.play("show_up")
	A.position=Vector2(xPos,yPos)

func antibody_catch():
	cantAntbody+=1
	$HUD_game.actualizarAnticuerpos(cantAntbody)
	if(cantAntbody>=cantAntbodyMax):
		finish()
	else:
		$AntibodyTimer.start()