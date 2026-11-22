
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
  Parece definir una casilla en el tablero, cuenta con atributos como fila y columna de tipo entero que parecen definir la ubicación de la casilla en concreto en el tablero, también cuenta con un atributo de estado de tipo String que parecen definir el estado de la casilla (por ejemplo, ocupada, bloqueada, libre, etc.), al ser un String parece algo frágil, no está bien definido cuáles son los posibles estados.

  Cuenta con métodos relevantes como: compareTo, donde se compara con otra casilla y si la casilla está más arriba (en caso de que la fila sea mayor) o a la derecha (en caso de que la columna sea mayor) retornará 1, en caso de ser menor retornará -1 y en caso de ser igual retornará 0; y los métodos de movimiento los cuales aumentan o disminuyen en uno el valor actual de la casilla, lo cual puede indicar que realmente el tablero no sea un array de casillas como pensé originalmente, sino que casilla represente la posición de la punta del recorrido del usuario al recorrer el laberinto.
]

#archivo("Laberinto:")[
  Este archivo parece tener varias responsabilidades, todas relacionadas con la grilla del laberinto. Se encarga de definir la grilla del laberinto utilizando una matriz de enteros, 10x15, contener los diferentes colores relacionados a las casillas basados en su estado, definir la meta y la salida junto a su posición, contar con varios tableros escogibles. Entre sus métodos destacan: un método para limpiar y reiniciar el laberinto, un método para hacer una animación en la GUI del laberinto siendo resuelto y un método para modificar el tipo o estado de una casilla en específico.
]

==== Tablero:
Este paquete es el encargado de manejar toda la lógica y armado de la GUI del software, está enteramente escrito con la librería de Swing. Sus archivos relevantes son:

#archivo("MainThread:")[
  Extiende de la clase Thread y parece ser el encargado de gestionar la lógica del hilo principal de la app, bloqueando acciones como modificar el tablero mientras es ejecutado.
]

#archivo("PanelTablero:")[
  Se encarga de definir por medio de un JPanel el panel del laberinto en la GUI, además de gestionar eventos de mouse para cambiar el estado de las casillas cuando se les hace click.
]

#archivo("LaberintoGUI:")[
  Se encarga de pintar toda la interfaz gráfica del software, tales como botones, paneles y campos de texto.
]

==== basic:
Este paquete parece contener toda la lógica relacionada con acciones y comportamientos básicos del funcionamiento del sistema en general. Sus archivos relevantes son:

#archivo("Action:")[
  Es una interfaz que define el contrato a realizar por todas las acciones, cuenta con los métodos: nombre, el cual retorna el nombre de la acción; coste, el cual retorna el costo en casillas de un movimiento; posible, el cual indica si una acción es posible; aplicar, la cual ejecuta la acción.
]

#archivo("State:")[
  Interfaz que parece definir contrato que deben cumplir las instancias del estado global del juego o del laberinto, cuenta con los atributos: posible, el cual retorna si una Action es posible; succesor, el cual aplica una Action; copy, devuelve una copia del estado actual; compareTo, devuelve 1 si la comparación con otro estado es exactamente la misma, y 0 si no lo es.
]

#archivo("Node:")[
  Parece ser el encargado de definir un nodo en la solución, cuenta con atributos como el estado actual del juego, la acción que lo llevó a ese estado, el nodo padre y el costo acumulado hasta ese nodo.
]

#archivo("Distacia:")[
  Parece ser una clase que contiene la información relacionada con la distancia restante de una casilla para alcanzar la meta.
]

#archivo("Problem:")[
  Parece modelar el problema en cuestión, pues se encarga de mostrar y resolver el laberinto, necesita como atributos el estado inicial, la lista de acciones y el objetivo final.
]
==== queue:
Parece ser un directorio con una gran cantidad de listas anidadas desde colas (LIFO) hasta stack (FIFO), el archivo destacado sería la interfaz Queue y el resto son simplemente implementaciones del contrato que define:

#archivo("Queue:")[
  Es una interfaz que parece definir el contrato básico de cualquier lista anidada: add, remove, get, isEmpty y size.
]

==== search:
Parece contener múltiples métodos o formas de realizar búsquedas de soluciones para el laberinto, los archivos destacados son:
#archivo("Search:")[
  Es una interfaz que define el contrato que deben cumplir todos los métodos o formas de buscar solución en el laberinto. Los cuales son: findSolution y findAllSolutions.
]
#archivo("NodeComparator")[
  Clase abstracta que implementa la interfaz Comparator del paquete java.utils, se encarga de definir los atributos y métodos que deben cumplir los diferentes comparadores.
]

=== Tras Ejecutar la app (Sin herramientas de depurado):
#v(1em)
El software parece ser un laberinto donde el usuario puede definir un laberinto y parece tener una especie de IA, donde el software por sí mismo debe encontrar la posible salida, parece tener una animación donde encuentra la posible solución, parece que tiene varios modos de búsqueda los cuales son:

- Profundidad
- Anchura
- Primero Mejor
- Profundidad iterativa
- Profundidad limitada
- A\*

Parece que la Profundidad Iterativa y Profundidad Limitada al usarse cuentan con un contador el cual va de 1 a 100.

#v(1em)
Parece que el laberinto es una grilla de cuadros (15x10) donde los cuadros de color negro son muros o bloqueos, los bloques amarillos son casillas libres, el bloque rojo es la salida, y el bloque azul la meta, al iniciar la búsqueda se hace un camino de solución de color gris.
#v(1em)

