# vhdl-multiplicador-secuencial-32bits
# Introducción
Una implementación frecuente de la operación de multiplicación dentro de sistemas digitales de bajo costo consiste en la realización de la misma por pasos sucesivos, utilizando registros de desplazamiento y una máquina de estado para guiar el desarrollo.

Inicialmente los valores de los operandos se cargan en los registros de entrada. El registro del multiplicador es también un registro de desplazamiento a derecha. Una vez cargados los operandos, el procedimiento de la multiplicación funciona como la multiplicación en papel, donde el multiplicando se multiplica por cada uno de los bits de multiplicador, sumando los resultados con los desplazamientos adecuados.

Para el multiplicador se va rotando hacia la derecha, y dependiendo del valor del bit menos significativo en cada momento se decide sumar o no sumar el multiplicando al acumulador.
Simultáneamente, el acumulador también se rota hacia la derecha luego de cada suma, para generar el mismo efecto que tienen los desplazamientos hacia la izquierda de que se hacen en la multiplicación en papel para los dígitos de mayor orden del multiplicando.

# Modulos
## MULTIPLICADORSECUENCIAL 
Este diagrama utiliza varios módulos que se encuentran definidos en los diagramas restantes.

## REGISTRO32
Registro de almacenamiento de 32 bits de ancho.

## SETZERO
Módulo anulador de valor que se utiliza como multiplicador por 1 o 0.

##SUMADOR32
Sumador de 32 bits ancho con acarreo de salida.

## SHIFTBOX
Rotador de 1 bit a la derecha.

## CNT31
Temporizador que cuenta 32 ciclos de reloj.

## REGDESP32
Registro de desplazamiento a derecha, con carga paralela y salida también paralela.

## REGDESP32SINCARGA
Registro de desplazamiento a derecha, con carga serial y salida paralelo.

## SM
La máquina de estados que regula el funcionamiento del resto de los módulos.

## TESTMULTIPLICADORSECUENCIAL
Vector de prueba que debe satisfacer su diseño. Ejercita el diseño mediante una serie de multiplicaciones para verificar su funcionamiento.

# Definición de puertos de los módulos principales
## REGISTRO32
Registro de almacenamiento. Memoriza un valor de entrada de 32 bits.

**Entradas:**

DATAIN[31..0]: Puerto sincrónico de entrada al registro.

HOLD: Señal sincrónica de comando. Si HOLD = 1, el registro conserva su valor; si HOLD = 0, el registro memoriza el valor en DATAIN. CLK Reloj de sistema. Activo en flanco ascendente.

nRST: Reset asincrónico del sistema. Activo en bajo.

**Salidas**

DATAOUT[31..0]: Valor almacenado en el registro.

## REGDESP32

Este módulo es un registro de desplazamiento a derecha, con carga en paralelo y salida paralelo.

**Entradas:**

DATAIN[31..0]: Puerto sincrónico de carga del registro.

LOAD: Si vale 1, el registro carga el valor presente en el puerto de datos paralelo
DATAIN. Si vale 0, el registro desplaza el valor almacenado internamente, ingresando un cero en la posición del bit de mayor orden.

CLK: Señal de reloj del sistema. Activo en flanco ascendente.

nRST: Reset asincrónico del sistema. Activo en bajo.

**Salidas**

DATAOUT[31..0]: Es el valor almacenado por el registro.

## REGDESP32SINCARGA
Este módulo es un registro de desplazamiento a derecha, con entrada serial y salida paralelo. Cada flanco ascendente del
reloj de entrada provoca el desplazamiento hacia la derecha de los bits contenidos en el registro; el valor de BITIN entra tomando la posición del bit más significativo del registro rotado.

**Entradas:**

BITIN: Entrada serie del registro. Su valor toma la posición del bit más significativo luego de cada rotación del registro.

CLK: Señal de reloj del sistema. Activo en flanco ascendente.

nRST: Reset asincrónico del sistema. Activo en bajo.

**Salidas**

DATAOUT[31..0]: Es el valor almacenado por el registro.

