class Tripulante{
  var property corajeBase
  const armas = []
  var property nivelDeInteligencia

  method coraje() = corajeBase + self.totalDanio()

  method totalDanio() = armas.sum{arma => arma.danio()}

  method esHabilNegociador() = nivelDeInteligencia > 50

  method modificarCorajeBase(cantidad) {
    corajeBase += cantidad
  }

  method degradar() {
    armas.clear()
    armas.add(new Espada(danio=1))
  }

}


//Opcion 1
object cuchillo { //puede variar a nivel general
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
class Espada {
  const danio

  method danio(pirata) = danio
}

//Pistola: En este caso el daño está dado por el calibre * un índice de material, del cual solo sabemos el nombre. 
//Los índices de los materiales todavía no se pudieron conseguir, ya que se los robó un pirata, por lo tanto se debe delegar a una entidad que entienda algo de forma tal de poder responder el índice a partir de su nombre. 
class Pistola {
  const calibre
  const nombreMaterial

  method danio(pirata) = calibre * material.indice(nombreMaterial)
}

object material { //No se pide implementar, pero sí modelar su interfaz.
  method indice(nombre) = 1
}

//Insulto: El daño está dado por la cantidad de palabras del insulto multiplicado por el coraje base del pirata que lo enuncia.
class Insulto {
  const frase

  method danio(pirata) = self.cantPalabras() * pirata.corajeBase()

  method cantPalabras() = frase.split(" ").size()
}