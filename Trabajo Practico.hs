-- Definicion de tipos y de Data:

data MicroControlador = UnMicroControlador {posiciones::[Posicion],acumuladorA::Int,acumuladorB::Int,programCounter::Int,etiqueta::String} deriving (Show)

type Posicion = Int

tuMami = UnMicroControlador {
    posiciones = [1,2,3],
    acumuladorA = 5,
    acumuladorB = 7,
    programCounter = 0,
    etiqueta = "Hola"

}

nOP :: MicroControlador -> MicroControlador
nOP (UnMicroControlador _ _ _ programCounter _) = UnMicroControlador { programCounter = incrementarPC microControlador}

-- Funciones Auxiliares:

incrementarPC :: MicroControlador -> Int
incrementarPC microControlador = (programCounter microControlador) +1