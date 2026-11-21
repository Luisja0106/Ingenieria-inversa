
#set page(
  paper: "a4",
  margin: (x: 2.2cm, top: 2.4cm, bottom: 2.4cm),
  header: context [
    #set text(size: 8pt, fill: luma(100))
    #grid(
      columns: (1fr, 1fr),
      align: (left, right),
      [Bitácora UML --- Análisis y Diseño de Sistemas II], [Fase 1: Ingeniería Inversa],
    )
    #v(0.2em)
    #line(length: 100%, stroke: 0.4pt + luma(180))
  ],
  footer: context [
    #set text(size: 8pt, fill: luma(100))
    #line(length: 100%, stroke: 0.4pt + luma(180))
    #v(0.2em)
    #grid(
      columns: (1fr, 1fr),
      align: (left, right),
      [Luis Javier Pérez], [Página #counter(page).display("1 de 1", both: true)],
    )
  ],
)

#set text(
  font: "Liberation Sans",
  size: 10pt,
  lang: "es",
  hyphenate: true,
  fill: luma(20),
)

#set par(
  justify: true,
  leading: 0.65em,
  spacing: 0.9em,
)

#set list(
  indent: 1em,
  body-indent: 0.5em,
  spacing: 0.6em,
  marker: [•],
)

#set table(
  inset: 6pt,
  stroke: 0.4pt + luma(180),
)
#show table: set text(size: 9pt)

#show heading.where(level: 1): it => block(
  above: 1.6em,
  below: 0.8em,
  width: 100%,
)[
  #text(size: 14pt, weight: "bold", fill: luma(10))[#it.body]
  #v(0.2em)
  #line(length: 100%, stroke: 0.8pt + luma(120))
]

#show heading.where(level: 2): it => block(
  above: 1.3em,
  below: 0.6em,
  width: 100%,
)[
  #text(size: 12pt, weight: "bold", fill: luma(20))[#it.body]
  #v(0.15em)
  #line(length: 100%, stroke: 0.4pt + luma(190))
]

#show heading.where(level: 3): it => block(
  above: 1.1em,
  below: 0.5em,
  width: 100%,
)[
  #text(size: 10.5pt, weight: "bold", fill: luma(30))[#it.body]
]

#show heading.where(level: 4): it => block(
  above: 1.2em,
  below: 0.45em,
  width: 100%,
)[
  #text(size: 10.5pt, weight: "bold", fill: luma(20))[#it.body]
]

#show heading.where(level: 5): it => block(
  above: 0.5em,
  below: 0.25em,
  width: 100%,
)[
  #text(size: 10pt, weight: "bold", fill: luma(15))[#it.body]
]

#let archivo(nombre, body) = block(
  width: 100%,
  inset: (left: 1.5em),
  above: 0.85em,
  below: 0.85em,
  breakable: true,
)[
  #heading(level: 5)[#nombre]
  #v(0.25em)
  #body
]

#align(center)[
  #v(0.4em)
  #text(size: 9pt, weight: "bold", fill: luma(80))[ANÁLISIS Y DISEÑO DE SISTEMAS II]
  #v(0.3em)
  #text(size: 17pt, weight: "bold", fill: luma(10))[Taller Ingeniería Inversa]
  #v(0.25em)
  #text(size: 10pt, fill: luma(60))[Luis Javier Pérez]
  #v(0.8em)
  #line(length: 100%, stroke: 0.5pt + luma(180))
  #v(0.8em)
]

= Fase 1: Ingeniería Inversa sin IA

== Reconocimiento y mapa del sistema

=== Primera impresión del código:

El sistema parece ser un proyecto relacionado con un laberinto, se divide en esta jerarquía de directorios:
- Laberinto
- Tablero
- basic
- queue
- search

A simple vista parece que el sistema es una especie de juego relacionado a un laberinto.

==== Laberinto

El paquete o directorio Laberinto parece ser el encargado de definir las partes y la lógica relacionada con el laberinto como tal, tales como la lógica de las casillas y definir la grilla o tabla que define el tablero jugable. Sus archivos son:

#archivo("Casilla")[
  Parece definir una casilla en el tablero, cuenta con atributos como fila y columna de tipo entero que parecen definir la ubicación de la casilla en concreto en el tablero, también cuenta con un atributo de estado de tipo String que parecen definir el estado de la casilla (por ejemplo ocupada, bloqueada, libre, etc.) al ser un String parece algo frágil, no está bien definido cuáles son los posibles estados.

  Cuenta con métodos relevantes como: compareTo, donde se compara con otra casilla y si la casilla está más arriba (en caso de que la fila sea mayor) o a la derecha (en caso de que la columna sea mayor) retornará 1, en caso de ser menor retornará -1  y en caso de ser igual retornará 0; y los métodos de movimiento los cuales aumentan o disminuyen en uno el valor actual de la casilla, lo cual puede indicar que realmente el tablero no sea un array de casillas como pensé originalmente, sino que casilla represente la posición de la punta del recorrido del usuario al recorrer el laberinto.
]

