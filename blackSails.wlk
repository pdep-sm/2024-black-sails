class Embarcacion{
  const tripulacion
  const caniones
  var botin
  var ubicacion

  //Punto 1
  /* Calcular el poder de daño de una embarcación, que está dada por la suma total de los corajes del total de la tripulación, más el poder de daño de todos los cañones.
  */
  method poder() = tripulacion.coraje() + self.danioCaniones()

  method danioCaniones() = caniones.sum{canion => canion.danio()}

  //Punto 2
  // Obtener al tripulante más corajudo de la embarcación (que no es capitán, ni contramaestre).
  method tripulanteMasCorajudo() = tripulacion.pirataMasCorajudo()
}

//En la embarcación están el capitán, el contramaestre y la tripulación general (piratas); 
class Tripulacion{
  var capitan
  var contramaestre
  const piratas

  method coraje() = self.tripulacionTotal().sum{pirata => pirata.coraje()} 

  method tripulacionTotal() = [capitan, contramaestre] ++ piratas

  method pirataMasCorajudo() = piratas.max{pirata => pirata.coraje()}
}


class Tripulante{
  var property corajeBase
  const armas
  var property nivelDeInteligencia

  method coraje() = corajeBase + self.totalDanio()

  method totalDanio() = armas.sum{arma => arma.danio()}

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
