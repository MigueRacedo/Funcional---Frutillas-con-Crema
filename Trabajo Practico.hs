data MicroControlador = MicroControlador [Posicion] AcumuladorA AcumuladorB ProgramCounter Etiqueta

type Posicion = Int
type AcumuladorA = Int
type AcumuladorB = Int
type ProgramCounter = Int
type Etiqueta = String

posiciones :: MicroControlador -> [Int]
posiciones (MicroControlador lista _ _ _ _) = lista

acumuladorA :: MicroControlador -> Int
acumuladorA (MicroControlador _ a _ _ _) = a

acumuladorB :: MicroControlador -> Int
acumuladorB (MicroControlador _ _ b _ _) = b

programCounter :: MicroControlador -> Int
programCounter (MicroControlador _ _ _ pc _) = pc

etiqueta :: MicroControlador -> String
etiqueta (MicroControlador _ _ _ _ et) = et