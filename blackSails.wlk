class Embarcacion{
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
}

class Ubicacion{
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

//Punto 4
/*Dadas dos embarcaciones y una forma de contienda, saber si la primera puede tomar a la segunda o no.
Por otra parte, realizar la toma (el resultado de la contienda) propiamente dicha de la embarcación vencida. Tener en cuenta que dependiendo de la toma de la embarcación pasan cosas distintas.*/

class Contienda{
  method puedeTomar(embarcacionGanadora, embarcacionPerdedora) =
      embarcacionGanadora.puedeEntrarEnConflicto(embarcacionPerdedora)

  method tomar(embarcacionGanadora, embarcacionPerdedora) {
    if(!self.puedeTomar(embarcacionGanadora, embarcacionPerdedora)){
      throw new Exception (message = "No se puede tomar")
    }
  }

}

object batalla inherits Contienda{
  override method puedeTomar(embarcacionGanadora, embarcacionPerdedora) = 
  super(embarcacionGanadora, embarcacionPerdedora) &&
            embarcacionGanadora.poder() > embarcacionPerdedora.poder()

  override method tomar(embarcacionGanadora, embarcacionPerdedora) {
    super(embarcacionGanadora, embarcacionPerdedora)
    self.mezclar(embarcacionGanadora.tripulacion(), 
                  embarcacionPerdedora.tripulacion())
  }

  method mezclar(tripulacionGanadora, tripulacionPerdedora){
    tripulacionGanadora.modificarCorajeBase(5)
    tripulacionPerdedora.matarCobardes(3)
    tripulacionPerdedora.capitan(tripulacionGanadora.contramaestre())
    tripulacionGanadora.promoverAContramaestre()
    //tripulacionPerdedora.recibirTripulantes(tripulacionGanadora,3)
    tripulacionGanadora.transferirTripulantes(tripulacionPerdedora,3)
  
  }
}

object negociacion inherits Contienda{
  override method puedeTomar(embarcacionGanadora, embarcacionPerdedora) = 
  super(embarcacionGanadora, embarcacionPerdedora) &&
    embarcacionGanadora.tieneHabilNegociador()

  override method tomar(embarcacionGanadora, embarcacionPerdedora){
    super(embarcacionGanadora, embarcacionPerdedora)
    const mitadBotin = embarcacionPerdedora.botin() / 2
    embarcacionGanadora.modificarBotin(mitadBotin)
    embarcacionPerdedora.modificarBotin(-mitadBotin)
  }
}

//En la embarcación están el capitán, el contramaestre y la tripulación general (piratas); 
class Tripulacion{
  var property capitan
  var property contramaestre
  const piratas

  method coraje() = self.tripulacionTotal().sum{pirata => pirata.coraje()} 

  method tripulacionTotal() = [capitan, contramaestre] ++ piratas

  method pirataMasCorajudo() = piratas.max{pirata => pirata.coraje()}
  
  method tieneHabilNegociador() = self.tripulacionTotal().any{tripulante => tripulante.esHabilNegociador()}

  method modificarCorajeBase(cantidad){
    self.tripulacionTotal().forEach{tripulante => 
                tripulante.modificarCorajeBase(cantidad)}
  }

  method matarCobardes(cantidad){
    const piratasCobardes = self.piratasPorCoraje().take(cantidad)
    piratas.removeAll(piratasCobardes)

  }

  //method piratasPorCoraje() = piratas.sortedBy{ p => p.coraje()}
  method piratasPorCoraje() = piratas.sortedBy{ p1, p2 => p1.coraje() < p2.coraje()}

}


class Tripulante{
  var property corajeBase
  const armas
  var property nivelDeInteligencia

  method coraje() = corajeBase + self.totalDanio()

  method totalDanio() = armas.sum{arma => arma.danio()}

  method esHabilNegociador() = nivelDeInteligencia > 50

  method modificarCorajeBase(cantidad) {
    corajeBase += cantidad
  }

}

class Canion{
  const danioFabricacion
  var antiguedad = 0

  method aumentarAntiguedad(cantAnios) {
    antiguedad += cantAnios
  }

  method danio() = (danioFabricacion * self.desgasteAntiguedad()).max(0)

  method desgasteAntiguedad() = 1 - 0.01 * antiguedad

}

//Cuchillo: Todos los cuchillos tienen la misma cantidad de daño, que puede variar a nivel general, es decir para todos.

//Opcion 1
object cuchillo{ //puede variar a nivel general
  var danio = 1

  method cambiarDanio(nuevoDanio) {
    danio = nuevoDanio 
  }

  method danio(pirata) = danio
}

//Opcion 2
/* con companion
object cuchillo{ //puede variar a nivel general
  var property cantidadDanio = 1
}

class Cuchillo{
  method totalDanio() = cuchillo.cantidadDanio()
}
*/

//Espada: Cada espada tiene su complejidad, por lo tanto el daño es específico para cada una.
class Espada{
  const danio

  method danio(pirata) = danio
}

//Pistola: En este caso el daño está dado por el calibre * un índice de material, del cual solo sabemos el nombre. 
//Los índices de los materiales todavía no se pudieron conseguir, ya que se los robó un pirata, por lo tanto se debe delegar a una entidad que entienda algo de forma tal de poder responder el índice a partir de su nombre. 
class Pistola{
  const calibre
  const nombreMaterial

  method danio(pirata) = calibre * material.indice(nombreMaterial)
}

object material{ //No se pide implementar, pero sí modelar su interfaz.
  method indice(nombre) = 1
}

//Insulto: El daño está dado por la cantidad de palabras del insulto multiplicado por el coraje base del pirata que lo enuncia.
class Insulto{
  const frase

  method danio(pirata) = self.cantPalabras() * pirata.corajeBase()

  method cantPalabras() = frase.split(" ").size()
}
