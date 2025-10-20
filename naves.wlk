class Nave {
	var property velocidad = 0

	method recibirAmenaza()

	method propulsar() { self.aumentarVelocidadA(20000) }

	method prepararViaje() { self.aumentarVelocidadA(15000) }

	method aumentarVelocidadA(_velocidadNueva) {
		velocidad = (velocidad + _velocidadNueva).min(300000)
	}

	method encontrarEnemigo() {
		self.recibirAmenaza()
		self.propulsar()
	}
}

class NaveDeCarga inherits Nave {
	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	override method recibirAmenaza() { carga = 0 }
}

class NaveDePasajeros  inherits Nave {
	var property alarma = false
	const cantidadDePasajeros = 0

	method tripulacion() = cantidadDePasajeros + 4

	method velocidadMaximaLegal() = 300000 / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	override method recibirAmenaza() { alarma = true }

}

class NaveDeCombate  inherits Nave {
	var property modo = reposo
	const property mensajesEmitidos = []

	method emitirMensaje(mensaje) { mensajesEmitidos.add(mensaje) }
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = velocidad < 10000 and modo.invisible()

	override method recibirAmenaza() { modo.recibirAmenaza(self) }

	override method prepararViaje() { modo.viajar(self) }

}

class NaveDeCargaRadioactiva inherits NaveDeCarga {
	var estaSellado = false

	method sellarAlVacio() { estaSellado = true }

	method estaSellado() { return estaSellado }

	override method recibirAmenaza() { velocidad = 0 }

	override method prepararViaje() { 
		self.aumentarVelocidadA(15000)
		self.sellarAlVacio() 
	}
}


object reposo {

	method invisible() = false

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}

	method viajar(nave) { 
		nave.emitirMensaje("Saliendo en mision") 
		nave.modo(ataque)
	}
}

object ataque {

	method invisible() = true

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
	}

	method viajar(nave) { nave.emitirMensaje("Volviendo a la base") }
}
