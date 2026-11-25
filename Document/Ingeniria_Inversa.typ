
#set page(
  paper: "a4",
  margin: (x: 2.2cm, top: 2.4cm, bottom: 2.4cm),
  header: context [
    #set text(size: 8pt, fill: luma(100))
    #grid(
      columns: (1fr, 1fr),
      align: (left, right),
      [Bitácora UML --- Análisis y Diseño de Sistemas II], [Fase 1: Ingeniería inversa],
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

=== Primera impresión del código

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
  Parece definir una casilla en el tablero. Cuenta con atributos como fila y columna de tipo entero que parecen definir la ubicación de la casilla en concreto en el tablero; también cuenta con un atributo de estado de tipo String que parece definir el estado de la casilla (por ejemplo, ocupada, bloqueada, libre, etc.). Al ser un String parece algo frágil: no está bien definido cuáles son los posibles estados.

  Cuenta con métodos relevantes como: compareTo, donde se compara con otra casilla y si la casilla está más arriba (en caso de que la fila sea mayor) o a la derecha (en caso de que la columna sea mayor) retornará 1, en caso de ser menor retornará -1 y en caso de ser igual retornará 0; y los métodos de movimiento, los cuales aumentan o disminuyen en uno el valor actual de la casilla, lo cual puede indicar que realmente el tablero no sea un array de casillas, como pensé originalmente, sino que casilla represente la posición de la punta del recorrido del usuario al recorrer el laberinto.
]

#archivo("Laberinto")[
  Este archivo parece tener varias responsabilidades, todas relacionadas con la grilla del laberinto. Se encarga de definir la grilla del laberinto utilizando una matriz de enteros, 10x15, contener los diferentes colores relacionados a las casillas basados en su estado, definir la meta y la salida junto a su posición, contar con varios tableros escogibles. Entre sus métodos destacan: un método para limpiar y reiniciar el laberinto, un método para hacer una animación en la GUI del laberinto siendo resuelto y un método para modificar el tipo o estado de una casilla en específico.
]

==== Tablero
Este paquete es el encargado de manejar toda la lógica y armado de la GUI del software, está enteramente escrito con la librería de Swing. Sus archivos relevantes son:

#archivo("MainThread")[
  Extiende de la clase Thread y parece ser el encargado de gestionar la lógica del hilo principal de la app, bloqueando acciones como modificar el tablero mientras es ejecutado.
]

#archivo("PanelTablero")[
  Se encarga de definir por medio de un JPanel el panel del laberinto en la GUI, además de gestionar eventos de mouse para cambiar el estado de las casillas cuando se les hace click.
]

#archivo("LaberintoGUI")[
  Se encarga de pintar toda la interfaz gráfica del software, tales como botones, paneles y campos de texto.
]

==== basic
Este paquete parece contener toda la lógica relacionada con acciones y comportamientos básicos del funcionamiento del sistema en general. Sus archivos relevantes son:

#archivo("Action")[
  Es una interfaz que define el contrato a realizar por todas las acciones, cuenta con los métodos: nombre, el cual retorna el nombre de la acción; coste, el cual retorna el costo en casillas de un movimiento; posible, el cual indica si una acción es posible; aplicar, la cual ejecuta la acción.
]

#archivo("State")[
  Interfaz que parece definir contrato que deben cumplir las instancias del estado global del juego o del laberinto, cuenta con los atributos: posible, el cual retorna si una Action es posible; succesor, el cual aplica una Action; copy, devuelve una copia del estado actual; compareTo, devuelve 1 si la comparación con otro estado es exactamente la misma, y 0 si no lo es.
]

#archivo("Node")[
  Parece ser el encargado de definir un nodo en la solución, cuenta con atributos como el estado actual del juego, la acción que lo llevó a ese estado, el nodo padre y el costo acumulado hasta ese nodo.
]

#archivo("Distancia")[
  Parece ser una clase que contiene la información relacionada con la distancia restante de una casilla para alcanzar la meta.
]

#archivo("Problem")[
  Parece modelar el problema en cuestión, pues se encarga de mostrar y resolver el laberinto, necesita como atributos el estado inicial, la lista de acciones y el objetivo final.
]
==== queue
Parece ser un directorio con una gran cantidad de listas anidadas, desde colas (LIFO) hasta stack (FIFO). El archivo destacado sería la interfaz Queue y el resto son simplemente implementaciones del contrato que define:

