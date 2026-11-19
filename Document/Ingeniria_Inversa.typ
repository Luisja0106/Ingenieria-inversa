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
#show heading.where(level: 1): set text(size: 20pt)
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
#show heading.where(level: 3): set text(size: 11.5pt)
#show heading.where(level: 4): it => block(
  above: 0.9em,
  below: 0.35em,
  width: 100%,
  inset: (left: 7pt),
  stroke: (left: 2pt + luma(190)),
)[
  #set text(size: 10.5pt, weight: "bold", fill: luma(35))
  #it.body
]

//init document
#align(center)[
  = Taller Ingenieria Inversa
  #v(0.2em)
  #text(size: 12pt)[Análisis y Diseño de Sistemas II]
  #v(0.1em)
  #text(size: 10.5pt)[Luis Javier Pérez]
]

