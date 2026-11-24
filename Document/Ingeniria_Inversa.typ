
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
  #text(size: 17pt, weight: "bold", fill: luma(10))[Taller Ingeniería Inversa V2]
  #v(0.25em)
  #text(size: 10pt, fill: luma(60))[Luis Javier Pérez]
  #v(0.1em)
  #text(size: 10pt, fill: luma(60))[2026-11-24]
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

#table(
  columns: (0.5fr, 1fr, 1.2fr, 1.5fr),
  align: (x, y) => if (y == 0 or x == 0) { center + horizon } else { left + top },
  table.header([*ID*], [*Comportamiento \ Recuperado*], [*Evidencia en Codigo*], [*Criterio Observable*]),
  [*RF-R01*],
  [Cambiar el tipo de una casilla.],
  [Laboratorio.actualizarCasilla()],
  [Se debe poder cambiar el estado de una casilla para hacer que sea un espacio libre o un muro o bloqueo, se utiliza en metodos como panelTablero.mouseClicked, Laberinto.restart, Laberinto.actualizarCasilla y Laberinto.LabVacio.],

  [*RF-R02*],
  [Encontrar la solucion al laberinto siempre y cuando sea posible.],
  [Problem.solve()],
  [Debe poder encontrarse una solucion al laberinto siempre y cuando sea posible, en caso de no ser posible debe notificarse. Se debe poder encontrar utilizando uno de varios metodos de busqueda de solucion.],

  [*RF-R03*],
  [Mostrar informacion relevante a la solucion encontrada],
  [Solution.toString()],
  [Debe mostrarse informacion importante con respecto a la solucion encontrada, tal como si se encontro la solucion, los pasos y acciones realizadas en dicha solucion, el coste de casillas de la solucion, el estado final de la casilla al momento de encontrar la solucion, y las metricas relacionada a la solucion.],

  [*RF-R04*],
  [Mostrar de forma grafica el tablero],
  [PanelTablero.paint()],
  [Debe mostrarse de forma grafica el tablero siguiendo el mismo esquema que Laberinto, es decir que si laberinto cambia su esquema o tiene varios esquemas o grillas intercamabiables estas siempre seran la fuente de la verdad que debera seguir el tablero grafico.],

  [*RF-R05*],
  [Mostrar de forma grafica la solucion en el tablero grafico],
  [Laberinto.dibujaSolucion()],
  [Se debe mostrar de forma clara y consisa la solucion del laberinto realizada por el metodo de solucion seleccionado de forma grafica.],

  [*RF-R06*],
  [Se debe poder animar el proceso de solucion en el tablero grafico],
  [Laberinto.dibujaSolucion()],
  [Se debe poder activar y desactivar una animacion del laberinto siendo resuelto, ademas de poder seleccionar la velocidad de la misma, eso si no debe interferir y debe ser completamente independiente al proceso de analizar y buscar la solucion.],

  [*RF-R07*],
  [Pausar e interrumpir el proceso de busqueda de solucion de un tipo de busqueda en especifico],
  [LaberintoGUI. \ bot_DetenerActionPerformed()],
  [Se debe detener el proceso de busqueda de una solucion de dos maneras diferentes, se debe poder pausar y reanudar el proceso de animacion de mostrar la solucion en la GUI, tambien se debe poder cancelar el proceso de analsis y busqueda de solucion del laberinto.],
)

#pagebreak()


== Artefactos de Diseño

#v(1em)

=== Diagrama de Casos de Uso