#archivo("Queue")[
  Es una interfaz que parece definir el contrato básico de cualquier lista anidada: add, remove, get, isEmpty y size.
]

==== search
Parece contener múltiples métodos o formas de realizar búsquedas de soluciones para el laberinto, los archivos destacados son:
#archivo("Search")[
  Es una interfaz que define el contrato que deben cumplir todos los métodos o formas de buscar solución en el laberinto. Los cuales son: findSolution y findAllSolutions.
]
#archivo("NodeComparator")[
  Clase abstracta que implementa la interfaz Comparator del paquete java.util, se encarga de definir los atributos y métodos que deben cumplir los diferentes comparadores.
]

=== Tras ejecutar la app (sin herramientas de depurado)
#v(1em)
El software parece ser un laberinto donde el usuario puede definir un laberinto y parece tener una especie de IA, donde el software por sí mismo debe encontrar la posible salida. Parece tener una animación donde encuentra la posible solución. Parece que tiene varios modos de búsqueda, los cuales son:

- Profundidad
- Anchura
- Primero Mejor
- Profundidad iterativa
- Profundidad limitada
- A\*

Parece que la Profundidad Iterativa y Profundidad Limitada al usarse cuentan con un contador el cual va de 1 a 100.

#v(1em)
Parece que el laberinto es una grilla de cuadros (15x10) donde los cuadros de color negro son muros o bloqueos, los bloques amarillos son casillas libres, el bloque rojo es la salida y el bloque azul la meta. Al iniciar la búsqueda se hace un camino de solución de color gris.
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

=== En resumen
#v(1em)
- El punto de entrada de la app es la clase LaberintoGUI pues es la que contiene el método estático main que le indica a la JVM cómo debe compilar el código. Además de contar con una dependencia directa a las librerías de java swing, awt, utils, io.

#v(4em)

#figure(
  image("assets/Modulos.drawio.png"),
  caption: [Diagrama de módulos del sistema],
)

#pagebreak()
- *Funciones observables:*
  - Hallar solución: Se encarga de ejecutar la lógica necesaria para hallar la solución de un laberinto en específico. Es iniciada por el usuario por medio de la interfaz gráfica.
  - Animar recorrido: Se encarga de gestionar la lógica relacionada con una animación que se muestra en la GUI. Es un proceso interno que solo ocurre si el usuario tiene la opción activada.
  - Modificar el laberinto: Se encarga de gestionar la lógica relacionada con la modificación del esquema del laberinto, tal como modificar el estado de una casilla para transformarla de un bloqueo o muro a una libre y viceversa, limpiar el recorrido realizado y limpiar completamente el laberinto. Es una acción que debe ser lanzada por el usuario por medio de la interfaz gráfica.
  - Mostrar información: Se encarga de mostrar en la GUI información relevante con la solución realizada, desde listar los pasos, mostrar el costo en pasos de la solución, mostrar información relevante con los nodos. Es un proceso interno.
  - Movimiento: Se encarga de toda la lógica relacionada para realizar movimiento necesario para llegar a la solución. Es un proceso interno.

#v(1em)
- *Incertidumbres:*
  - No es claro cómo es el flujo de acciones del sistema, es decir, se sabe más o menos quién inicia el sistema y las responsabilidades de cada pieza, sin embargo, es complicado de explicar o evidenciar cómo es el flujo que lleva a cabo el sistema para llevar a cabo una acción.
  - Cómo funcionan los métodos de búsqueda, es claro cuál es su objetivo pero es complejo y algo abstracto ser capaz de ver y evidenciar cómo funcionan realmente, qué clase de lógica utilizan y por qué si todos hacen lo mismo sus resultados son tan diferentes.
  - Por qué existen tantas listas anidadas, todas realizan lo mismo, pero simplemente viendo el código no es claro evidenciar por qué se necesitan tantas, y simplemente ejecutando el sistema sin depurar no es claro ver qué tipo de lista anidada está usándose.


#pagebreak()


== Especificación funcional recuperada

