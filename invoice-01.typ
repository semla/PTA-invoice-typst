#set page("a4")

#let static_data = toml("static_data.toml")
#let client_data = toml("clients.toml")
#let balance_from_pta_export = json(static_data.invoice.data_dir + "/" + static_data.invoice.balance_file)
#let report_from_pta_export = json(static_data.invoice.data_dir + "/" + static_data.invoice.report_file)

#let balance_data = "Not found or array empty"
#if "deltas" in balance_from_pta_export and type(balance_from_pta_export.deltas) == array and balance_from_pta_export.deltas.len() > 0 {
  balance_data = balance_from_pta_export
    .deltas
}

#let registry_data = "Not found or array empty"
#if "transactions" in report_from_pta_export and type( report_from_pta_export.transactions) == array and report_from_pta_export.transactions.len() > 0 {
  registry_data = report_from_pta_export
    .transactions
}

#let invoice_date_str = datetime.today().display()


#if static_data.invoice.invoice_date.len() > 1 {
  invoice_date_str = static_data.invoice.invoice_date
}

#set page(
  header: [
    Invoice
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
      columns: (1fr, 1fr, 1.8fr),
      rect(fill: luma(245), inset: (x:3mm,y:3mm))[
        #static_data.sender.company_name \
        #static_data.sender.personal_name \
        #static_data.sender.address 
      ],

      rect(fill: luma(245),inset: (x:3mm,y:3mm))[
        #link("mailto:" + static_data.sender.email)[#static_data.sender.email] \
        #static_data.sender.phone \
        #link(static_data.sender.web)
      ],

       rect(fill: luma(245),inset: (x:3mm,y:3mm))[
        #for (key, value) in static_data.bank {
          strong(key) +": "+ value +"\n"
        }
       ]
    ),
  ),
)

#let client = client_data.clients.find(item => item.id == client_data.client_id_to_use)

// placement for sending a printed copy in a c5 envelope with "window" h2
#let address_placement_y = 44 - 25
// 297 / 2 + 83 + 25
#let address_placement_x = 114

#if static_data.sender.logo_path.len() > 1 {
  v(address_placement_y*1mm)
  image(static_data.sender.logo_path)
} else {
  static_data.sender.company_name
}



#place(
  top + left,
  dx: address_placement_x * 1mm,
  dy: address_placement_y * 1mm,
  [#client.name \
    #client.address],
)

// #let amount_str = invoice_tx.postings.find(item => item.account == static_data.invoice.account_name_for_amount).runningTotal
#let amount_str = balance_data.at(0).delta
#let amount = float(amount_str)
#let commodity = balance_data.at(0).commodity

/*
#let vat = 0

 #let vat_str = invoice_tx.postings.find(item => item.account == static_data.invoice.account_name_for_vat)
#if vat_str != none {
  // && if vat_str.amount != none {
  vat = float(vat_str.amount)
} 

#let total = amount + vat
*/
#align(horizon)[
    #for (key, value) in client {
      if(key != "id" and key != "name" and key != "address") {
          key +": "+ value +"\n"
        }
  }

    Invoice number: #static_data.invoice.invoice_number \ 
]


#align(horizon)[== Summary
Total: #strong(amount_str) #strong(commodity) \
Due date: #strong(static_data.invoice.due_date)

#h(1em)
== Specification
  #table(
    columns: 3,
    table.header([*Date*], [*Description*], [*Amount*]),
    //..invoice_tx.map(v => (v.displayTime,v.txn.description,v.postings.at(0).amount)),
         ..for (value) in registry_data {
      (value.displayTime, value.txn.description, value.postings.at(0).amount +" "+ value.postings.at(0).commodity)
    } 
  )
]