#archivo("Laberinto:")[
  Este archivo parece tener varias responsabilidades todas relacionadas con la grilla del laberinto, Se encarga de definir la grilla del laberinto utilizando una matriz de enteros, 10x15, contener los diferentes colores relacionados a las casillas basados en su estado, definir la meta y la salida junto a su posicion, contar con varios tableros escogibles. Entre sus metodos destacan: Un metodo para limpiar y reiniciar el laberinto, Un metodo para hacer una animacion en la GUI del laberinto siendo resuelto Y un metodo para modificar el tipo o estado de una casilla en especifico.
]

==== Tablero:
Este paquete es el encargado de manejar toda la logica y armado de la GUI del Software, esta enteramente escrito con la libreria de Swing. Sus Archivos relevantes son:

#archivo("MainThread:")[
  Extiende de la clase Thread y parece ser el encargado de gestionar la logica del hilo principal de la app, bloqueando acciones como modificar el tablero mientras es ejecutado.
]

#archivo("PanelTablero:")[
  Se encarga de definir por medio de un JPanel el panel del labrinto en la GUI ademas de gestionar eventos de mouse, para cambiar el estado de las casillas cuando se les hace click.
]

#archivo("LaberintoGUI:")[
  Se encarga de pintar toda la interfaz grafica del software, tales como botones, paneles y campos de texto.
]

==== basic:
Este paquete parece contener toda la logica relacionada con acciones y comportamientos basicos del funcionamiento del sistema en general. Sus Archivos relevantes son:

#archivo("Action:")[
  Es una interfaz que define el contrato a realizar por todas las acciones, cuenta con los metodos nombre el cual retorna el nombre de la accion, coste el cual retonrna el costo en casillas de un movimiento, posible el cual indica si una accion es posible, aplicar la cual ejecuta la accion.
]

#archivo("State:")[
  Interfaz que parece definir contrato que deben cumplir las instacias del estado global del juego o del laberinto, cuenta con los atributos, posible el cual retorna si una Action es posible, succesor el cual aplica una Action, copy devuelve una copia del estado actual, compareTo, devuelve 1 si la comparacion con otro estado es esactamente la misma, y 0 si no lo es.
]

#archivo("Node:")[
  Parece ser el encargado de definir un nodo en la solucion, cuenta con atributos como el estado actual del juego, la accion que lo llevo a ese estado, el nodo padre y el costo acumulado hasta ese nodo.
]

#archivo("Distacia:")[
  Parece ser una clase que contiene la informacion relacionada con la distancia restante de una casilla para alcanzar la meta.
]

#archivo("Problem:")[
  Parece modelar el problema en cuestion, pues se encarga de mostrar y resolver el laberinto, necesita como atributos el estado incial, la lista de acciones, y el objectivo final.
]
==== queue:
Parece ser un directorio con una gran cantidad de listas anidadas desde colas (LIFO) hasta stack (FIFO) el archivo destacado seria la interfaz Queue y el resto son simplemente implementaciones del contrato que define:

#archivo("Queue:")[
  Es una interfaz que parece definir el contrato basico de cualquier lista anidada, add, remove, get, isEmpty y size.
]

==== search:
Parece contener multiples metodos o formas de realizar buesquedas de soluciones para el laberinto, los archivos destacados son:
#archivo("Search:")[
  Es una interfaz que define el contrato que deben cumplir todos los metodos o formas de buscar solucion en el laberinto. Los cuales son: findSolution y findAllSolutions.
]
#archivo("NodeComparator")[
  Clase abstracta que implementa la interfaz Comparator del paquete java.utils, se encarga de definir los atributos y metodos que deben cumplir los diferentes comparadores.
]

=== Tras Ejecutar la app (Sin herramientas de depurado):
#v(1em)
El software parece ser un laberinto donde el usuario puede definir un laberinto y parece tener una especie de IA, donde el software por si mismo debe encontrar la posible salida, parece tener una animacion donde encuentra la posible solucion, parece que tiene varios modos de busqueda los cuales son:

- Profundidad
- Anchura
- Primero Mejor
- Profundidad iterativa
- Profundidad limitada
- A\*

parece que la Profundida Iterativa y Profundiad Limitada al usarse cuentan con un contador el cual va de 1 a 100.

#v(1em)
Parece que el laberinto es una grilla de cuadros (15x10) donde los cuadros de color negro son muros o bloqueos, los bloques amarillos son casillas libres, el bloque rojo es la salida, y el bloque azul la meta, al iniciar la busqueda se hace un camino de solucion de color gris.
#v(1em)

