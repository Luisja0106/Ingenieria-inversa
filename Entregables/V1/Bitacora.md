# Primeras Impresiones

## Gerarquia de archivos

Parece ser un proyecto relacionado con un laberinto, se divide en esta gerarquia de directorios:

- Laberinto
- Tablero
- basic
- queue
- search

Es decir parece ser un software relacionado con un laberinto, a simple vista se podria decir que el directorio Laberinto se encargara de definir las partes del laberinto, tablero parece ser encargado de crear el componente del tablero y la logica relacionada a el, podria ser un juego?, basic supongo que son cosas basicas como movimientos queue tal vez la cola de movimiento y search no lo se taodavia

## Despues de ejecutarlo por primera vez

- El software parece ser un laberinto donde el usuario puede definir un laberinto y parece tener una especie de IA, donde el software por si mismo debe encontrar la posible salida, parece tener una animacion donde encuentra la posible solucion, parece que tiene varios modos de busqueda los cuales son:

  - Profundidad
  - Anchura
  - Primero Mejor
  - Profundidad iterativa
  - Profundidad limitada
  - A*

  desconosco la diferencia entre ellos, parece que la **Profundida Iterativa** y **Profundiad Limitada** al usarse cuentan con un contador el cual va de 1 a 100, desconosco su funcion todavia.

- parece que el laberinto es una grilla de cuadros (15x10) donde los cuadros de color negro son muros o bloqueos, los bloques amarillos son casillas libres, el bloque rojo es la salida, y el bloque azul la meta, al iniciar la busqueda se hace un camino de solucion de color gris.

- La GUI cuenta con varios botones y seciones:
  - Tipo de busqueda:
    Varios radio buttons con los tipos o modos de busqueda ya descritos anteriormente
  - El laberito:
    La grilla del laberinto, con los bloques mencionados anteriormente, al hacer click en algun bloque hace toogle entre un bloque libre (amarillo) y uno negro(muro) sin embargo no funciona con los bordes de la grilla los cuales siempre son negros, al igual con la meta y salida, parecen ser fijas.
  - Zona de botones:
    - boton buscar: El boton que inicia la secuencia donde el rojo busca la salida. cunado la secuencia esta siendo ejecutada cambia al boton detener
    - boton Detener: boton que detiene la secuencia en seco. cunado la secuencia es detenida cambia al boton buscar.
    - boton pausar: supongo que es un boton que detiene la secuencia pero permite reanudarla, no parece funcionar y al precionarlo en mitad de una secuencia la terminal muestra diferentes problemas. cunado se hace click hace toggle a "reanudar" pero no parece funcionar.
    - boton Limpiar solucion: limpia el camino de solucion para volver a intentar, si se preciona mientras se ejecuta la busqueda borra el camino gris que habia cruzado hasta ese momento el bloque rojo pero no detiene la secuencia, se desconoce si es intencional.
    - boton borrar laberinto: borra todos bloques dejando solo bloques libres (amarillos), a excepcion de los bloques de los bordes y el bloque de la meta y el bloque de salida, estos dos bloques seran fijos? al precionare mientras se ejecuta el programa no interrumpe el reccorido (es decir aunque no existan los bloques el recorrido es el mismo) pero si borra todos los bloques para dejar las cacillas amarillas, esto parece indicar que los para calcular la ruta optima se hace antes de mostrarlo en pantalla es decir no se va hayndo la solucion mientras se recorre (como haria un robot por ejemplo) si no que hace la solucion y luego solo la traza.
  - Zona inferior de resultados:
    Muestra un resultado de la busqueda, entre ellos esta:
    - Found solution: parece ser un boleano que indica si se hallo una posible solucion.
    - Array de direcciones: Un array con las direcciones hechas en texto plano (ej ['derecha', 'arriba', 'abajo'...])
    - Coste: parece ser el numero total de casillas recorridas un numero plano.
    - objecto final: parece ser un objecto(esta encerrado en {}) que contiene el tiempo en milisegundos (ej 1ms), Nodes generated: No se que significa esto pero es un numero parece ser entero, Nodes pending: al igual que el anterior no se a que se refiere pero tambien parece ser un numero entero, Nodes Visited: igual que los dos anteriores.
  - animation section:
    Un togle button que si se desactiva no se hace la animacion de pintar la solucion manualmente si no que se muestra instanteneamente, tambien cuenta con un slider que permite ajustar la velocidad de la animacion, esto parece darle fuerza a la teoria de que la solucion se hace antes de mostrarla y no mientras se recorre, ademas el tiempo en ms que se muestra en la seccion anterior pasa de 4ms (en la prueba realizada) a 1ms, (en el mismo laberinto) lo cual quiere decir que es el tiempo de ejecucion no de calculo.
  - buton spiner: un spinner button que va desde 1 hasta 100, solo esta disponible cuando el modo de busqueda es Profundidad limitada o Profundidad Iterativa, desconosco lo que hace.
  - Combo box con laberintos: un combo box con diferentes opciones "Default City", "New york City", "Chicago City", "Bruxules City", "London City", "Worcralw city", todas parecen ser ciudades de EEUU al seleccionar una cambia el diseño del laberinto, es decir parecen ser laberintos predefinidos, lo unico que no cambia entre ellos es el tamaño del laberinto, siempre es 15x10, y los bordes del laberintos siempre son muros, y la posicion de la entrada y la salida (entrada: 1x3, salida:15x8) pueden ser obligatorios para el correcto funcionamiento del software? al borrar un laberinto con el boton borrar laberinto, y cambiar de laberinto y volver al laberinto previamente borrado (ej: new york city borrado -> Chicago city -> new york city) el laberinto borrado se mantiene borrado, al igual con cambios hechos por el usuario, es decir los cambios son persistentes, pero al cerrar el programa y volverlo a abrir se reinician los cambios asi que son persistentes hasta que se cierre la app.