#table(
  columns: (0.5fr, 1fr, 1.2fr, 1.5fr),
  align: (x, y) => if (y == 0 or x == 0) { center + horizon } else { left + top },
  table.header([*ID*], [*Comportamiento \ recuperado*], [*Evidencia en código*], [*Criterio observable*]),
  [*RF-R01*],
  [Cambiar el tipo de una casilla.],
  [Laberinto.actualizarCasilla()],
  [Se debe poder cambiar el estado de una casilla para hacer que sea un espacio libre o un muro o bloqueo; se utiliza en métodos como panelTablero.mouseClicked, Laberinto.restart, Laberinto.actualizarCasilla y Laberinto.LabVacio.],

  [*RF-R02*],
  [Encontrar la solución al laberinto siempre y cuando sea posible.],
  [Problem.solve()],
  [Debe poder encontrarse una solución al laberinto siempre y cuando sea posible; en caso de no ser posible, debe notificarse. Se debe poder encontrar utilizando uno de varios métodos de búsqueda de solución.],

  [*RF-R03*],
  [Mostrar información relevante a la solución encontrada],
  [Solution.toString()],
  [Debe mostrarse información importante con respecto a la solución encontrada, tal como si se encontró la solución, los pasos y acciones realizadas en dicha solución, el coste de casillas de la solución, el estado final de la casilla al momento de encontrar la solución y las métricas relacionadas con la solución.],

  [*RF-R04*],
  [Mostrar de forma gráfica el tablero],
  [PanelTablero.paint()],
  [Debe mostrarse de forma gráfica el tablero siguiendo el mismo esquema que Laberinto, es decir que si Laberinto cambia su esquema o tiene varios esquemas o grillas intercambiables, estas siempre serán la fuente de la verdad que deberá seguir el tablero gráfico.],

  [*RF-R05*],
  [Mostrar de forma gráfica la solución en el tablero gráfico],
  [Laberinto.dibujaSolucion()],
  [Se debe mostrar de forma clara y concisa la solución del laberinto realizada por el método de solución seleccionado, de forma gráfica.],

  [*RF-R06*],
  [Se debe poder animar el proceso de solución en el tablero gráfico],
  [Laberinto.dibujaSolucion()],
  [Se debe poder activar y desactivar una animación del laberinto siendo resuelto, además de poder seleccionar la velocidad de la misma; eso sí, no debe interferir y debe ser completamente independiente del proceso de analizar y buscar la solución.],

  [*RF-R07*],
  [Pausar e interrumpir el proceso de búsqueda de solución de un tipo de búsqueda en específico],
  [LaberintoGUI. \ bot_DetenerActionPerformed()],
  [Se debe detener el proceso de búsqueda de una solución de dos maneras diferentes: se debe poder pausar y reanudar el proceso de animación de mostrar la solución en la GUI; también se debe poder cancelar el proceso de análisis y búsqueda de solución del laberinto.],
)

#pagebreak()


== Artefactos de diseño

#v(1em)

=== Diagrama de casos de uso

#v(1em)
#figure(
  image("assets/UMLs/casos de uso.png"),
  caption: [Diagrama de casos de uso del sistema],
)<fig-uml-use-cases>
#v(2em)
=== Diagrama de clases
#v(1em)
#figure(
  image("assets/UMLs/Clases.png"),
  caption: [Diagrama de clases del sistema],
)<fig-uml-clases>
#v(2em)
=== Diagramas de secuencia
#v(1em)
#figure(
  image("assets/UMLs/Secuencia-1.png"),
  caption: [Diagrama de secuencias del sistema, caso de búsqueda de solución],
)
#v(2em)
#figure(
  image("assets/UMLs/Secuencia-2.drawio.png"),
  caption: [Diagrama de secuencias del sistema, caso de búsqueda de clickear una casilla para cambiar su estado],
)<fig-uml-secuencia-2>
#v(2em)
=== Diagrama de actividad
#v(1em)
#figure(
  image("assets/UMLs/Actividades-pre-modificaciones.png"),
  caption: [Diagrama de actividades, caso de búsqueda de solución],
)
#v(2em)
=== Patrones de diseño
#v(1em)
#table(
  columns: (1fr, 1.2fr, 1.2fr, 1.5fr),
  align: (x, y) => if (y == 0 or x == 0) { center + horizon } else { left + top },
  table.header([*Patrón encontrado*], [*Evidencia en el proyecto*], [*Motivo*], [*Conclusión*]),
  [*Facade*],
  [Archivo Solucion],
  [Esconde toda la lógica de diferentes zonas, haciendo que imprimir todas las métricas e información relacionada con la solución sean mucho más fáciles de ver y utilizar.],
  [Parcial. Aunque es verdad que contiene esta función, no contiene ni ejecuta lógica pesada; guarda la información en variables y simplemente la imprime.],

  [*Factory Method*],
  [Método Set del archivo Problem.],
  [Maneja la creación del objeto por fuera del constructor nativo.],
  [No sustentado. No aplica ninguna lógica de validación o de reglas de negocio; termina siendo igual que un constructor corriente.],

  [*Mediator*],
  [Método run de MainThread],
  [Centraliza y organiza las acciones de una acción, como lo es buscar una solución dentro de un método; sin embargo, también crea acoplamiento.],
  [Presente. Aunque cree acoplamiento, el patrón está bien implementado; el problema del acoplamiento es un error de diseño, no del patrón.],
)