## SETZERO
Es un anulador de valor. En el multiplicador este módulo se utiliza como un multiplicador elemental que puede multiplicar por uno o cero.

**Entradas:**

IVALUE[31..0]: Valor de entrada.

ZERO: Señal de control. Si ZERO = 0, entonces OVALUE = IVALUE. Si ZERO = 1, OVALUE = 0x00000000.

**Salidas:**

OVALUE[31..0] Puerto de datos de salida.

## SUMADOR32
Sumador de 32 bits.

**Entradas:**

INPUTA[31..0]: Primer operando de la suma.

INPUTB[31..0]: Segundo operando de la suma.

CIN: Acarreo de entrada.

**Salidas:**

RESULT[31..0]: Resultado de la suma.

COUT: Acarreo de salida.

## SHIFTBOX
Módulo de desplazamiento bits. En su salida DATAOUT aparece el valor DATAIN desplazado un bit a la derecha(DATAOUT[0] = DATAIN[1], DATAOUT[1] = DATAIN[2], DATAOUT[2] = DATAIN[3], etc.). En DATAOUT[31] se coloca el valor del puerto de entrada BITIN.

El bit DATAIN[0], que se descarta en la rotación, sale por BITOUT.

**Entradas:**

DATAIN[31..0]: Palabra de 32 bits a desplazar a derecha.

BITIN: Bit que se introduce en el bit de mayor orden de la palabra desplazada.

**Salidas:**

DATAOUT[31..0]: Palabra cuyos 31 bits inferiores son los 31 bit superiores de DATAIN, y cuyo bit de mayor orden toma el valor de BITIN. 

BITOUT: Toma el valor de DATAIN[0].

## CNT31
Contador de ciclos, módulo 32. El valor del contador no es visible externamente.

El módulo tiene una única salida, FULLCOUNT, que indica que el valor interno del contador es 31 (y que por ende hará roll-over en el ciclo siguiente).
Este módulo es de utilidad para permitir a la máquina de estado saber cuando han transcurrido 32 ciclos de reloj.

**Entradas:**

ENABLE: Señal sincrónica de control. Si ENABLE = 0, el contador interno conserva su valor. Si ENABLE = 1, cada ciclo de reloj incrementa en uno el contador interno.

CLK: Reloj del sistema. Activo en flanco ascendente.

nRST: Reset asincrónico del sistema. Activo en nivel bajo. Luego del reset, el valor del contador interno toma el valor cero.

**Salidas:**

FULLCOUNT: Vale 1 si el contador interno vale 31.

## SM
Es la máquina de estado que dirige el funcionamiento del multiplicador. Su diagrama de transiciones y su definición de salidas son los siguientes:

![imagen](https://user-images.githubusercontent.com/42872959/170887017-4b0533a2-e749-46c1-abcb-ee50e4bd57dc.png)

| ESTADO | SALIDAS |
| ------------- | ------------- |
| WAIT  | LOADOPS = 1 READY = 1 ENABLECNT = 0 LATCHRESULT = 0  |
| CALC  | LOADOPS = 0 READY = 0 ENABLECNT = 1 LATCHRESULT = 0  |
| STO   | LOADOPS = 0 READY = 0 ENABLECNT = 0 LATCHRESULT = 1  |

**Entradas:**

START: Señal sincrónica de arranque. Un 1 en esta línea hace que la máquina comience el proceso de realizar la multiplicación.

FULLCOUNT: Señal sincrónica que proviene del contador CNT31. Indica que transcurrieron 32 ciclos de reloj.

CLK: Señal de reloj del sistema. Activo en flanco de subida.

nRST: Reset asincrónico del sistema. Activo en nivel bajo.

**Salidas**

LOADOPS: Instrucción a los registros de entrada para que retengan el valor de los operandos de entrada.

READY: Vale 1 cuando el sistema se encuentra listo para comenzar una nueva multiplicación.

ENABLECNT: Habilita el avance del contador CNT31, para contar la cantidad de ciclos transcurridos.

LATCHRESULT: Instruye al registro que almacena el resultado final a que almacene su valor.
