# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Firm.create(name: "MyMicroInvest", url: "https://www.mymicroinvest.com/", country: "Belgium", headcount: "48", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-mymicroinvest.svg")
Firm.create(name: "Rabobank", url: "http://www.rabobank.be/‎", country: "Belgium", headcount: "56870", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-rabobank.png")
Firm.create(name: "ING Bank", url: "https://www.ing.be/", country: "Belgium", headcount: "84718", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-ing.svg")
Firm.create(name: "ABN AMRO", url: "https://www.abnamro.com/", country: "Belgium", headcount: "24225", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-abnamro.svg")
Firm.create(name: "KBC", url: "https://www.kbc.com/", country: "Belgium", headcount: "36187", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-kbc.png")
Firm.create(name: "BK CP", url: "https://www.bkcpbanque.be/", country: "Belgium", headcount: "380", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-bkcp.png")
Firm.create(name: "BNP Paribas Fortis", url: "https://www.bnpparibasfortis.be/", country: "Belgium", headcount: "200000", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-bnp-paribas.svg")
Firm.create(name: "bpost", url: "https://www.bpost.be/", country: "Belgium", headcount: "25683", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-bpost.svg")

10.times do
  user = User.new({
    email: Faker::Internet.email,
    password: 'azazazazaz',
    password_confirmation: 'azazazazaz'
  })
  user.save
end