== Evidencias de comprensión

=== Búsqueda que encuentra solución

Búsqueda de solución con el método profundidad, animación activada con su velocidad por defecto en el laberinto por defecto. Primero, tras hacer click en el botón, el software o sistema debe crear una instancia del MainThread y este, a su vez, empezará bloqueando la GUI para evitar modificaciones mientras se ejecuta la búsqueda. Se creará una instancia de problem utilizando el método de profundidad; el método de profundidad buscará la solución utilizando el árbol binario. Una vez encontrado, creará una instancia de solution y la retornará. MainThread obtendrá dicha instancia y llamará al método dibujar solución de Laberinto. Laberinto notará que el botón de animación está activo con su velocidad por defecto, así animará el proceso de solución en la GUI; mientras esto sucede, el MainThread imprimirá la solution en el JTextArea de la GUI.

=== Búsqueda que no encuentra solución

Búsqueda de solución con el método profundidad, animación activada con su velocidad por defecto en el laberinto por defecto, con una pequeña modificación en la casilla antes de la meta, pues esta estará bloqueada, siendo inaccesible. El proceso será igual que el anterior hasta el punto donde se llama al método solve del problema; este, al intentar resolverlo y notar que la solución es imposible, retornará un mensaje de error.


=== Cambios realizados después de ver la ejecución

Tras ver la ejecución de ambos casos se notó que:
1. El proceso de pintado con animación es iterativo.
2. El sistema no tiene un mensaje especial o específico para cuando no se puede solucionar el laberinto; simplemente, en la solución, retorna el booleano de gotSolution: false.


#figure(
  image("assets/UMLs/Secuencia-1-modificado.png"),
  caption: [Diagrama de secuencia tras revisión],
)<fig-uml-secuencia-1>

#figure(
  image("assets/UMLs/Actividades.png"),
  caption: [Diagrama de actividades después de las modificaciones, caso de búsqueda de solución],
)<fig-uml-actividades>

#pagebreak()

= Fase 2: Ingeniería directa con IA (Vibe-Coding)

#v(1em)

== Trabajo con IA

=== Iteraciones significativas

==== Iteración 1
#v(1em)
- *Prompt:* ' /Plan yeah let's start, I let you all the info about the project in @[resources] that diagrams are based in a java implementation, but this time we'll using go as a language, because we want to take advantage of goroutines, and the speed of go, for the GUI I let you use the library or framework that you think will fit better with the project.'

#v(1em)

- *Respuesta o fragmento relevante:* 'The hierarchy would be: internal/domain: Board grid, cell definitions (Free, Wall, Start, Goal, Visited, Path), and board state mutations.
  internal/search: AIMA search formulation (Problem, Node, Frontier, BFS, DFS, and Metrics).
  internal/runner: Concurrency engine wrapping search runs with goroutines, channels, and cancellation contexts.
  internal/ui: Fyne-based view (board canvas, controls, and metrics panel in Spanish).
  cmd/maze/main.go: Application entrypoint.'

- *Defecto detectado:* La jerarquía propuesta por la IA, aunque funcionaría, es compleja de comprender a simple vista y, por lo tanto, de mantener; además de no dejar muy claro la relación entre los diferentes paquetes y directorios.