#v(1em)
#figure(
  image("assets/UMLs/casos de uso.png"),
  caption: [Diagrama de Casos de Uso del sistema],
)
#v(2em)
=== Diagrama de Clases
#v(1em)
#figure(
  image("assets/UMLs/Clases.png"),
  caption: [Diagrama de Clases del sistema],
)
#v(2em)
=== Diagramas de Secuencia
#v(1em)
#figure(
  image("assets/UMLs/Secuencia-1.png"),
  caption: [Diagrama de Secuencias del sistema, caso de busqueda de solucion],
)
#v(2em)
#figure(
  image("assets/UMLs/Secuencia-2.drawio.png"),
  caption: [Diagrama de Secuencias del sistema, caso de busqueda de clickear una casilla para cambiar su estado],
)
#v(2em)
=== Diagrama de Actividad
#v(1em)
#figure(
  image("assets/UMLs/Actividades-pre-modificaciones.png"),
  caption: [Diagrama de Actividades, caso de busqueda de solucion],
)
#v(2em)
=== Patrones de Diseño
#v(1em)
#table(
  columns: (1fr, 1.2fr, 1.2fr, 1.5fr),
  align: (x, y) => if (y == 0 or x == 0) { center + horizon } else { left + top },
  table.header([*Patron Encontrado*], [*Evidencia en el proyecto*], [*Motivo*], [*Conclusion*]),
  [*Facade*],
  [Archivo Solucion],
  [Esconde toda la logica de diferentes zonas, haciendo que imprimir todas las metricas e informacion relacionada con la solucion sean mucho mas facil de ver y utilizar.],
  [Parcial, Aunque es verdad que contiene esta funcion, no contiene ni ejecuta logica pesada, guarda la informacion en variables y simplemente la imprime.],

  [*Factory Method*],
  [Metodo Set del archivo Problem.],
  [Maneja la creacion del objeto por fuera del constructor nativo.],
  [No sustentado, No aplica ninguna logica de validacion o de reglas de negocio, termina siendo igual que un constructor corriente],

  [*Mediator*],
  [Metodo run de MainThread],
  [Centraliza y organiza las acciones de una accion como lo es busqcar una solucion dentro de un metodo, sin embargo tambien crea acoplamiento.],
  [Presente, Aunque cree acoplamiento el patron esta bien implementado, el problema del acoplamiento es un error de diseño no del patron.],
)


== Evidencias de Comprension

=== Busqueda que encuentra solucion:

Busqueda de solucion con el metodo profundidad, animacion activada con su velocidad por defecto en el laberinto por defecto. Primero tras hacer click en el boton el software o sistema debe crear una instancia del MainThread y este a su vez empezara bloqueando la GUI para evitar modificaciones mientras se ejecuta la busqueda, se creara una instancia de problem utilizando el metodo de profundidad, el metodo de profundidad buscara la solucion utilizando el arbol binario, una vez encontrado creara una instancia desolution y la retornara, MainThread obtendra dicha instancia y llamara al metodo dibujar solucion de Laberinto, laberinto notara que el boton de animacion esta activo con su velocidad por defecto asi animara el proceso de solucion en la GUI, mientras esto sucede el MainThread imprimira la solution en el jtext area de la GUI.

=== Busqueda que no encuentra solucion:

Busqueda de solucion con el metodo profundidad, animacion activada con su velocidad por defecto en el laberinto por defecto con una pequña modificacion en la casilla antes de la meta, pues esta estara bloquedada siendo inecesible. El proceso sera igual que el anterior hasta el punto donde se llama al metodo solve del problema, este al intentar resolverlo y notar que la solucion es imposible retornara un mensaje de error.


=== Cambios Realizados despuese de ver la ejecucion:

Tras ver la ejecucion de ambos casos se noto que:
1. El proceso de pintado con animacion es iterativo.
2. El sistema no tiene un mensaje especial o especifico para cuando no se puede solucionar el laberinto, simplemente en la solucion retorna el boleano de gotSolution: false.


#figure(
  image("assets/UMLs/Secuencia-1-modificado.png"),
  caption: [Diagrama de secuencia tras revision],
)

#figure(
  image("assets/UMLs/Actividades.png"),
  caption: [Diagrama de Actividades despues de las modificaciones, caso de busqueda de solucion],
)

#pagebreak()

= Fase 2: Ingeniería Directa con IA (Vibe-Coding)

#v(1em)

== Trabajo Con IA

=== Iteraciones Significativas:

==== Iteración 1:
#v(1em)
- *Prompt:* ' /Plan yeah let's start, I let you all the info about the project in @[resources] that diagrams are based in a java implementation, but this time we'll using go as a language, because we want to take advantage of goroutines, and the speed of go, for the GUI I let you use the library or framework that you think will fit better with the project.'

#v(1em)

