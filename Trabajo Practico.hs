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

nop :: MicroControlador -> MicroControlador
nop microControlador = microControlador {programCounter = incrementarPC microControlador}

add :: MicroControlador -> MicroControlador
add microControlador = microControlador { acumuladorA = (acumuladorA microControlador + acumuladorB microControlador), acumuladorB = 0, programCounter = incrementarPC microControlador}

divide :: MicroControlador -> MicroControlador
divide microControlador = microControlador { acumuladorA = (acumuladorA microControlador `div` acumuladorB microControlador), acumuladorB = 0, programCounter = incrementarPC microControlador}

swap :: MicroControlador -> MicroControlador
swap microControlador = microControlador { acumuladorA = (acumuladorB microControlador), acumuladorB = (acumuladorA microControlador), programCounter = incrementarPC microControlador }

--lod :: MicroControlador -> Int -> MicroControlador
--lod microControlador addr = microControlador {}

--str :: Microcontrolador -> Int -> Int -> MicroControlador
--str microControlador addr val = microControlador {}

lodv :: Int -> MicroControlador -> MicroControlador
lodv val microControlador = microControlador {acumuladorA = val, programCounter = incrementarPC microControlador}

-- Funciones Auxiliares:

incrementarPC :: MicroControlador -> Int
incrementarPC microControlador = (programCounter microControlador) +1

-- Testing:

--Punto 3.3 : (add.(lodv 22).swap.(lodv 10)) xt8088