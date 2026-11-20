
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