- *Respuesta o Fragmento Relevante:*'The hierarchy would be: internal/domain: Board grid, cell definitions (Free, Wall, Start, Goal, Visited, Path), and board state mutations.
  internal/search: AIMA search formulation (Problem, Node, Frontier, BFS, DFS, and Metrics).
  internal/runner: Concurrency engine wrapping search runs with goroutines, channels, and cancellation contexts.
  internal/ui: Fyne-based view (board canvas, controls, and metrics panel in Spanish).
  cmd/maze/main.go: Application entrypoint.'

- *Defecto detectado:* La gerarquia propuesta por la IA aunque funcionaria es compleja de comprender a simple vista y por lo tanto de mantener, además de no dejar muy claro la relación entre los diferentes paquetes y directorios.

- *Cambio y Resultado verificable:* Tras una revision de la respuesta de la IA se decidió implementar una jerarquia mucho mas clara aplicando los principios de la Scream Architecture, dejando la jerarquia de directorios mucho mas clara, esto es evidenciable en la gerarquia del proyecto.

#v(1em)
==== Iteración 2:
#v(1em)
- *Prompt:* 'Go ahead, but for the package hierarchy use scream architecture better, it would make way easier understand the project'

- *Respuesta o Fragmento Relevante:* En Board.go se define la grilla del tablero, y en la GUI se definia el tablero de nuevo.

- *Defecto detectado:* Que la GUI y el tablero no compartan la misma fuente de verdad, es decir, que la GUI tenga su propio tablero y el tablero del juego tenga otro, esto puede llevar a inconsistencias y errores.
- *Cambio y Resultado verificable:* Se decidio indicarle por medio del siguiente prompt 'Now, I saw that the board and the GUI have to be modified both to actually chang the size and the form of the board, that is a mistake, couldn't you make that the board file is the just and only truth source, the GUI shouldn't care about that it just should show the info that recives from the board.' y la IA implemento el cambio haciendo las respectivas modificaciones, dejando la GUI como un simple observador del tablero y no como una fuente de verdad, esto es evidenciable en el codigo pues ahora se pueden tener multiples tableros viviendo simultaneamente y la GUI solo se encargara de mostrar la informacion que recibe.

#v(1em)
==== Iteración 3:
#v(1em)
- *Prompt:* 'Now, I saw that the board and the GUI have to be modified both to actually chang the size and the form of the board, that is a mistake, couldn't you make that the board file is the just and only truth source, the GUI shouldn't care about that it just should show the info that recives from the board.'

- *Respuesta o Fragmento Relevante:* Hizo las modificaciones necesarias para que la GUI solo sea un observador del tablero y no una fuente de verdad, además de hacer que el tablero sea la única fuente de verdad y que pueda vivir múltiples tableros simultáneamente.

- *Defecto detectado:* Con el cambio implementado ya se puede realizar el cambio en el sistema para que contenga uno o mas laberintos pre-definidos y que sean cambiables por el usuario.
- *Cambio y Resultado verificable:*: Se le indico a la IA que implementara la funcionalidad de tener laberintos predefinidos y que el usuario pueda cambiar entre ellos, se puede evidenciar en el codigo y al ejecutar la app.


=== Decisiones inducidas por la IA que no estaban explicitas en los modelos:

#v(1em)
1. Que se muestre una animacion de los nodos siendo recorridos, La IA dio por hecho que el usuario quiere evidenciar como el sistema recorre el tablero en busca de la solucion antes de hacer la animacion del agente realmente solucionando el laberinto. Dado a que no afecta directamente al funcionamiento del sistema y de hecho mejora la UX se decidio aceptar el cambio mas aun teniendo en cuenta que se puede desactivar en cualquier momento.
#v(1em)
2. Que el usuario pueda seleccionar y cambiar la posicion de la meta y salida, La IA dio por hecho que la feature de cambiar el estado o tipo de una casilla tambien se aplicaba para las casillas de salida y meta a diferencia de solo cambiar entre muro y libre, dado que en el codigo de java hay indicios de que eso queria ser una feature pues el archivo laberinto tiene ese caso previsto en su metodo de actualizarCasilla pero la UI no lo permite, se decidio dejar pues tambien mejora la UX y expande el funcionamiento del sistema sin modificar su proposito original.

