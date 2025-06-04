# PTA Typst Invoice

WIP invoice for use with PTA software like [Tackler](https://tackler.fi/).

## PTA
Read more about [PTA - Plain Text Accounting](https://plaintextaccounting.org/).
Hopefully in the future this invoice will work with all PTA software that exports json. 

## JSON
Generate json with something like:\
`tackler --config journal/conf/tackler.toml  --output.dir .     --output.prefix report`

## PDF
Create pdf with:\
`typst compile invoice-01.typ`

## Details
The invoice reads from .toml and .json files.
- clients.toml
- static_data.toml
- a json file containing the transaction data, the file name is specified in static_data.toml

## Preview

![](thumbnail.png)


## Disclaimer
The invoice may not fullfill legal requirements for your country.
