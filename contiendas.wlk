import blackSails.*

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