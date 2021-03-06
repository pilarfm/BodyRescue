extends Area2D

export (int) var Velocidad
var Movimiento = Vector2()
var limite
var alive=true
var aux
signal golpe
signal catch

func _ready():
	#hide()
	$ImpulseArriba.emitting=true
	limite = get_viewport_rect().size

func _process(delta):
	Movimiento = Vector2()  #reinciar el valor
	
	if Input.is_action_pressed("ui_right"):
		Movimiento.x += 1
	if Input.is_action_pressed("ui_left"):
		Movimiento.x -= 1
	if Input.is_action_pressed("ui_down"):
		Movimiento.y += 1
	if Input.is_action_pressed("ui_up"):
		Movimiento.y -= 1
	
	
	if Movimiento.length() > 0:   #Verificar si se esta moviendo
		Movimiento = Movimiento.normalized() * Velocidad  #NOrmalizar la velocidad
	
	position += Movimiento * delta	#actualizar los movimientos
	position.x = clamp(position.x, 0, limite.x)
	position.y = clamp(position.y, 0, limite.y)
	
	if Movimiento.x != 0:   #posicionar al sprite depende de los movimientos
		$ImpulseAbajo.emitting=false
		$ImpulseArriba.emitting=false
		$AnimatedSprite.animation = "lado"
		aux=Movimiento.x < 0
		$AnimatedSprite.flip_h = aux
		if(aux):
			$ImpulseLadoDer.emitting=false
			$ImpulseLadoIzq.emitting=true
		else:
			$ImpulseLadoDer.emitting=true
			$ImpulseLadoIzq.emitting=false
		$CollisionShapefrente.disabled = true
		$CollisionShapelado.disabled=false
	elif Movimiento.y != 0:
		$ImpulseLadoDer.emitting=false
		$ImpulseLadoIzq.emitting=false
		$AnimatedSprite.animation = "frente"
		aux=Movimiento.y > 0
		$AnimatedSprite.flip_v = aux
		if(aux):
			$ImpulseAbajo.emitting=true
			$ImpulseArriba.emitting=false
		else:
			$ImpulseAbajo.emitting=false
			$ImpulseArriba.emitting=true
		$CollisionShapefrente.disabled =false
		$CollisionShapelado.disabled=true
	#else:
	#	$AnimatedSprite.animation = "frente"
	#	$CollisionShapefrente.disabled =false
	#	$CollisionShapelado.disabled=true


func _on_Nave_body_entered(body):  #cuando hay una colision con un cuerpo
	$CollisionShapefrente.disabled = true
	$CollisionShapelado.disabled=true
	hide()   #se oculta cuando recibe un golpe
	if (alive):
		alive=false
		emit_signal("golpe")
	
func inicio(pos):
	alive=true
	position = pos   #mostrar el personaje
	show()
	$CollisionShapefrente.disabled =false
	$CollisionShapelado.disabled=false

func _on_Nave_area_entered(area):
	emit_signal("catch")
