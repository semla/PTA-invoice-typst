# PTA Typst Invoice

**WIP** invoice for use with PTA software like [Tackler](https://tackler.fi/).\
The address placement *hopefully* fits a C5 envelope with an h2 "window".

## PTA
Read more about [PTA - Plain Text Accounting](https://plaintextaccounting.org/). It should be possible to support all pta software that exports to json.

## Data
The invoice reads from .toml and .json files:
- clients.toml
- static_data.toml
- a json file containing the transaction data, the file name is specified in static_data.toml

### JSON
Generate the json with something like:\
`tackler --config journal/conf/tackler.toml  --output.dir . --output.prefix report`

### PDF
Create pdf with:\
`typst compile invoice-01.typ`

### Preview

---

![](thumbnail.png)

---

## Disclaimer
The invoice may not fullfill legal requirements for your country.\
It is also a work in progress.
