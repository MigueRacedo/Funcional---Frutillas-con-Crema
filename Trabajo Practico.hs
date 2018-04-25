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
nOP microControlador = microControlador { programCounter = incrementarPC microControlador}

aDD :: MicroControlador -> MicroControlador
aDD microControlador = microControlador { acumuladorA = (acumuladorA microControlador + acumuladorB microControlador), acumuladorB = 0}

dIV :: MicroControlador -> MicroControlador
dIV microControlador = microControlador { acumuladorA = (acumuladorA microControlador `div` acumuladorB microControlador), acumuladorB = 0}

swap :: MicroControlador -> MicroControlador
swap microControlador = microControlador { acumuladorA = (acumuladorB microControlador), acumuladorB = (acumuladorA microControlador)}

--lod :: MicroControlador -> Int -> MicroControlador
--lod microControlador addr = microControlador {}

-- Funciones Auxiliares:

incrementarPC :: MicroControlador -> MicroControlador
incrementarPC microControlador = microControlador {programCounter = programCounter + 1}