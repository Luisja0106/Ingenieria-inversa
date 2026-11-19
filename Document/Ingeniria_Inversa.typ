#set page(
  paper: "a4",
  margin: (x: 2cm, y: 2.4cm),
  header: align(right)[
    #set text(size: 8pt, fill: luma(110))
    Bitácora UML
  ],
  numbering: "1",
)
#set text(
  font: "Liberation Sans",
  size: 10pt,
  lang: "es",
)

#set table(
  inset: 6pt,
  stroke: 0.4pt + luma(140),
)
#show table: set text(size: 9pt)

// Jerarquía visual de los títulos
#show heading.where(level: 1): it => block(
  above: 1.8em,
  below: 1em,
  width: 100%,
)[
  #set text(size: 16pt, weight: "bold")
  #it.body
]
#show heading.where(level: 2): it => block(
  above: 1.6em,
  below: 0.8em,
  width: 100%,
)[
  #set text(size: 13.5pt, weight: "bold")
  #it.body
  #v(0.15em)
  #line(length: 100%, stroke: 0.6pt + luma(170))
]
#show heading.where(level: 3): it => block(
  above: 1.2em,
  below: 0.6em,
  width: 100%,
)[
  #set text(size: 11.5pt, weight: "bold")
  #it.body
]
#show heading.where(level: 4): it => block(
  above: 1em,
  below: 0.45em,
  width: 100%,
)[
  #set text(size: 10.5pt, weight: "bold", fill: luma(35))
  • #it.body
]
#show heading.where(level: 5): it => block(
  above: 0.85em,
  below: 0.35em,
  width: 100%,
  inset: (left: 10pt),
)[
  #set text(size: 10pt, weight: "bold", fill: luma(55))
  ★ #it.body
]

//init document
#align(center)[
  #text(size: 20pt, weight: "bold")[Taller Ingeniería Inversa]
  #v(0.2em)
  #text(size: 12pt)[Análisis y Diseño de Sistemas II]
  #v(0.1em)
  #text(size: 10.5pt)[Luis Javier Pérez]
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

===== Casilla

Parece definir una casilla en el tablero, cuenta con atributos como fila y columna de tipo entero que parecen definir la ubicación de la casilla en concreto en el tablero, también cuenta con un atributo de estado de tipo String que parecen definir el estado de la casilla (por ejemplo ocupada, bloqueada, libre, etc.) al ser un String parece algo frágil, no está bien definido cuáles son los posibles estados.

Cuenta con métodos relevantes como: compareTo, donde se compara con otra casilla y si la casilla está más arriba (en caso de que la fila sea mayor) o a la derecha (en caso de que la columna sea mayor) retornará 1, en caso de ser menor retornará -1  y en caso de ser igual retornará 0; y los métodos de movimiento los cuales aumentan o disminuyen en uno el valor actual de la casilla, lo cual puede indicar que realmente el tablero no sea un array de casillas como pensé originalmente, sino que casilla represente la posición de la punta del recorrido del usuario al recorrer el laberinto.

===== Laberinto:
Este archivo parece tener varias responsabilidades todas relacionadas con la grilla del laberinto, Se encarga de definir la grilla del laberinto utilizando una matriz de enteros, 10x15, contener los diferentes colores relacionados a las casillas basados en su estado, definir la meta y la salida junto a su posicion, contar con varios tableros escogibles. Entre sus metodos destacan: Un metodo para limpiar y reiniciar el laberinto, Un metodo para hacer una animacion en la GUI del laberinto siendo resuelto Y un metodo para modificar el tipo o estado de una casilla en especifico.