- *Cambio y resultado verificable:* Tras una revisión de la respuesta de la IA, se decidió implementar una jerarquía mucho más clara aplicando los principios de la Screaming Architecture, dejando la jerarquía de directorios mucho más clara; esto es evidenciable en la jerarquía del proyecto.

#v(1em)
==== Iteración 2
#v(1em)
- *Prompt:* 'Go ahead, but for the package hierarchy use scream architecture better, it would make way easier understand the project'

- *Respuesta o fragmento relevante:* En Board.go se define la grilla del tablero, y en la GUI se definía el tablero de nuevo.

- *Defecto detectado:* Que la GUI y el tablero no compartan la misma fuente de verdad, es decir, que la GUI tenga su propio tablero y el tablero del juego tenga otro; esto puede llevar a inconsistencias y errores.
- *Cambio y resultado verificable:* Se decidió indicarle, por medio del siguiente prompt, 'Now, I saw that the board and the GUI have to be modified both to actually chang the size and the form of the board, that is a mistake, couldn't you make that the board file is the just and only truth source, the GUI shouldn't care about that it just should show the info that recives from the board.' y la IA implementó el cambio haciendo las respectivas modificaciones, dejando la GUI como un simple observador del tablero y no como una fuente de verdad; esto es evidenciable en el código, pues ahora se pueden tener múltiples tableros viviendo simultáneamente y la GUI solo se encargará de mostrar la información que recibe.

#v(1em)
==== Iteración 3
#v(1em)
- *Prompt:* 'Now, I saw that the board and the GUI have to be modified both to actually chang the size and the form of the board, that is a mistake, couldn't you make that the board file is the just and only truth source, the GUI shouldn't care about that it just should show the info that recives from the board.'

- *Respuesta o fragmento relevante:* Hizo las modificaciones necesarias para que la GUI solo sea un observador del tablero y no una fuente de verdad, además de hacer que el tablero sea la única fuente de verdad y que pueda vivir múltiples tableros simultáneamente.

- *Defecto detectado:* Con el cambio implementado ya se puede realizar el cambio en el sistema para que contenga uno o más laberintos predefinidos y que sean cambiables por el usuario.
- *Cambio y resultado verificable:* Se le indicó a la IA que implementara la funcionalidad de tener laberintos predefinidos y que el usuario pueda cambiar entre ellos; se puede evidenciar en el código y al ejecutar la app.


=== Decisiones inducidas por la IA que no estaban explícitas en los modelos

#v(1em)
1. Que se muestre una animación de los nodos siendo recorridos. La IA dio por hecho que el usuario quiere evidenciar cómo el sistema recorre el tablero en busca de la solución antes de hacer la animación del agente realmente solucionando el laberinto. Dado que no afecta directamente al funcionamiento del sistema y, de hecho, mejora la UX, se decidió aceptar el cambio, más aún teniendo en cuenta que se puede desactivar en cualquier momento.
#v(1em)
2. Que el usuario pueda seleccionar y cambiar la posición de la meta y salida. La IA dio por hecho que la feature de cambiar el estado o tipo de una casilla también se aplicaba para las casillas de salida y meta, a diferencia de solo cambiar entre muro y libre; dado que en el código de Java hay indicios de que eso quería ser una feature, pues el archivo laberinto tiene ese caso previsto en su método de actualizarCasilla pero la UI no lo permite, se decidió dejar, pues también mejora la UX y expande el funcionamiento del sistema sin modificar su propósito original.

