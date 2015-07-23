# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: Chicago }, { name: Copenhagen }])
#   Mayor.create(name: Emanuel, city: cities.first)

######################
# SEEDING INDUSTRY NAF CLASSIFICATION TABLES
######################
def seed_industry_tables(industry_descr_seed_files)
  low_level_ind_arr_of_arrs = CSV.read( industry_descr_seed_files[:low_level_indus_descr],
                                        col_sep: "$",
                                        headers: true )

  CSV.foreach( industry_descr_seed_files[:top_level_indus_descr],
                col_sep: "$",
                headers: true ) do | row |
      top_level_indus_descr_hash = row.to_hash
      array_of_nested_low_level_indus_descr = []
      row[0].match(/\A\d\z/) ?  search_string = "0#{row[0]}." : search_string = "#{row[0]}."
      low_level_ind_arr_of_arrs.each do | low_level_indus_descr_row |
        if low_level_indus_descr_row[0].match(/\A#{search_string}/)
          low_level_indus_descr_row[0].sub!(".", "")
          array_of_nested_low_level_indus_descr << low_level_indus_descr_row.to_hash
        end
      end
    top_level_indus_descr_hash[:low_level_industries_attributes] = array_of_nested_low_level_indus_descr
    TopLevelIndustry.create(top_level_indus_descr_hash)
  end
end

def launch_industry_table_seeding
  industry_description_seed_files =
    {low_level_indus_descr: "./db/industries_low_level.csv",
    top_level_indus_descr: "./db/industries_top_level.csv"}
  require 'csv'
  seed_industry_tables(industry_description_seed_files)
end

launch_industry_table_seeding

######################
# SEEDING AWARD TABLES
######################
Award.create(name: "Diversity Charter in Sweden")
Award.create(name: "Charta der Vielfalt, Österreich")
Award.create(name: "Charte de la Diversité en Entreprise, France")
Award.create(name: "Label Egalité Diversité, Belgium")
Award.create(name: "Charter de la Diversidad, España")
Award.create(name: "Carta per le pari opportunità e luguaglianza sul lavoro, Italia")
Award.create(name: "Economics Dividend for Gender Equality, U.S.A")

######################
# SEEDING ADDRESSES AND FIRMS
######################
def create_firm_and_address(firm)
  new_firm = Firm.create_with_addresses(firm)
end

array_firm_addresses_belgium = [
    {name: "MyMicroInvest", url: "https://www.mymicroinvest.com/", country: "Belgium", headcount: "48", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-mymicroinvest.svg",
  addresses_attributes:[{city: "Bruxelles", country: "Belgium", street: "Place Sainte-Gudule", number: "5", zip_code: "B-1000"}]},
    {name: "Rabobank", url: "http://www.rabobank.be/‎", country: "Belgium", headcount: "56870", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-rabobank.png",
  addresses_attributes:[{city: "Antwerp-Berchem", country: "Belgium", street: "Uitbreidingstraat", number: "86", zip_code: "B-2600"}]},
    {name: "ING Bank", url: "https://www.ing.be/", country: "Belgium", headcount: "84718", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-ing.svg",
  addresses_attributes:[{city: "Bruxelles", country: "Belgium", street: "Rue Marche Aux Herbes", number: "90", zip_code: "B-1000"}]},
    {name: "ABN AMRO", url: "https://www.abnamro.com/", country: "Belgium", headcount: "24225", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-abnamro.svg",
  addresses_attributes:[{city: "Antwerp-Berchem", country: "Belgium", street: "Roderveldlaan", number: "5 b4", zip_code: "B-2600"}]},
    {name: "KBC", url: "https://www.kbc.com/", country: "Belgium", headcount: "36187", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-kbc.png",
  addresses_attributes:[{city: "Bruxelles", country: "Belgium", street: "Havenlaan", number: "2", zip_code: "B-1000"}]},
    {name: "BK CP", url: "https://www.bkcpbanque.be/", country: "Belgium", headcount: "380", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-bkcp.png",
  addresses_attributes:[{city: "Knokke-Heist", country: "Belgium", street: "Lippenslaan", number: "115", zip_code: "B-8300"}]},
    {name: "BNP Paribas Fortis", url: "https://www.bnpparibasfortis.be/", country: "Belgium", headcount: "200000", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-bnp-paribas.svg",
  addresses_attributes:[{city: "Bruxelles", country: "Belgium", street: "Montagne du Parc", number: "3", zip_code: "B-1000"}]},
    {name: "bpost", url: "https://www.bpost.be/", country: "Belgium", headcount: "25683", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-bpost.svg",
  addresses_attributes:[{city: "Bruxelles", country: "Belgium", street: "Centre Monnaie", number: "", zip_code: "B-1000"}]},
    {name: "Belfius", url: "https://www.belfius.com/", country: "Belgium", headcount: "5742", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-belfius.svg.png",
  addresses_attributes:[{city: "Bruxelles", country: "Belgium", street: "Boulevard Pacheco", number: "44", zip_code: "B-1000"}]},
    {name: "ageas", url: "http://www.ageas.be/", country: "Belgium", headcount: "13071", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-ageas.png",
  addresses_attributes:[{city: "Bruxelles", country: "Belgium", street: "Rue du Marquis", number: "1", zip_code: "B-1000"}]},
    {name: "AXA Banque", url: "https://www.axa.be/", country: "Belgium", headcount: "0", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-axa.png",
  addresses_attributes:[{city: "Bruxelles", country: "Belgium", street: "Boulevard du Souverain", number: "25", zip_code: "B-1170"}]},
    {name: "AB InBev", url: "http://www.ab-inbev.com/", country: "Belgium", headcount: "154029", business_description: "Lorem ipsum", industry: "agroalimentaire", icon_name: "logo-abinbev.png",
  addresses_attributes:[{city: "Leuven", country: "Belgium", street: "Brouwerijplein", number: "1", zip_code: "B-3000"}]},
    {name: "Ackermans & van Haaren", url: "http://en.avh.be/home.aspx", country: "Belgium", headcount: "0", business_description: "Lorem ipsum", industry: "conglomerat", icon_name: "logo-ackermansvanhaaren.png",
  addresses_attributes:[{city: "Antwerp", country: "Belgium", street: "Begijnenvest", number: "113", zip_code: "B-2000"}]},
    {name: "Belgacom", url: "http://www.proximus.com/", country: "Belgium", headcount: "15728", business_description: "Lorem ipsum", industry: "telecommunications", icon_name: "logo-belgacom.png",
  addresses_attributes:[{city: "Bruxelles", country: "Belgium", street: "Boulevard du Roi Albert II", number: "27 B", zip_code: "B-1030"}]},
    {name: "idweaver", url: "http://www.idweaver.com/", country: "Belgium", headcount: "0", business_description: "Lorem ipsum", industry: "professional services", icon_name: "logo-idweaver.svg",
  addresses_attributes:[{city: "Bruxelles", country: "Belgium", street: "Place Sainte-Gudule", number: "5", zip_code: "B-1000"}]}
]

array_firm_addresses_belgium.each do | firm |
  create_firm_and_address(firm)
  sleep 0.5
end

array_firm_addresses_france = [
    {name: "BNP Paribas", url: "http://www.bnpparibas.com/", country: "France", headcount: "200000", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-bnp-paribas.svg", naf_code: "6419Z",
  addresses_attributes: [{city: "Paris", country: "France", street: "Boulevard des Italiens", number: "16", zip_code: "F-75009"}]},
    {name: "Société Générale", url: "https://www.societegenerale.fr/‎", country: "France", headcount: "0", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-socgen.svg", naf_code: "6419Z",
  addresses_attributes: [{city: "Paris", country: "France", street: "Boulevard Haussmann", number: "29", zip_code: "F-75009"}]},
    {name: "Crédit Mutuel", url: "https://www.creditmutuel.fr/", country: "France", headcount: "0", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-creditmutuel.svg", naf_code: "6419Z",
  addresses_attributes: [{city: "Paris", country: "France", street: "Rue Cardinet", number: "88-90", zip_code: "F-75017"}]},
    {name: "Caisse d'Epargne", url: "https://www.caisse-epargne.fr/", country: "France", headcount: "0", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-caisseepargne.svg", naf_code: "6419Z",
  addresses_attributes: [{city: "Paris", country: "France", street: "Avenue Pierre Mendès France", number: "50", zip_code: "75201 Cedex 13"}]},
    {name: "CIC", url: "https://www.cic.fr/", country: "France", headcount: "0", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-cic.svg", naf_code: "6419Z",
  addresses_attributes: [{city: "Paris", country: "France", street: "Avenue de Provence", number: "6", zip_code: "F-75009"}]},
    {name: "Crédit Agricole", url: "http://www.credit-agricole.fr/", country: "France", headcount: "0", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-creditagricole.svg", naf_code: "6419Z",
  addresses_attributes: [{city: "Montrouge", country: "France", street: "Place des États-Unis", number: "12", zip_code: "F-92127"}]},
    {name: "LCL", url: "https://www.lcl.com/", country: "France", headcount: "0", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-lcl.jpg", naf_code: "6419Z",
  addresses_attributes: [{city: "Lyon", country: "France", street: "Rue de la République", number: "18", zip_code: "F-69002"}]},
    {name: "Banque Populaire", url: "http://www.banquepopulaire.fr/", country: "France", headcount: "0", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-banquepopulaire.svg", naf_code: "6419Z",
  addresses_attributes: [{city: "Paris", country: "France", street: "Avenue Pierre Mendès-France", number: "50", zip_code: "F-75013"}]},
    {name: "AXA", url: "https://www.axa.fr/", country: "France", headcount: "0", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-axa.png", naf_code: "6419Z",
  addresses_attributes: [{city: "Paris", country: "France", street: "Avenue Matignon", number: "25", zip_code: "F-75008"}]},
    {name: "La Banque Postale", url: "https://www.labanquepostale.fr/", country: "France", headcount: "0", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-labanquepostale.svg", naf_code: "6419Z",
  addresses_attributes: [{city: "Paris", country: "France", street: "Boulevard du Montparnasse", number: "83", zip_code: "F-75006"}]}
]

array_firm_addresses_france.each do | firm |
  create_firm_and_address(firm)
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

def add_address_to_existing_firm(firm, address)
  if Firm.find_by_name(firm).nil?
    puts "could not find #{firm}"
  end
  searched_firm = Firm.find_by_name(firm)
  searched_firm.add_addresses(addresses_attributes:[address])
  sleep 0.5
end

additional_addresses.each do | array |
  add_address_to_existing_firm(array[0][:name], array[1])
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

def create_user
  user = User.create({
    email: Faker::Internet.email,
    password: "1234567890",
    password_confirmation: "1234567890",
    validated: true
  })
  user.id
end

250.times do
  user_id = create_user

  date = [Time.new(2015, 06, 01),Time.now].sample

  tests = Test.all
  answers = []
  tests.each do | test |
    answer = {
      user_rating: Random.rand(5) + 1,
      test_id: test.id,
      created_at: date
    }
    answers << answer
  end

  review = Review.create({
    firm_id: Random.rand(25) + 1,
    user_id: user_id,
    user_firm_relationship: "employee",
    confirmed_t_and_c: true,
    validated: true,
    created_at: date,
    answers_attributes: answers
  })
end

def create_review_and_answers_for_favorite_firms(user_id, favorite_firm)
  tests = Test.all

  answers = []
  tests.each do | test |
    answer = {
      user_rating: favorite_firm[:user_rating],
      test_id: test.id
    }
    answers << answer
  end
  review = Review.create({
    firm_id: favorite_firm[:id],
    user_id: user_id,
    user_firm_relationship: "employee",
    confirmed_t_and_c: true,
    validated: true,
    answers_attributes: answers
  })
end

def create_favorable_review(favorite_firm)
  user_id = create_user
  create_review_and_answers_for_favorite_firms(user_id, favorite_firm)
end

favorite_firms = [
  {id: 1, user_rating: 5, favors_count: 10},
  {id: 5, user_rating: 5, favors_count: 5},
  {id: 7, user_rating: 5, favors_count: 5}
]

favorite_firms.each do | favorite_firm |
  favorite_firm[:favors_count].times do
    create_favorable_review(favorite_firm)
  end
end
