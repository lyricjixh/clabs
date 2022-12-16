term deny-from-bogons {
  source-address:: BOGON
  action:: deny
}

term deny-from-reserved {
  source-address:: RESERVED
  action:: deny
}

