-- Definicion de tipos y de Data:

data MicroControlador = UnMicroControlador {posiciones::[Posicion],acumuladorA::Int,acumuladorB::Int,programCounter::Int,etiqueta::String} deriving (Eq,Show)

type Posicion = Int

tuMami = UnMicroControlador {
    posiciones = [1,2,3],
    acumuladorA = 5,
    acumuladorB = 7,
    programCounter = 0,
    etiqueta = "Hola"

}

nOP :: MicroControlador -> MicroControlador
nOP microControlador = UnMicroControlador { programCounter = incrementarPC microControlador}

aDD :: MicroControlador -> MicroControlador
aDD microControlador = UnMicroControlador { acumuladorA = (acumuladorA microControlador + acumuladorB microControlador), acumuladorB = 0}

dIV :: MicroControlador -> MicroControlador
dIV microControlador = UnMicroControlador { acumuladorA = (acumuladorA microControlador `div` acumuladorB microControlador), acumuladorB = 0}

swap :: MicroControlador -> MicroControlador
swap microControlador = UnMicroControlador { acumuladorA = (acumuladorB microControlador), acumuladorB = (acumuladorA microControlador)}

lod :: MicroControlador -> Int -> MicroControlador
lod microControlador addr = UnMicroControlador {}

-- Funciones Auxiliares:

incrementarPC :: MicroControlador -> Int
incrementarPC microControlador = (programCounter microControlador) +1