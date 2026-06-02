#let project(
  title: "",
  subtitle: "",
  course: "",
  semester: "",
  institution: "",
  department: "",
  authors: (),
  body
) = {
  // Page setup
  set page(
    paper: "a4",
    margin: (x: 2.5cm, top: 3cm, bottom: 2.5cm),
    header: context {
      if here().page() > 1 {
        align(right, text(8pt, fill: luma(120), style: "italic")[#title | IPB SPACE])
      }
    },
    footer: context {
      if here().page() > 1 {
        let page_number = counter(page).get().first()
        let total_pages = counter(page).final().first()
        align(center, text(9pt, fill: luma(100))[Halaman #page_number dari #total_pages])
      }
    }
  )

  // Text setup
  set text(
    font: "Liberation Sans",
    size: 11pt,
    lang: "id"
  )

  // Paragraph setup
  set par(justify: true, leading: 0.65em)

  // Heading setup
  show heading: set text(fill: black)
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(1cm)
    align(center, text(14pt, weight: "bold")[#it.body])
    v(0.5cm)
  }
  show heading.where(level: 2): it => {
    v(0.5cm)
    text(12pt, weight: "bold")[#it.body]
    v(0.2cm)
  }
  show heading.where(level: 3): it => {
    v(0.3cm)
    text(11pt, weight: "bold", style: "italic")[#it.body]
    v(0.1cm)
  }

  // Halaman Sampul (Cover Page)
  align(center)[
    #v(2cm)
    #text(18pt, weight: "bold", fill: black)[#title]
    
    #v(0.5cm)
    #text(16pt, weight: "bold")[IPB SPACE]
    
    #v(0.3cm)
    #text(12pt, style: "italic", fill: luma(80))[#subtitle]
    
    #v(1.5cm)
    #rect(width: 80%, height: 0.5mm, fill: luma(80))
    
    #v(1.5cm)
    #text(11pt)[
      *#course*\
      #semester
    ]
    
    #v(2.5cm)
    #text(11pt)[*Disusun oleh (Kelompok 11):*]
    #v(0.2cm)
    #table(
      columns: (1fr, 1fr),
      align: (left, center),
      stroke: none,
      ..authors.map(author => (author.name, author.nim)).flatten()
    )
    
    #v(3cm)
    #text(12pt, weight: "bold")[#department]
    #text(11pt)[
      #institution\
      2026
    ]
  ]

  pagebreak()
  body
}