#pagebreak()
== Pruebas comparativas
#table(
  columns: (0.5fr, 0.8fr, 1fr, 1fr, 1fr, 0.8fr),
  align: (x, y) => if (y == 0 or x == 0) { center + horizon } else { left + top },
  table.header(
    [*Caso*],
    [*Entrada \ / Escenario*],
    [*Resultado \ Esperado*],
    [*Java original*],
    [*Nueva versión (Go)*],
    [*Evidencia*],
  ),
  [*CP-01*],
  [Ruta simple],
  [Se encuentra la solución y se muestra la información relacionada con la misma],
  [Muestra el resultado directamente así como las métricas relacionadas],
  [Muestra el resultado y las métricas igual que el original, pero además muestra los nodos recorridos para llegar a la solución.],
  [@fig-cp-01],

  [*CP-02*],
  [Obstáculo que obliga a un desvío],
  [Se hace el desvío dependiendo del tipo de método de búsqueda que se tenga seleccionado.],
  [Hace el desvío y muestra la solución junto a sus respectivas métricas],
  [Al igual que el original, hace el desvío, pero al igual que el CP anterior muestra los nodos visitados para hallar la solución.],
  [@fig-cp-02],

  [*CP-03*],
  [Ausencia de solución],
  [Se muestra que no se encuentra la solución y no se muestra ningún resultado en el panel del laberinto.],
  [No muestra nada en el panel propio del laberinto; en la zona de información muestra que no pudo encontrar la solución.],
  [Indica que su estado es 'Sin Solución', muestra visualmente que recorrió todo el laberinto usando los nodos en busca de una solución.],
  [@fig-cp-03],

  [*CP-04*],
  [Selección de dos algoritmos],
  [Se cambia la ruta escogida para solucionar el problema],
  [Muestra dos soluciones diferentes basadas en el algoritmo escogido.],
  [Muestra también dos soluciones diferentes y los nodos necesarios para ellas; además, aunque se seleccionaron los mismos métodos de búsqueda, hay una diferencia en la solución utilizando el método de búsqueda de profundidad entre la solución que da el programa original (Java) y la nueva versión (Go).],
  [@fig-cp-04],

  [*CP-05*],
  [Reinicio],
  [Se elimina la solución ya encontrada y se hace una búsqueda nuevamente.],
  [Limpia la solución anterior y hace búsqueda nuevamente de una solución],
  [Exactamente lo mismo que la versión original],
  [@fig-cp-05],

  [*CP-06*],
  [Borrar la solución mientras se ejecuta la búsqueda],
  [Que no se permita la limpieza del tablero mientras se ejecuta una solución.],
  [Permite que se haga una limpieza mientras se ejecuta, lo cual deja el camino de solución llevado a cabo por el agente incompleto.],
  [Bloquea la UI para impedir que se realice cualquier acción mientras se ejecuta la solución.],
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

= Fase 3: Contraste crítico y trazabilidad

#table(
  columns: (1fr, 1fr, 0.8fr, 1fr, 1fr),
  align: (x, y) => if (y == 0 or x == 0) { center + horizon } else { left + top },
  table.header(
    [*Requisito \ recuperado*],
    [*Evidencia en Java*],
    [*Artefacto de \ diseño*],
    [*Módulo de la nueva aplicación*],
    [*Prueba*],
  ),
  [*Búsqueda de solución*],
  [Problem.solve()],
  [#link(<fig-uml-secuencia-1>)[Diagrama de secuencia 1], #link(<fig-uml-actividades>)[Diagrama de actividad]],
  [runner.SolveAsync()],
  [@fig-trazabilidad-1],

  [*Poder seleccionar múltiples métodos de búsqueda*],
  [if anidado en MainThread.run()],
  [#link(<fig-uml-actividades>)[Diagrama de actividad], #link(<fig-uml-clases>)[Diagrama de clases]],
  [control_panel.\
    getAlgorithm()],
  [@fig-trazabilidad-2],

  [*Mostrar las métricas relacionadas con la solución*],
  [El método toString de Solution, utilizado en MainThread, mostrado en el textArea de LaberintoGUI],
  [#link(<fig-uml-actividades>)[Diagrama de actividad], #link(<fig-uml-clases>)[Diagrama de clases]],
  [metrics_panel. \ DisplayResults()],
  [@fig-trazabilidad-3],

  [*Modificar el tablero*],
  [Laberinto.\ actualizarCasilla()],
  [#link(<fig-uml-secuencia-2>)[Diagrama de secuencias 2]],
  [control_panel. \ getEditMode(), board.CycleCell()],
  [@fig-trazabilidad-4],

  [*Animar al agente mientras resuelve el laberinto*],
  [Laberinto.\ dibujaSolucion()],
  [#link(<fig-uml-actividades>)[Diagrama de actividad]],
  [app. \ animateAgentPath()],
  [@fig-trazabilidad-5],
)
#v(1em)
== Pruebas
#v(1em)
#figure(
  image("assets/Evidences/Evidencia-1.png"),
  caption: "Evidencia de la prueba de trazabilidad 1",
) <fig-trazabilidad-1>
#v(1em)
#figure(
  image("assets/Evidences/Evidencia-2.png"),
  caption: "Evidencia de la prueba de trazabilidad 2",
)<fig-trazabilidad-2>
#v(1em)
#figure(
  image("assets/Evidences/Evidencia-3.png"),
  caption: "Evidencia de la prueba de trazabilidad 3",
)<fig-trazabilidad-3>
#v(1em)
#figure(
  image("assets/Evidences/Evidencia-4.png"),
  caption: "Evidencia de la prueba de trazabilidad 4",
)<fig-trazabilidad-4>
#v(1em)
#figure(
  image("assets/Evidences/Evidencia-5.png"),
  caption: "Evidencia de la prueba de trazabilidad 5",
)<fig-trazabilidad-5>



