#set page("a4")

#let static_data = toml("static_data.toml")
#let client_data = toml("clients.toml")
#let tx_data = json(static_data.invoice.data_dir + static_data.invoice.data_file)

#let invoice_tx = "Not found or array empty"
#if "transactions" in tx_data and type(tx_data.transactions) == array and tx_data.transactions.len() > 0 {
  invoice_tx = tx_data
    .transactions
    .filter(item => item.txn.description.contains(static_data.invoice.filter_for_register_report))
    .last()
}

#let invoice_date_str = datetime.today().display()
#if static_data.invoice.invoice_date.len() > 1 {
  invoice_date_str = static_data.invoice.invoice_date
}

#set page(
  header: [
    #h(1fr)
    #invoice_date_str
    #h(1fr)
    #context counter(page).display(
      "1/1",
      both: true,
    )
  ],
)

#set page(
  margin: (bottom: 8cm),
  footer: 
line(start:(-1cm, 0cm), end: (17cm, 0cm), stroke: (thickness: 0.1mm)) + block(
    width: 100%,
    grid(
      columns: (1fr, 1fr, 1.6fr), // Four equal-width columns
      gutter: 0.5em,
      rect(fill: luma(245), inset: (x:5mm,y:3mm))[
        #static_data.sender.company_name \
        #static_data.sender.personal_name \
        #static_data.sender.address 
      ],

      rect(fill: luma(245),inset: (x:5mm,y:3mm))[
        #link("mailto:" + static_data.sender.email)[#static_data.sender.email] \
        #static_data.sender.phone \
        #link(static_data.sender.web)
      ],

       rect(fill: luma(245),inset: (x:5mm,y:3mm))[
        #for (key, value) in static_data.bank {
          key +": "+ value +"\n"
        }
       ]
    ),
  ),
)

#if static_data.invoice.logo_path.len() > 1 {
  image(static_data.invoice.logo_path)
} else {
  static_data.sender.company_name
}



#let client = client_data.clients.find(item => item.id == client_data.client_id_to_use)

// placement for sending a printed copy in a c5 envelope with "window" h2
#let address_placement_y = 44 - 25
// 297 / 2 + 83 + 25
#let address_placement_x = 114

#place(
  top + left,
  dx: address_placement_x * 1mm,
  dy: address_placement_y * 1mm,
  [#client.name \
    #client.address],
)


#let description = if static_data.invoice.specification_override.len() < 1 {
  invoice_tx.txn.description
} else {
  static_data.invoice.specification_override
}

#let amount_str = invoice_tx.postings.find(item => item.account == static_data.invoice.account_name_for_amount).amount
#let amount = float(amount_str)

#let vat = 0
#let vat_str = invoice_tx.postings.find(item => item.account == static_data.invoice.account_name_for_vat)
#if vat_str != none {
  // && if vat_str.amount != none {
  vat = float(vat_str.amount)
}

#let total = amount + vat

#align(horizon)[
  #table(
    columns: 4,
    [*Specification*], [*Amount*], [*Vat*], [*Total*],
    [#description], [#calc.abs(amount)], [#vat], [#calc.abs(total)],
  )
]

