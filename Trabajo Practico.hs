import Text.Show.Functions
import Data.List

-- Definicion de tipos y de Data:

data MicroControlador = UnMicroControlador {memoria::[Posicion],acumuladorA::Int,acumuladorB::Int,programCounter::Int,etiqueta::String,programa::[Instruccion]} deriving (Show)

type Posicion = Int

type Instruccion = MicroControlador -> MicroControlador

type MicroInstruccion = MicroControlador -> MicroControlador

type Programa = [Instruccion]


xt8088 = UnMicroControlador {
    memoria = unMega,
    acumuladorA = 0,
    acumuladorB = 0,
    programCounter = 0,
    etiqueta = "",
	programa = []

}

--SegundaEntrega:

suma10y22 :: Programa                     
suma10y22 = [lodv 10, swap, lodv 22, add] 

suma :: Int -> Int -> Programa
suma num1 num2 = [lodv num1, swap, lodv num2, add]

division2por0 :: Programa                                
division2por0 = [str 1 2,str 2 0,lod 2,swap,lod 1,divide]   

division :: Int -> Int -> Programa
division num1 num2 = [str 1 num1,str 2 num2,lod 2,swap,lod 1,divide]

cargarPrograma :: Programa -> MicroControlador -> MicroControlador
cargarPrograma nuevoPrograma micro = micro {programa = nuevoPrograma}

ejecutarPrograma :: MicroControlador -> MicroControlador
ejecutarPrograma micro = foldl (ejecutarInstruccion.incrementarPC) micro (programa micro)

ifnz :: Instruccion
ifnz micro 
		| ((acumuladorA micro) /= 0) = ejecutarPrograma micro
		| otherwise = (modificarEtiqueta "Acumulador A es cero") micro
		
--depurarPrograma :: MicroControlador -> MicroControlador
--depurarPrograma micro | not estaTodoEn0(ejecutarPrograma micro) =

estaOrdenadaLaMemoria :: MicroControlador -> Bool
estaOrdenadaLaMemoria micro = (memoria micro) == (sort (memoria micro))


--Instrucciones:

nop :: Instruccion
nop = id

add :: Instruccion
add microControlador = sumaryPonerEnA microControlador

divide :: Instruccion 
divide microControlador | ((acumuladorB microControlador)==0) = modificarEtiqueta "Division Por Cero" microControlador
                        | otherwise = dividirAcumuladores microControlador

swap :: Instruccion
swap microControlador = intercambiarAcumuladores microControlador

lod :: Int -> Instruccion
lod addr microControlador = setearAcumuladorA (sacarDeLista addr (memoria microControlador)) microControlador

str :: Int -> Int -> Instruccion
str addr val microControlador = partirListaYColocarEn addr val microControlador

lodv :: Int -> Instruccion
lodv val microControlador = setearAcumuladorA val microControlador

-- Funciones Auxiliares:

modificarEtiqueta :: String -> MicroInstruccion
modificarEtiqueta etiq microControlador = microControlador { etiqueta = etiq}

incrementarPC :: MicroInstruccion
incrementarPC microControlador = microControlador { programCounter = (programCounter microControlador) + 1 }

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
partirListaYAgregar pos valor listaPos = (take (pos-1) listaPos) ++ valor : (drop pos listaPos)

sacarDeLista :: Int -> [Int] -> Int
sacarDeLista pos listaPos = (!!) listaPos (pos-1)

ejecutarInstruccion :: MicroControlador -> Instruccion -> MicroControlador
ejecutarInstruccion micro instruccion = instruccion $ micro

estaTodoEn0 :: MicroControlador -> Bool
estaTodoEn0 micro = (estaVaciaMemoria micro) && (estanEn0Acumuladores micro)

estaVaciaMemoria :: MicroControlador -> Bool
estaVaciaMemoria micro = all (==0) (memoria micro)

estanEn0Acumuladores :: MicroControlador -> Bool
estanEn0Acumuladores micro = ((acumuladorA micro) == 0) && ((acumuladorB micro) == 0)

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
    etiqueta = "",
	programa = []
}

at8086 = UnMicroControlador {
    memoria = [1..20],
    acumuladorA = 0,
    acumuladorB = 0,
    programCounter = 0,
    etiqueta = "",
	programa = []
} 
