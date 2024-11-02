import tripulantes.*
import contiendas.*

class Embarcacion {
  const property tripulacion
  const caniones
  var property botin
  var property ubicacion

  //Punto 1
  /* Calcular el poder de daño de una embarcación, que está dada por la suma total de los corajes del total de la tripulación, más el poder de daño de todos los cañones.*/
  method poder() = tripulacion.coraje() + self.danioCaniones()

  method danioCaniones() = caniones.sum{canion => canion.danio()}

  //Punto 2
  // Obtener al tripulante más corajudo de la embarcación (que no es capitán, ni contramaestre).
  method tripulanteMasCorajudo() = tripulacion.pirataMasCorajudo()

  //Punto 3
  /* Esto ocurre cuando la diferencia de las coordenadas es menor a un valor configurable en el sistema, siempre y cuando correspondan al mismo océano. Nota: Utilizar el cálculo de distancia entre dos puntos.*/

  method puedeEntrarEnConflicto(otraEmbarcacion) = 
                ubicacion.entraEnDistanciaConflictiva(otraEmbarcacion.ubicacion())

  method tieneHabilNegociador() = tripulacion.tieneHabilNegociador()

  method modificarBotin(cantidad) {
    botin += cantidad
  }

  //Punto 5
  method amotinarse() {
    tripulacion.amotinarse()
  }

  //Pto 7
  method cruzarseCon(bestia) {
    if (self.poder() < bestia.fuerza()) {
      bestia.aplicarDanio(self)
    }
  }

  method envejecerCaniones(anios) {
    caniones.forEach{ canion => canion.aumentarAntiguedad(anios) }
  }

  method asustar(nivelIntimidacion) {
    tripulacion.asustar(nivelIntimidacion)
  }

  method matarMasCorajudos(cantidad) {
    tripulacion.matarMasCorajudos(cantidad)
  }

}

class Ubicacion {
  const property oceano
  const property coordenadaX
  const property coordenadaY

  method entraEnDistanciaConflictiva(otraUbicacion) = 
        self.estaEnMismoOceano(otraUbicacion) && self.estaEnDistanciaConflictiva(otraUbicacion)

  method estaEnMismoOceano(otraUbicacion) = otraUbicacion.oceano() == oceano

  method estaEnDistanciaConflictiva(otraUbicacion) =
          self.distancia(otraUbicacion) < ubicacion.distanciaConflictiva()

  method distancia(otraUbicacion) = 
          ((otraUbicacion.coordenadaX() - coordenadaX).square() +
          (otraUbicacion.coordenadaY() - coordenadaY).square()).squareRoot()
}

object ubicacion {
  var property distanciaConflictiva = 100
}


//En la embarcación están el capitán, el contramaestre y la tripulación general (piratas); 
class Tripulacion {
  var property capitan
  var property contramaestre
  const piratas = []

  method coraje() = self.tripulacionTotal().sum{pirata => pirata.coraje()} 

  method tripulacionTotal() = [capitan, contramaestre] + piratas

  method pirataMasCorajudo() = piratas.max{pirata => pirata.coraje()}
  
  method tieneHabilNegociador() = self.tripulacionTotal().any{tripulante => tripulante.esHabilNegociador()}

  method modificarCorajeBase(cantidad) {
    self.tripulacionTotal().forEach{tripulante => 
                tripulante.modificarCorajeBase(cantidad)}
  }

  method matarCobardes(cantidad) {
    const piratasCobardes = self.piratasPorCoraje().take(cantidad)
    piratas.removeAll(piratasCobardes)

  }

  //method piratasPorCoraje() = piratas.sortedBy{ p => p.coraje()}
  method piratasPorCoraje() = piratas.sortedBy{ p1, p2 => p1.coraje() < p2.coraje()}

  method amotinarse() {
    const contramaestreAnterior = contramaestre
    self.promoverAContramaestre()
    if (contramaestreAnterior.coraje() > capitan.coraje()) {
      capitan = contramaestreAnterior
    } else {
      contramaestreAnterior.degradar()
      self.agregarPirata(contramaestreAnterior)
    }
  }

  method agregarPirata(pirata) {
    piratas.add(pirata)
  }

  method promoverAContramaestre() {
    contramaestre = self.pirataMasCorajudo()
  }

  method asustar(nivelIntimidacion) {
    self.tripulacionTotal().forEach{ tripulante => 
      tripulante.modificarCorajeBase(-nivelIntimidacion)
    }
  }

  method matarMasCorajudos(cantidad) {
    const masCorajudos = self.piratasPorCoraje().reverse().take(cantidad)
    piratas.removeAll(masCorajudos)
  }

}


class Canion {
  const danioBase
  var antiguedad = 0

  method aumentarAntiguedad(cantAnios) {
    antiguedad += cantAnios
  }

  method danio() = (danioBase * self.desgasteAntiguedad()).max(0)

  method desgasteAntiguedad() = 1 - 0.01 * antiguedad

}


//Pto 6 - Representar la fabricación de un canion
object canion {
  var property danioFabricacion = 350

  method nuevo() = new Canion(danioBase = danioFabricacion)

}