- La GUI cuenta con varios botones y secciones:
  - *Tipo de búsqueda:* Cuenta con varios radio buttons con los modos de búsqueda disponibles ya descritos anteriormente.
  - *El laberinto:* La grilla del laberinto con los bloques ya mencionados. Al hacer click en algún bloque hace toggle entre un bloque libre (amarillo) y uno negro (muro); sin embargo, esto no funciona con los bordes de la grilla que siempre son negros, ni con la meta y la salida, que se mantienen fijas.
  - *Zona de botones:*
    - *Botón Buscar:* Es el botón que inicia la secuencia donde se busca la salida. Cuando la secuencia se está ejecutando cambia al botón 'Detener'.
    - *Botón Detener:* Botón que detiene la secuencia en seco. Cuando la secuencia es detenida cambia de nuevo al botón 'Buscar'.
    - *Botón Pausar:* Parece ser un botón para detener la secuencia y permitir reanudarla. Al hacer click hace toggle a 'Reanudar', pero no parece funcionar y muestra diferentes problemas en la terminal.
    - *Botón Limpiar solución:* Limpia el camino de la solución para volver a intentar. Si se presiona mientras se ejecuta la búsqueda borra el camino gris recorrido hasta ese momento, pero no detiene la secuencia.
    - *Botón Borrar laberinto:* Borra todos los bloques dejando solo bloques libres (amarillos), a excepción de los bordes y los bloques de meta y salida. Al presionarlo mientras se ejecuta el programa no interrumpe el recorrido, pero sí borra todos los bloques en pantalla; esto parece indicar que la ruta óptima se calcula antes de mostrarla en pantalla y no mientras se va recorriendo.
  - *Zona inferior de resultados:* Muestra los resultados de la búsqueda, entre ellos:
    - *Found solution:* Parece ser un booleano que indica si se halló una posible solución.
    - *Array de direcciones:* Un array con la secuencia de direcciones en texto plano.
    - *Coste:* Parece ser el número total de casillas recorridas.
    - *Objeto final:* Parece ser un objeto que contiene el tiempo en milisegundos, junto con los enteros de 'Nodes generated', 'Nodes pending' y 'Nodes Visited'.
  - *Sección de animación:* Cuenta con un toggle button que al desactivarse no hace la animación de pintar la solución paso a paso sino que la muestra de forma instantánea, además de un slider para ajustar la velocidad. Al desactivar la animación el tiempo en ms pasa a ser menor, lo que parece indicar que es el tiempo de ejecución y no solo de cálculo.
  - *Botón spinner:* Un spinner button que va desde 1 hasta 100, disponible únicamente cuando el modo de búsqueda es Profundidad limitada o Profundidad iterativa.
  - *Combo box con laberintos:* Un combo box con diferentes opciones ('Default City', 'New york City', 'Chicago City', 'Bruxules City', 'London City', 'Worcralw city'). Al seleccionar una cambia el diseño del laberinto, manteniendo siempre el tamaño de 15x10, los bordes como muros y las posiciones fijas de entrada (1x3) y salida (15x8). Los cambios realizados se mantienen persistentes al cambiar entre laberintos, pero al reiniciar la app se reinician los cambios.

#pagebreak()

=== En Resumen:
#v(1em)
- El punto de entrada de la app es la clase LaberintoGUI pues es la que contiene el metodo estatico main que le indica a la JVM como debe compilar el codigo. Ademas de contar con una depencia directa a las librerias de java swing, awt, utils, io.

//TODO: Agregar el mapa de modulos

#v(1em)
- *Funciones Observables:*
  - Hallar Solucion: Se encarga de Ejecutar la logica necesaria para hallar la solucion de un laberinto en especifico. Es iniciada por el usuario por medio de la Interfaz grafica.
  - Animar Recorrido: Se encarga de gestionar la logica relacionada con una animacion que se muestra en la GUI. Es un proceso interno que solo ocurre si el usuario tiene la opcion activada.
  - Modificar el laberinto: Se encarga de gestionar la logica relacionada con la modificacion del esquema del laberinto, tal como modificar el estado de una casilla para transformarla de un bloqueo o muro a una libre y viceversa, limpiar el recorrido realizado, y limpiar completamente el laberinto. Es una accion que debe ser lanzada por el usuario por medio de la interfaz grafica.
  - Mostrar informacion: Se encarga de Mostrar en la GUI informacion relevante con la solucion realizada, desde listar los pasos mostrar el costo en pasos de la solucion, mostrar informacion relevante con los nodos. Es un proceso Interno.
  - Movimiento: Se encarga de toda la logica relacionada para realizar movimiento necesario para llegar a la solucion. Es un proceso interno.

#v(1em)
- *Incertidumbres:*
  - No es claro como es el flujo de acciones del sistema, es decir se sabe mas o menos quien inicia el sistema y las responsabilidades de cada pieza, sin embargo es complicado de explicar o evidenciar como es el flujo que lleva a cabo el sistema para llevar a cabo una accion.
  - Como funcionan los metodos de busqueda, es claro cual es su objectivo pero es complejo y algo abstracto ser capaz de ver y evidenciar como funcionan realmente, que clase de logica utilizan y por que si todos hacen lo mismo sus resultados son tan diferentes.
  - Por que existen tantas listas anidadas, todas realizan lo mismo, pero simplemente viendo el codigo no es claro evidenciar por que se necesitan tantas, y simplemente ejecutando el sistema sin depurar no es claro ver que tipo de lista anidad esta usandose.
