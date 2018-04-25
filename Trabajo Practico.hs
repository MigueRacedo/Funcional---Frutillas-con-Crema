-- Definicion de tipos y de Data:

data MicroControlador = UnMicroControlador {posiciones::[Posicion],acumuladorA::Int,acumuladorB::Int,programCounter::Int,etiqueta::String} deriving (Eq,Show)

type Posicion = Int

type Instruccion = MicroControlador -> MicroControlador

type MicroInstruccion = MicroControlador -> MicroControlador

xt8088 = UnMicroControlador {
    posiciones = [],
    acumuladorA = 0,
    acumuladorB = 0,
    programCounter = 0,
    etiqueta = ""

}

nop :: Instruccion
nop microControlador = incrementarPC microControlador

add :: Instruccion
add microControlador = (sumaryPonerEnA.incrementarPC) microControlador

divide :: Instruccion
divide microControlador = (dividirAcumuladores.incrementarPC) microControlador

swap :: Instruccion
swap microControlador = (intercambiarAcumuladores.incrementarPC) microControlador

lod :: MicroControlador -> Int -> MicroControlador
lod microControlador addr = ((setearAcumuladorA (sacarDeLista addr (posiciones microControlador))).incrementarPC) microControlador

str :: Int -> Int -> Instruccion
str addr val microControlador = ((partirListaYColocarEn addr val).incrementarPC) microControlador

lodv :: Int -> Instruccion
lodv val microControlador = ((setearAcumuladorA val).incrementarPC) microControlador

-- Funciones Auxiliares:

incrementarPC :: MicroInstruccion
incrementarPC microControlador = microControlador { programCounter = (programCounter microControlador) +1 }

dividirAcumuladores :: MicroInstruccion
dividirAcumuladores microControlador  = microControlador { acumuladorA = (acumuladorA microControlador `div` acumuladorB microControlador), acumuladorB = 0}

setearAcumuladorA :: Int -> MicroInstruccion
setearAcumuladorA val microControlador = microControlador {acumuladorA = val}

intercambiarAcumuladores :: MicroInstruccion
intercambiarAcumuladores microControlador = microControlador { acumuladorA = (acumuladorB microControlador), acumuladorB = (acumuladorA microControlador)}

sumaryPonerEnA :: MicroInstruccion
sumaryPonerEnA microControlador = microControlador { acumuladorA = (acumuladorA microControlador + acumuladorB microControlador), acumuladorB = 0}

partirListaYColocarEn :: Int -> Int -> MicroInstruccion
partirListaYColocarEn pos valor microControlador = microControlador {posiciones = partirListaYAgregar pos valor (posiciones microControlador)} 

partirListaYAgregar :: Int -> Int -> [Int] -> [Int]
partirListaYAgregar pos valor listaPos = (take pos listaPos) ++ [valor] ++ (drop pos listaPos)

sacarDeLista :: Int -> [Int] -> Int
sacarDeLista pos listaPos = (!!) listaPos pos

-- Testing:

--Punto 3.3 : (add.(lodv 22).swap.(lodv 10)) xt8088
-- Punto 3.4: