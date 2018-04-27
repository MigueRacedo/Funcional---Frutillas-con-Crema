-- Definicion de tipos y de Data:

data MicroControlador = UnMicroControlador {memoria::[Posicion],acumuladorA::Int,acumuladorB::Int,programCounter::Int,etiqueta::String} deriving (Eq,Show)

type Posicion = Int

type Instruccion = MicroControlador -> MicroControlador

type MicroInstruccion = MicroControlador -> MicroControlador

xt8088 = UnMicroControlador {
    memoria = unMega,
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
divide microControlador | ((acumuladorB microControlador)==0) = ((modificarEtiqueta "Division Por Cero").incrementarPC) microControlador
                        | otherwise = (dividirAcumuladores.incrementarPC) microControlador

swap :: Instruccion
swap microControlador = (intercambiarAcumuladores.incrementarPC) microControlador

lod :: Int -> Instruccion
lod addr microControlador = ((setearAcumuladorA (sacarDeLista addr (memoria microControlador))).incrementarPC) microControlador

str :: Int -> Int -> Instruccion
str addr val microControlador = ((partirListaYColocarEn addr val).incrementarPC) microControlador

lodv :: Int -> Instruccion
lodv val microControlador = ((setearAcumuladorA val).incrementarPC) microControlador

-- Funciones Auxiliares:

modificarEtiqueta :: String -> MicroInstruccion
modificarEtiqueta etiq microControlador = microControlador { etiqueta = etiq}

incrementarPC :: MicroInstruccion
incrementarPC microControlador = microControlador { programCounter = (programCounter microControlador) +1 }

dividirAcumuladores :: MicroInstruccion
dividirAcumuladores microControlador  = microControlador { acumuladorA = (acumuladorA microControlador `div` acumuladorB microControlador), acumuladorB = 0}

setearAcumuladorA :: Int -> MicroInstruccion
setearAcumuladorA val microControlador = microControlador {acumuladorA = val}

setearAcumuladorB :: Int -> MicroInstruccion
setearAcumuladorB val microControlador = microControlador { acumuladorB = val}

intercambiarAcumuladores :: MicroInstruccion
intercambiarAcumuladores microControlador = microControlador { acumuladorA = (acumuladorB microControlador), acumuladorB = (acumuladorA microControlador)}

sumaryPonerEnA :: MicroInstruccion
sumaryPonerEnA microControlador = microControlador { acumuladorA = (acumuladorA microControlador + acumuladorB microControlador), acumuladorB = 0}

partirListaYColocarEn :: Int -> Int -> MicroInstruccion
partirListaYColocarEn pos valor microControlador = microControlador {memoria = partirListaYAgregar pos valor (memoria microControlador)} 

partirListaYAgregar :: Int -> Int -> [Int] -> [Int]
partirListaYAgregar pos valor listaPos = (take (pos-1) listaPos) ++ [valor] ++ (drop (pos-1) listaPos)

sacarDeLista :: Int -> [Int] -> Int
sacarDeLista pos listaPos = (!!) listaPos (pos)

unMega :: [Posicion]
unMega = (replicate 1024 0)

-- Testing / Casos de prueba:

-- Punto 2: (nop.nop.nop) xt8088 ----> Correcto

-- Punto 3 : lodv 5 xt8088 -----> Correcto
-- Punto 3.1 : swap fp20 -----> Correcto
-- Punto 3.2 : (add.(lodv 22).swap.(lodv 10)) xt8088 ----> Correcto
-- Punto 3.3 : (divide.(lod 1).swap.(lod 2).(str 2 0).(str 1 2)) xt8088

-- Punto 4 : str 2 5 at8086 -----> Correcto
-- Punto 4.1 : lod 2 xt8088 -----> Correcto
-- Punto 4.2 : (divide.(setearAcumuladorA 2).(setearAcumuladorB 0)) xt8088 ----> Correcto
-- Punto 4.3 : (divide.(setearAcumuladorA 12).(setearAcumuladorB 4)) xt8088 -----> Correcto

fp20 = UnMicroControlador {
    memoria = unMega,
    acumuladorA = 7,
    acumuladorB = 24,
    programCounter = 0,
    etiqueta = ""
}

at8086 = UnMicroControlador {
    memoria = [1..20],
    acumuladorA = 0,
    acumuladorB = 0,
    programCounter = 0,
    etiqueta = ""
} 