- La GUI cuenta con varios botones y secciones:
  - *Tipo de búsqueda:* Cuenta con varios radio buttons con los modos de búsqueda disponibles ya descritos anteriormente.
  - *El laberinto:* La grilla del laberinto con los bloques ya mencionados. Al hacer click en algún bloque hace toggle entre un bloque libre (amarillo) y uno negro (muro); sin embargo, esto no funciona con los bordes de la grilla que siempre son negros, ni con la meta y la salida, que se mantienen fijas.
  - *Zona de botones:*
    - *Botón Buscar:* Es el botón que inicia la secuencia donde se busca la salida. Cuando la secuencia se está ejecutando cambia al botón 'Detener'.
    - *Botón Detener:* Botón que detiene la secuencia en seco. Cuando la secuencia se detiene cambia de nuevo al botón 'Buscar'.
    - *Botón Pausar:* Parece ser un botón para detener la secuencia y permitir reanudarla. Al hacer click hace toggle a 'Reanudar', pero no parece funcionar y muestra diferentes problemas en la terminal.
    - *Botón Limpiar solución:* Limpia el camino de la solución para volver a intentar. Si se presiona mientras se ejecuta la búsqueda, borra el camino gris recorrido hasta ese momento, pero no detiene la secuencia.
    - *Botón Borrar laberinto:* Borra todos los bloques dejando solo bloques libres (amarillos), a excepción de los bordes y los bloques de meta y salida. Al presionarlo mientras se ejecuta el programa, no interrumpe el recorrido, pero sí borra todos los bloques en pantalla; esto parece indicar que la ruta óptima se calcula antes de mostrarla en pantalla y no mientras se va recorriendo.
  - *Zona inferior de resultados:* Muestra los resultados de la búsqueda, entre ellos:
    - *Found solution:* Parece ser un booleano que indica si se halló una posible solución.
    - *Array de direcciones:* Un array con la secuencia de direcciones en texto plano.
    - *Coste:* Parece ser el número total de casillas recorridas.
    - *Objeto final:* Parece ser un objeto que contiene el tiempo en milisegundos, junto con los enteros de 'Nodes generated', 'Nodes pending' y 'Nodes Visited'.
  - *Sección de animación:* Cuenta con un toggle button que al desactivarse no hace la animación de pintar la solución paso a paso, sino que la muestra de forma instantánea, además de un slider para ajustar la velocidad. Al desactivar la animación, el tiempo en ms pasa a ser menor, lo que parece indicar que es el tiempo de ejecución y no solo de cálculo.
  - *Botón spinner:* Un spinner button que va desde 1 hasta 100, disponible únicamente cuando el modo de búsqueda es Profundidad limitada o Profundidad iterativa.
  - *Combo box con laberintos:* Un combo box con diferentes opciones ('Default City', 'New york City', 'Chicago City', 'Bruxules City', 'London City', 'Worcralw city'). Al seleccionar una, cambia el diseño del laberinto, manteniendo siempre el tamaño de 15x10, los bordes como muros y las posiciones fijas de entrada (1x3) y salida (15x8). Los cambios realizados se mantienen persistentes al cambiar entre laberintos, pero al reiniciar la app se reinician los cambios.

#pagebreak()

=== En Resumen:
#v(1em)
- El punto de entrada de la app es la clase LaberintoGUI pues es la que contiene el método estático main que le indica a la JVM cómo debe compilar el código. Además de contar con una dependencia directa a las librerías de java swing, awt, utils, io.

#v(4em)

#figure(
  image("assets/Modulos.drawio.png"),
  caption: [Diagrama de modulos del sistema],
)

#pagebreak()
- *Funciones Observables:*
  - Hallar Solución: Se encarga de ejecutar la lógica necesaria para hallar la solución de un laberinto en específico. Es iniciada por el usuario por medio de la interfaz gráfica.
  - Animar Recorrido: Se encarga de gestionar la lógica relacionada con una animación que se muestra en la GUI. Es un proceso interno que solo ocurre si el usuario tiene la opción activada.
  - Modificar el laberinto: Se encarga de gestionar la lógica relacionada con la modificación del esquema del laberinto, tal como modificar el estado de una casilla para transformarla de un bloqueo o muro a una libre y viceversa, limpiar el recorrido realizado y limpiar completamente el laberinto. Es una acción que debe ser lanzada por el usuario por medio de la interfaz gráfica.
  - Mostrar información: Se encarga de mostrar en la GUI información relevante con la solución realizada, desde listar los pasos, mostrar el costo en pasos de la solución, mostrar información relevante con los nodos. Es un proceso interno.
  - Movimiento: Se encarga de toda la lógica relacionada para realizar movimiento necesario para llegar a la solución. Es un proceso interno.

#v(1em)
- *Incertidumbres:*
  - No es claro cómo es el flujo de acciones del sistema, es decir, se sabe más o menos quién inicia el sistema y las responsabilidades de cada pieza, sin embargo, es complicado de explicar o evidenciar cómo es el flujo que lleva a cabo el sistema para llevar a cabo una acción.
  - Cómo funcionan los métodos de búsqueda, es claro cuál es su objetivo pero es complejo y algo abstracto ser capaz de ver y evidenciar cómo funcionan realmente, qué clase de lógica utilizan y por qué si todos hacen lo mismo sus resultados son tan diferentes.
  - Por qué existen tantas listas anidadas, todas realizan lo mismo, pero simplemente viendo el código no es claro evidenciar por qué se necesitan tantas, y simplemente ejecutando el sistema sin depurar no es claro ver qué tipo de lista anidada está usándose.


#pagebreak()


== Especificacion Funcional Recuperada
