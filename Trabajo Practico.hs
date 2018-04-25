-- Definicion de tipos y de Data:

data MicroControlador = UnMicroControlador {posiciones::[Posicion],acumuladorA::Int,acumuladorB::Int,programCounter::Int,etiqueta::String} deriving (Eq,Show)

type Posicion = Int

xt8088 = UnMicroControlador {
    posiciones = [],
    acumuladorA = 0,
    acumuladorB = 0,
    programCounter = 0,
    etiqueta = ""

}

nOP :: MicroControlador -> MicroControlador
nOP microControlador = microControlador {programCounter = incrementarPC microControlador}

aDD :: MicroControlador -> MicroControlador
aDD microControlador = microControlador { acumuladorA = (acumuladorA microControlador + acumuladorB microControlador), acumuladorB = 0, programCounter = incrementarPC microControlador}

dIV :: MicroControlador -> MicroControlador
dIV microControlador = microControlador { acumuladorA = (acumuladorA microControlador `div` acumuladorB microControlador), acumuladorB = 0, programCounter = incrementarPC microControlador}

swap :: MicroControlador -> MicroControlador
swap microControlador = microControlador { acumuladorA = (acumuladorB microControlador), acumuladorB = (acumuladorA microControlador), programCounter = incrementarPC microControlador }

--lod :: MicroControlador -> Int -> MicroControlador
--lod microControlador addr = microControlador {}

--str :: Microcontrolador -> Int -> Int -> MicroControlador
--str microControlador addr val = microControlador {}

lODV :: MicroControlador -> Int -> MicroControlador
lODV microControlador val = microControlador {acumuladorA = val, programCounter = incrementarPC microControlador}

-- Funciones Auxiliares:

incrementarPC :: MicroControlador -> Int
incrementarPC microControlador = (programCounter microControlador) +1