== Diferencias de implementación

1. La nueva versión implementada en Go, a la hora de buscar la solución del laberinto, muestra los nodos que fueron visitados para hallar la solución, mientras que la versión original en Java no lo hace. Esto considero que es una mejora justificada, pues permite al usuario ver cómo el sistema recorre el laberinto en busca de la solución y no solo el resultado final.

2. La nueva versión cuenta con la opción de poder cambiar el tablero y el tipo de las casillas, no solo entre libre y muro, como lo hace la versión original, sino que también permite colocar la meta y la salida en cualquier casilla del tablero. Esto definitivamente también es una mejora justificada, pues permite al usuario tener un mayor control sobre el tablero y la forma en que se resuelve el laberinto, además de que en la versión original hay indicios de que esta funcionalidad estaba prevista pero no implementada.

3. La nueva versión tiene un select para seleccionar la velocidad, a diferencia de la versión original, que tiene un radio button para activar o desactivar la animación y un slider para seleccionar la velocidad. Esto considero que es una simplificación deliberada, pues realmente es más simple tener un rango de velocidades para la animación y es mucho más claro para el usuario.


== Respuestas

Considero que lo más complicado dentro de lo que cabe en el desarrollo con la IA fue el de implementar los métodos de búsqueda, pues, a decir verdad, en la implementación original de Java no comprendía al 100% su funcionamiento; entonces fue complicado poder guiar a la IA para implementar los métodos de búsqueda de la forma más similar posible a la versión original.

En los diagramas considero que faltó indicar los modelos de búsqueda; esto podría simplificar muchísimo el desarrollo y la comprensión del sistema. Sin embargo, la IA comprendió mi diseño y lo explicado en el contrato abstracto de búsqueda, y lo implementó correctamente.

Gracias al diseño fue fácil evidenciar el error que estaba cometiendo la IA a la hora de implementar la GUI, pues estaba haciendo que la GUI tuviera su propio tablero y no compartiera la fuente de verdad con el tablero del juego; esto podría haber generado inconsistencias y errores en el sistema. Sin embargo, gracias a los diagramas, fue sencillo pensar en una alternativa e indicarle a la IA cómo implementarla.

Creo que en mi proceso de ingeniería inversa, al ser la primera vez que lo hago, empecé bastante perdido a leer el código sin tener idea de qué hacía el programa, lo cual me llenó de dudas y confusiones, pues en un principio pensé que el sistema era un juego donde el usuario era quien resolvía el laberinto y el sistema lo generaba aleatoriamente; pero no fue hasta que ejecuté el programa que pude comprender y entender la abstracción del sistema.


#pagebreak()

= Información adicional

Junto a este documento se adjuntan diferentes archivos y directorios que corresponden a:
1. El código fuente de la nueva versión implementada en Go, en el directorio Codigo; para ejecutarlo se debe tener instalado Go y ejecutar el comando go run main.go desde la terminal, estando ubicado en run/maze-solver.

2. La conversación con la IA, en el directorio Conversacion: la conversación se realizó en inglés y está en un archivo markdown (.md); se puede visualizar en cualquier editor de texto o código, o en un visualizador online de markdown (como, por ejemplo, https://phcode.dev/tools/es/markdown-viewer.html).

3. El proyecto está subido a un repositorio de GitHub (https://github.com/Luisja0106/Ingenieria-inversa), donde se puede evidenciar la modificación y fecha de cada archivo, además de poder ver el historial de cambios y commits realizados.
