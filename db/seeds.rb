# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: Chicago }, { name: Copenhagen }])
#   Mayor.create(name: Emanuel, city: cities.first)

Award.create(name: "Diversity Charter in Sweden")
Award.create(name: "Charta der Vielfalt, Österreich")
Award.create(name: "Charte de la Diversité en Entreprise, France")
Award.create(name: "Label Egalité Diversité, Belgium")
Award.create(name: "Charter de la Diversidad, España")
Award.create(name: "Carta per le pari opportunità e luguaglianza sul lavoro, Italia")
Award.create(name: "Economics Dividend for Gender Equality, U.S.A")

def create_firm_and_address(firm, address)
  new_firm = Firm.create(firm)
  new_address = Address.create(address)
  new_firm.addresses << new_address
  new_firm.save!
end

array_firm_addresses = [
  [
    {name: "MyMicroInvest", url: "https://www.mymicroinvest.com/", country: "Belgium", headcount: "48", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-mymicroinvest.svg"},
  {city: "Bruxelles", country: "Belgium", street: "Place Sainte-Gudule", number: "5", zip_code: "B-1000"}
  ],
  [
    {name: "Rabobank", url: "http://www.rabobank.be/‎", country: "Belgium", headcount: "56870", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-rabobank.png"},
  {city: "Antwerp-Berchem", country: "Belgium", street: "Uitbreidingstraat", number: "86", zip_code: "B-2600"}
  ],
  [
    {name: "ING Bank", url: "https://www.ing.be/", country: "Belgium", headcount: "84718", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-ing.svg"},
  {city: "Bruxelles", country: "Belgium", street: "Rue Marche Aux Herbes", number: "90", zip_code: "B-1000"}
  ],
  [
    {name: "ABN AMRO", url: "https://www.abnamro.com/", country: "Belgium", headcount: "24225", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-abnamro.svg"},
  {city: "Antwerp-Berchem", country: "Belgium", street: "Roderveldlaan", number: "5 b4", zip_code: "B-2600"}
  ],
  [
    {name: "KBC", url: "https://www.kbc.com/", country: "Belgium", headcount: "36187", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-kbc.png"},
  {city: "Bruxelles", country: "Belgium", street: "Havenlaan", number: "2", zip_code: "B-1000"}
  ],
  [
    {name: "BK CP", url: "https://www.bkcpbanque.be/", country: "Belgium", headcount: "380", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-bkcp.png"},
  {city: "Knokke-Heist", country: "Belgium", street: "Lippenslaan", number: "115", zip_code: "B-8300"}
  ],
  [
    {name: "BNP Paribas Fortis", url: "https://www.bnpparibasfortis.be/", country: "Belgium", headcount: "200000", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-bnp-paribas.svg"},
  {city: "Bruxelles", country: "Belgium", street: "Montagne du Parc", number: "3", zip_code: "B-1000"}
  ],
  [
    {name: "bpost", url: "https://www.bpost.be/", country: "Belgium", headcount: "25683", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-bpost.svg"},
  {city: "Bruxelles", country: "Belgium", street: "Centre Monnaie", number: "", zip_code: "B-1000"}
  ],
  [
    {name: "Belfius", url: "https://www.belfius.com/", country: "Belgium", headcount: "5742", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-belfius.svg.png"},
  {city: "Bruxelles", country: "Belgium", street: "Boulevard Pacheco", number: "44", zip_code: "B-1000"}
  ],
  [
    {name: "ageas", url: "http://www.ageas.be/", country: "Belgium", headcount: "13071", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-ageas.png"},
  {city: "Bruxelles", country: "Belgium", street: "Rue du Marquis", number: "1", zip_code: "B-1000"}
  ],
  [
    {name: "AXA Banque", url: "https://www.axa.be/", country: "Belgium", headcount: "N.A.", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-axa.png"},
  {city: "Bruxelles", country: "Belgium", street: "Boulevard du Souverain", number: "25", zip_code: "B-1170"}
  ],
  [
    {name: "AB InBev", url: "http://www.ab-inbev.com/", country: "Belgium", headcount: "154029", business_description: "Lorem ipsum", industry: "agroalimentaire", icon_name: "logo-abinbev.png"},
  {city: "Leuven", country: "Belgium", street: "Brouwerijplein", number: "1", zip_code: "B-3000"}
  ],
  [
    {name: "Ackermans & van Haaren", url: "http://en.avh.be/home.aspx", country: "Belgium", headcount: "N.A.", business_description: "Lorem ipsum", industry: "conglomerat", icon_name: "logo-ackermansvanhaaren.png"},
  {city: "Antwerp", country: "Belgium", street: "Begijnenvest", number: "113", zip_code: "B-2000"}
  ],
  [
    {name: "Belgacom", url: "http://www.proximus.com/", country: "Belgium", headcount: "15728", business_description: "Lorem ipsum", industry: "telecommunications", icon_name: "logo-belgacom.png"},
  {city: "Bruxelles", country: "Belgium", street: "Boulevard du Roi Albert II", number: "27 B", zip_code: "B-1030"}
  ]
]

array_firm_addresses.each do | array |
  create_firm_and_address(array[0], array[1])
  sleep 0.5
end

firm = Firm.create({name: "idweaver", url: "http://www.idweaver.com/", country: "Belgium", headcount: "N.A.", business_description: "Lorem ipsum", industry: "professional services", icon_name: "logo-idweaver.svg"})
firm.addresses << Address.first
firm.save!

array_firm_addresses = [
  [
    {name: "BNP Paribas", url: "http://www.bnpparibas.com/", country: "France", headcount: "200000", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-bnp-paribas.svg"},
  {city: "Paris", country: "France", street: "Boulevard des Italiens", number: "16", zip_code: "F-75009"}
  ],
  [
    {name: "Société Générale", url: "https://www.societegenerale.fr/‎", country: "France", headcount: "N.A.", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-socgen.svg"},
  {city: "Paris", country: "France", street: "Boulevard Haussmann", number: "29", zip_code: "F-75009"}
  ],
  [
    {name: "Crédit Mutuel", url: "https://www.creditmutuel.fr/", country: "France", headcount: "N.A.", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-creditmutuel.svg"},
  {city: "Paris", country: "France", street: "Rue Cardinet", number: "88-90", zip_code: "F-75017"}
  ],
  [
    {name: "Caisse d'Epargne", url: "https://www.caisse-epargne.fr/", country: "France", headcount: "N.A.", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-caisseepargne.svg"},
  {city: "Paris", country: "France", street: "Avenue Pierre Mendès France", number: "50", zip_code: "75201 Cedex 13"}
  ],
  [
    {name: "CIC", url: "https://www.cic.fr/", country: "France", headcount: "N.A.", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-cic.svg"},
  {city: "Paris", country: "France", street: "Avenue de Provence", number: "6", zip_code: "F-75009"}
  ],
  [
    {name: "Crédit Agricole", url: "http://www.credit-agricole.fr/", country: "France", headcount: "N.A.", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-creditagricole.svg"},
  {city: "Montrouge", country: "France", street: "Place des États-Unis", number: "12", zip_code: "F-92127"}
  ],
  [
    {name: "LCL", url: "https://www.lcl.com/", country: "France", headcount: "N.A.", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-lcl.jpg"},
  {city: "Lyon", country: "France", street: "Rue de la République", number: "18", zip_code: "F-69002"}
  ],
  [
    {name: "Banque Populaire", url: "http://www.banquepopulaire.fr/", country: "France", headcount: "N.A.", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-banquepopulaire.svg"},
  {city: "Paris", country: "France", street: "Avenue Pierre Mendès-France", number: "50", zip_code: "F-75013"}
  ],
  [
    {name: "AXA", url: "https://www.axa.fr/", country: "France", headcount: "N.A.", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-axa.png"},
  {city: "Paris", country: "France", street: "Avenue Matignon", number: "25", zip_code: "F-75008"}
  ],
  [
    {name: "La Banque Postale", url: "https://www.labanquepostale.fr/", country: "France", headcount: "N.A.", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-labanquepostale.svg"},
  {city: "Paris", country: "France", street: "Boulevard du Montparnasse", number: "83", zip_code: "F-75006"}
  ]
]

array_firm_addresses.each do | array |
  create_firm_and_address(array[0], array[1])
  sleep 0.5
end

additional_addresses = [
  [ {name: "BNP Paribas"},
    {city: "Figeac", country: "France", street: "Boulevard Georges Juskiewenski", number: "4", zip_code: "F-46100"}
  ],
  [ {name: "BNP Paribas"},
    {city: "Nimes", country: "France", street: "Le Paseo, Rue de San Lucar", number: "", zip_code: "F-30900"}
  ],
  [ {name: "Société Générale"},
    {city: "Figeac", country: "France", street: "Rue Gambetta", number: "31", zip_code: "F-46100"}
  ],
  [ {name: "Société Générale"},
    {city: "Nimes", country: "France", street: "Rue Paul Laurent", number: "120", zip_code: "F-30000"}
  ],
  [ {name: "Crédit Mutuel"},
    {city: "Figeac", country: "France", street: "Quai Albert Bessières", number: "8 C", zip_code: "F-46100"}
  ],
  [ {name: "Crédit Mutuel"},
    {city: "Nimes", country: "France", street: "Allée de Séville", number: "102", zip_code: "F-30900"}
  ],
  [ {name: "Caisse d'Epargne"},
    {city: "Figeac", country: "France", street: "Place aux Herbes", number: "2", zip_code: "F-46100"}
  ],
  [ {name: "Caisse d'Epargne"},
    {city: "Nimes", country: "France", street: "Rue Jean Lauret", number: "148", zip_code: "F-30900", addr_complement: "Centre Commercial Carré Sud"}
  ],
  [ {name: "CIC"},
    {city: "Figeac", country: "France", street: "Avenue Fernand Pezet", number: "7", zip_code: "F-46100"}
  ],
  [ {name: "CIC"},
    {city: "Nimes", country: "France", street: "Allée Amérique Latine", number: "308", zip_code: "F-30000"}
  ],
  [ {name: "Crédit Agricole"},
    {city: "Figeac", country: "France", street: "Avenue Fernand Pezet", number: "9", zip_code: "F-46100"}
  ],
  [ {name: "Crédit Agricole"},
    {city: "Caissargues", country: "France", street: "Avenue de la Dame", number: "", zip_code: "F-30132", addr_complement: "Zone Euro 2000"}
  ],
  [ {name: "LCL"},
    {city: "Figeac", country: "France", street: "Rue Gambetta", number: "35", zip_code: "F-46100"}
  ],
  [ {name: "LCL"},
    {city: "Villejuif", country: "France", street: "Avenue de Paris", number: "20", zip_code: "F-94811"}
  ],
  [ {name: "LCL"},
    {city: "Nimes", country: "France", street: "Rue de la République", number: "81", zip_code: "F-30900"}
  ],
  [ {name: "Banque Populaire"},
    {city: "Figeac", country: "France", street: "Place Léon Besombes", number: "", zip_code: "F-46100"}
  ],
  [ {name: "Banque Populaire"},
    {city: "Caissargues", country: "France", street: "Avenue de la Dame", number: "", zip_code: "F-30132", addr_complement: "Zone Euro 2000"}
  ],
  [ {name: "AXA"},
    {city: "Figeac", country: "France", street: "Rue Paul Bert", number: "5", zip_code: "F-46100"}
  ],
  [ {name: "AXA"},
    {city: "Figeac", country: "France", street: "Avenue du Marechal Joffre", number: "6", zip_code: "F-46100"}
  ],
  [ {name: "AXA"},
    {city: "Nimes", country: "France", street: "Avenue Jean Jaures", number: "57", zip_code: "F-30913"}
  ],
  [ {name: "La Banque Postale"},
    {city: "Figeac", country: "France", street: "Avenue Fernand Pezet", number: "", zip_code: "F-46100"}
  ],
  [ {name: "La Banque Postale"},
    {city: "Caissargues", country: "France", street: "Place Marie Rose Pons", number: "", zip_code: "F-30132"}
  ]
]

def add_address_existing_firm(firm, address)
  if Firm.find_by_name(firm).nil?
    puts "could not find #{firm}"
  end
  searched_firm = Firm.find_by_name(firm)
  new_address = Address.create(address)
  searched_firm.addresses << new_address
  searched_firm.save!
  sleep 0.5
end

additional_addresses.each do | array |
  add_address_existing_firm(array[0][:name], array[1])
end

25.times do
  award = GrantedAward.new({
    award_id: Random.rand(7) + 1,
    firm_id: Random.rand(25) + 1
  })
  award.save
end

Test.create(test_question: "Absence of sexists comments", test_long_question: "How frequent are sexists comments at this firm?", positive_negative_switch: "positive", select_options: "Very frequent; Fairly frequent; No more than anywhere else; Quite rare; Extremely rare")
Test.create(test_question: "Absence of pregnancy related issues", test_long_question: "How is the pregnancy of an employee resented in this firm?", positive_negative_switch: "positive", select_options: "Very cumbersome; Cumbersome; Not worse than anywhere else; Quite easy; Really easy")
Test.create(test_question: "Equal promotion opportunities", test_long_question: "Are female and male employees in the same position offered the same promotion opportunities in this firm?", positive_negative_switch: "positive", select_options: "Never; Sometimes; Quite often; Frequently; Always")
Test.create(test_question: "Equal pay", test_long_question: "Are female and male employees in the same position offered the same wage at this firm?", positive_negative_switch: "positive", select_options: "Never; Sometimes; Quite often; Frequently; Always")
Test.create(test_question: "Absence of harassment", test_long_question: "Are there any sexual harassment related issues at this firm?", positive_negative_switch: "positive", select_options: "Very frequently; Frequently; Now and then; Almost never; Never")

250.times do
  user = User.new({
    email: Faker::Internet.email,
    password: "1234567890",
    password_confirmation: "1234567890",
    validated: true
  })
  user.save
  review_date = [Time.new(2015, 06, 01),Time.now].sample
  review = Review.new({
    firm_id: Random.rand(25) + 1,
    user_id: user.id,
    user_firm_relationship: "employee",
    confirmed_t_and_c: true,
    validated: true,
    created_at: review_date
  })
  review.save
  tests = Test.all
  tests.each do | test |
    Answer.create({
      user_rating: Random.rand(5) + 1,
      review_id: review.id,
      test_id: test.id,
      created_at: review_date,
      reviewed_by_user: true
    })
  end
end

10.times do
  user = User.new({
    email: Faker::Internet.email,
    password: "1234567890",
    password_confirmation: "1234567890",
    validated: true
  })
  user.save
  review = Review.new({
    firm_id: 1,
    user_id: user.id,
    user_firm_relationship: "employee",
    validated: true
  })
  review.save
  tests = Test.all
  tests.each do | test |
    Answer.create({
      user_rating: 5,
      review_id: review.id,
      test_id: test.id,
      reviewed_by_user: true
    })
  end
end

2.times do
  user = User.new({
    email: Faker::Internet.email,
    password: "1234567890",
    password_confirmation: "1234567890",
    validated: true
  })
  user.save
  review = Review.new({
    firm_id: 1,
    user_id: user.id,
    user_firm_relationship: "employee",
    validated: true
  })
  review.save
  test = Test.all.fetch(4)
  Answer.create({
    user_rating: 5,
    review_id: review.id,
    test_id: test.id,
    reviewed_by_user: true
  })
end


5.times do
  user = User.new({
    email: Faker::Internet.email,
    password: "1234567890",
    password_confirmation: "1234567890",
    validated: true
  })
  user.save
  review = Review.new({
    firm_id: 5,
    user_id: user.id,
    user_firm_relationship: "employee",
    validated: true
  })
  review.save
  tests = Test.all
  tests.each do | test |
    Answer.create({
      user_rating: 5,
      review_id: review.id,
      test_id: test.id,
      reviewed_by_user: true
    })
  end
end

5.times do
  user = User.new({
    email: Faker::Internet.email,
    password: "1234567890",
    password_confirmation: "1234567890",
    validated: true
  })
  user.save
  review = Review.new({
    firm_id: 7,
    user_id: user.id,
    user_firm_relationship: "employee",
    validated: true
  })
  review.save
  tests = Test.all
  tests.each do | test |
    Answer.create({
      user_rating: 5,
      review_id: review.id,
      test_id: test.id,
      reviewed_by_user: true
    })
  end
end
