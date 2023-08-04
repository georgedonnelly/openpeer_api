# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


currencies = FiatCurrency.create([
  { name: 'Indian Ruppee', code: 'INR', symbol: '₹', country_code: 'IN' },
  { name: 'Brazilian Real', code: 'BRL', symbol: 'R$', country_code: 'BR' },
  { name: 'Australian Dollar', code: 'AUD', symbol: 'A$', country_code: 'AU' },
  { name: 'US Dollar', code: 'USD', symbol: '$', country_code: 'US' },
  { name: 'Singapore Dollar', code: 'SGD', symbol: '$', country_code: 'SG' },
  { name: 'Hong Kong Dollar', code: 'HKD', symbol: '$', country_code: 'HK' },
  { name: 'British Pound', code: 'GBP', symbol: '£', country_code: 'GB' },
  { name: 'Euro', code: 'EUR', symbol: '€', country_code: 'EU' }
])

Bank.create([
  { name: "UPI", fiat_currency: currencies[0], account_info_schema: [{"label"=>"UPI ID", "id"=>"upi_id", "required"=>true }, { "label"=>"Details", "id"=>"details", "type"=>"textarea", "required"=>false }] },
  { name: "PayID", fiat_currency: currencies[1], account_info_schema: [{"label"=>"PayID Phone or Email", "id"=>"payid", "required"=>true }, { "label"=>"Details", "id"=>"details", "type"=>"textarea", "required"=>false }] },
  { name: "PIX", fiat_currency: currencies[2], account_info_schema: [{"label"=>"Pix Key", "id"=>"pix_key", "required"=>true }, { "label"=>"Details", "id"=>"details", "type"=>"textarea", "required"=>false }] },
  { name: 'Revolut', account_info_schema: [{"label"=>"Revtag", "id"=>"revtag", "required"=>true }, { "label"=>"Details", "id"=>"details", "type"=>"textarea", "required"=>false }]},
  { name: 'Bank Transfer', account_info_schema: [{"label"=>"Account Name", "id"=>"account_name", "required"=>true }, {"label"=>"Account Number", "id"=>"account_number", "required"=>true },
                                                 { "label"=>"Details", "id"=>"details", "type"=>"textarea", "required"=> false },
                                                 {"type"=>"message", "label"=>"We recommend only using instant bank transfer methods to settle trades quickly and without disputes."}]}
])

Token.create([{ chain_id: 80001, address: "0x0000000000000000000000000000000000000000",
                decimals: 18, name: 'Matic MUMBAI', symbol: 'MATIC', coingecko_id: 'matic-network' },
              { chain_id: 80001, address: "0x04B2A6E51272c82932ecaB31A5Ab5aC32AE168C3",
                decimals: 18, name: 'GFARMDAI', symbol: 'GFARMDAI', coingecko_id: 'dai' },
              { address: "0xc2132D05D31c914a87C6611C10748AEb04B58e8F", decimals: 6,
                   symbol: "USDT", name: "USDT", chain_id: 137, coingecko_id: "tether", coinmarketcap_id: "multi-collateral-dai" },
              { address: "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174",
                 decimals: 6, symbol: "USDC", name: "USDC", chain_id: 137, coingecko_id: "usd-coin" },
              { address: "0x0000000000000000000000000000000000000000", decimals: 18, symbol: "MATIC",
                 name: "MATIC", chain_id: 137, coingecko_id: "matic-network" }
              ])
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?