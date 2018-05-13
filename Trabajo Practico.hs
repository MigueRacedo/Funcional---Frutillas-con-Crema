import Text.Show.Functions
import Data.List

-- Definicion de tipos y de Data:

data MicroControlador = UnMicroControlador {memoria::[Posicion],acumuladorA::Int,acumuladorB::Int,programCounter::Int,etiqueta::String,programa::[Instruccion]} deriving (Show)

type Posicion = Int

type Instruccion = MicroControlador -> MicroControlador

type MicroInstruccion = MicroControlador -> MicroControlador


xt8088 = UnMicroControlador {
    memoria = unMega,
    acumuladorA = 0,
    acumuladorB = 0,
    programCounter = 0,
    etiqueta = "",
    programa = [(lodv 3),swap]

}

-- (str 2 0),(str 1 3),(lodv 0),(lodv 133),nop, swap

memoriaInfinita = UnMicroControlador {
    memoria = infinitaEnCero,
    acumuladorA = 25,
    acumuladorB = 50,
    programCounter = 0,
    etiqueta = "",
    programa = [add,(lodv 22),swap,(lodv 10)]
}

-- Programas:

estaOrdenadaLaMemoria :: MicroControlador -> Bool
estaOrdenadaLaMemoria micro = (memoria micro) == (sort (memoria micro))

ejecutarSiNoHayError :: MicroControlador -> Instruccion -> MicroControlador
ejecutarSiNoHayError microControlador instruccion 
                                                | (noHayErrores microControlador) = (incrementarPC.instruccion) microControlador
                                                | otherwise = microControlador

noDejaTodoEnCero :: MicroControlador -> Instruccion -> Bool
noDejaTodoEnCero micro instr = not((ambosAcumuladoresEnCero.instr) micro)  || not((memoriaVacia.instr) micro)

cargarPrograma :: [Instruccion] -> MicroControlador -> MicroControlador
cargarPrograma program microControlador = microControlador {programa = program }

ejecutarPrograma ::  MicroControlador -> MicroControlador 
ejecutarPrograma microControlador = foldl (ejecutarSiNoHayError) microControlador (programa microControlador)

depurarPrograma :: [Instruccion] -> MicroControlador -> [Instruccion]
depurarPrograma listaPos micro = filter (noDejaTodoEnCero micro) listaPos

ifnz :: MicroControlador -> MicroControlador
ifnz micro
                |((acumuladorA micro) /= 0) = ejecutarPrograma micro
                | otherwise = micro

-- Instrucciones:s

nop :: Instruccion
nop microControlador = id microControlador

add :: Instruccion
add microControlador = sumaryPonerEnA microControlador

divide :: Instruccion 
divide microControlador | ((acumuladorB microControlador) /= 0) = dividirAcumuladores microControlador
                        | otherwise = (modificarEtiqueta "Division Por Cero") microControlador

swap :: Instruccion
swap microControlador = intercambiarAcumuladores microControlador

lod :: Int -> Instruccion
lod addr microControlador = (setearAcumuladorA (sacarDeLista addr (memoria microControlador))) microControlador

str :: Int -> Int -> Instruccion
str addr val microControlador = partirListaYColocarEn addr val microControlador

lodv :: Int -> Instruccion
lodv val microControlador = (setearAcumuladorA val) microControlador

-- Funciones Auxiliares:

infinitaEnCero :: [Posicion]
infinitaEnCero = (repeat 0)

noHayErrores :: MicroControlador -> Bool
noHayErrores micro = (etiqueta micro == "")

ordenarMemoriaAscendente :: MicroControlador -> MicroControlador
ordenarMemoriaAscendente micro = micro {memoria = (sort (memoria micro))}

memoriaVacia :: MicroControlador -> Bool
memoriaVacia micro = all (== 0) (memoria micro)

ambosAcumuladoresEnCero :: MicroControlador -> Bool
ambosAcumuladoresEnCero micro = ((acumuladorA micro) == 0) && (acumuladorB micro) == 0

modificarEtiqueta :: String -> MicroInstruccion
modificarEtiqueta etiq microControlador = microControlador { etiqueta = etiq}

incrementarPC :: MicroInstruccion
incrementarPC microControlador = microControlador { programCounter = (programCounter microControlador) +1 }

dividirAcumuladores :: MicroInstruccion
dividirAcumuladores microControlador  = microControlador { acumuladorA = ((acumuladorA microControlador) `div` (acumuladorB microControlador)), acumuladorB = 0}

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
partirListaYAgregar pos valor listaPos = (take (pos-1) listaPos) ++ [valor] ++ (drop (pos) listaPos)

sacarDeLista :: Int -> [Int] -> Int
sacarDeLista pos listaPos = (!!) listaPos (pos-1)

unMega :: [Posicion]
unMega = (replicate 1024 0)


-- ENTREGA 2:

-- Puntos Teoricos 3.6

-- ¿Qué sucede al querer cargar y ejecutar el programa que suma 10 y 22 en el procesador con memoria infinita? : Se ejecuta normalmente, ya que no implica ningun acceso a la memoria infinita.

-- ¿Y si queremos saber si la memoria está ordenada (punto anterior)? : Va a quedar infinitamente esperando ,ya que siempre esta buscando un valor entero mayor al actual para comprobar que todo este 
-- ordenado de forma creciente-

-- Casos de prueba Entrega 2:

-- 4.2 : 
--  4.2.1: EjecutarPrograma suma de 10+22 en xt8088 ------> Correcto
--  4.2.2: EjecutarPrograma de division por cero en xt8088 ------> Correcto

-- 4.3:
--  4.3.1: ifnz ((lodv 3),swap) fp20 -----> Correcto
--  4.3.2: ifnz ((lodv 3),swap) xt8088 -----> Correcto

-- 4.4
--  4.4.1: depurarPrograma [((str 2 0),(str 1 3),(lodv 0),(lodv 133),(nop),(swap))] xt8088 ----> Correcto








-- ENTREGA 1:

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
    etiqueta = "",
    programa = [(lodv 3), swap]
}

at8086 = UnMicroControlador {
    memoria = [1..20],
    acumuladorA = 0,
    acumuladorB = 0,
    programCounter = 0,
    etiqueta = "",
    programa = []
} 