#pagebreak()
== Pruebas Comparativas:
#table(
  columns: (0.5fr, 0.8fr, 1fr, 1fr, 1fr, 0.8fr),
  align: (x, y) => if (y == 0 or x == 0) { center + horizon } else { left + top },
  table.header(
    [*Caso*],
    [*Entrada \ / Escenario*],
    [*Resultado \ Esperado*],
    [*Java Original*],
    [*Nueva Version(Go)*],
    [*Evidencia*],
  ),
  [*CP-01*],
  [Ruta simple],
  [Se encuentra la solucion y se muestra la informacion relacionada a la misma],
  [Muestra el resultado directamente asi como las metricas relacionadas],
  [Muestra el resultado, las metricas igual que el original pero ademas muestra los nodos recorridos para llegar a la solucion.],
  [@fig-cp-01],

  [*CP-02*],
  [Obstaculo que obliga desvio],
  [Se hace el desvio dependiendo del tipo de metodo de busqueda que se tenga seleccionado.],
  [Hace el desvio y muestra la solucion junto a sus respectivas metricas],
  [Al igual que el original hace el desvio, pero al igual que el CP anterior muestra los nodos visitados para hallar la solucion.],
  [@fig-cp-02],

  [*CP-03*],
  [Ausencia de solucion],
  [Se muestra que no se encuentra la solucion y no se muestra ningun resultado en el panel del laberinto.],
  [No muestra nada en el panel propio del laberinto, en la zona de informacion muestra que no pudo encontrar la solucion.],
  [Indica que su estado es 'Sin Solucion', muestra visualmente que recorrio todo el laberinto usando los nodos en busca de una solucion.],
  [@fig-cp-03],

  [*CP-04*],
  [Seleccion de dos algoritmos],
  [Se cambia la ruta escogida para solucionar el problema],
  [Muestra dos soluciones diferentes basado en el algoritmo escogido.],
  [Muestra tambien dos soluciones diferentes, y los nodos necesarios para ellos, ademas aunque se seleccionaron los mismo metodos de busqueda hay una diferencia en la solucion utilizando el metodode busqueda de profundidad entre la solucion que da el programa original (java), y la nueva version (go)],
  [@fig-cp-04],

  [*CP-05*],
  [Reinicio],
  [Se elimina la solucion ya encontrada y se hace una busqueda nuevamente.],
  [Limpia la solucion anterior y hace busqueda nuevamente de una solucion],
  [Exactamente lo mismo que la version de original],
  [@fig-cp-05],

  [*CP-06*],
  [Borrar la solucion mientras se ejecuta la busqueda],
  [Que No se permita la limpieza del tablero mientras se ejecuta una solucion.],
  [Perminte que se haga una limpieza mientras se ejecuta, lo cual deja el camino de solucion llevado a cabo por el agente incompleto],
  [Bloquea la UI para impedir que se realize cualquier accion mientras se ejecuta la solucion],
  [@fig-cp-06],
)
#pagebreak()
===== Evidencias
#v(1em)
#figure(
  image("assets/Evidences/CP-01.png"),
  caption: "Evidencia del CP-01",
) <fig-cp-01>
#figure(
  image("assets/Evidences/CP-02.png"),
  caption: "Evidencia del CP-02",
) <fig-cp-02>
#figure(
  image("assets/Evidences/CP-03.png"),
  caption: "Evidencia del CP-03",
) <fig-cp-03>
#figure(
  image("assets/Evidences/CP-04.png"),
  caption: "Evidencia del CP-04",
) <fig-cp-04>
#figure(
  image("assets/Evidences/CP-05.png"),
  caption: "Evidencia del CP-05",
) <fig-cp-05>
#figure(
  image("assets/Evidences/CP-06.png"),
  caption: "Evidencia del CP-06",
) <fig-cp-06>

#pagebreak()

= Fase 3: Contraste Critico Y trazabilidad

#table(
  columns: (1fr, 1fr, 0.8fr, 1fr, 1fr),
  align: (x, y) => if (y == 0 or x == 0) { center + horizon } else { left + top },
  table.header(
    [*Requistio \ Recuperado*],
    [*Evidencia en Java*],
    [*Artefacto de \ Diseño*],
    [*Modulo de la Nueva applicacion*],
    [*Prueba*],
  ),
  [],
)
