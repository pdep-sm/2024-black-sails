class BallenaAzul {
  const property fuerza

  method aplicarDanio(embarcacion) {
    embarcacion.envejecerCaniones(8)
  }

}

class Tiburon {
  const property fuerza
  const nivelDeIntimidacion

  method aplicarDanio(embarcacion) {
    embarcacion.asustar(nivelDeIntimidacion)
  }

}

object kraken {
  const property fuerza = 100000

  method aplicarDanio(embarcacion) {
    embarcacion.matarMasCorajudos(5)
  }

}

