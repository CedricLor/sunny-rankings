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

Firm.create(name: "MyMicroInvest", url: "https://www.mymicroinvest.com/", country: "Belgium", headcount: "48", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-mymicroinvest.svg")
Firm.create(name: "Rabobank", url: "http://www.rabobank.be/‎", country: "Belgium", headcount: "56870", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-rabobank.png")
Firm.create(name: "ING Bank", url: "https://www.ing.be/", country: "Belgium", headcount: "84718", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-ing.svg")
Firm.create(name: "ABN AMRO", url: "https://www.abnamro.com/", country: "Belgium", headcount: "24225", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-abnamro.svg")
Firm.create(name: "KBC", url: "https://www.kbc.com/", country: "Belgium", headcount: "36187", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-kbc.png")
Firm.create(name: "BK CP", url: "https://www.bkcpbanque.be/", country: "Belgium", headcount: "380", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-bkcp.png")
Firm.create(name: "BNP Paribas Fortis", url: "https://www.bnpparibasfortis.be/", country: "Belgium", headcount: "200000", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-bnp-paribas.svg")
Firm.create(name: "bpost", url: "https://www.bpost.be/", country: "Belgium", headcount: "25683", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-bpost.svg")
Firm.create(name: "Belfius", url: "https://www.belfius.com/", country: "Belgium", headcount: "5742", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-belfius.svg.png")
Firm.create(name: "ageas", url: "http://www.ageas.be/", country: "Belgium", headcount: "13071", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-ageas.png")
Firm.create(name: "AXA Banque", url: "https://www.axa.be/", country: "Belgium", headcount: "N.A.", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-axa.png")


8.times do
  award = GrantedAward.new({
    award_id: Random.rand(7) + 1,
    firm_id: Random.rand(11) + 1
  })
  award.save
end

Test.create(test_question: "Absence of sexists comments", test_long_question: "Sexist comments on my workplace are frequent", positive_negative_switch: "negative", select_options: "Very frequent; Fairly frequent; No more than anywhere else; Quite rare; Extremely rare")
Test.create(test_question: "Absence of pregnancy related issues", test_long_question: "Pregnancy of an employee is resented as cumbersome", positive_negative_switch: "negative", select_options: "Never; Sometimes; No more than anywhere else; Frequently; Always")
Test.create(test_question: "Equal promotion opportunities", test_long_question: "Female and male employees in the same position are offered the same promotion opportunities", positive_negative_switch: "positive", select_options: "Never; Sometimes; No more than anywhere else; Frequently; Always")
Test.create(test_question: "Equal pay", test_long_question: "Male and female workers in the same position are offered the same wage", positive_negative_switch: "positive", select_options: "Never; Sometimes; No more than anywhere else; Frequently; Always")
Test.create(test_question: "Absence of harassment", test_long_question: "I have already been subject, been witness or heard of sexual harassment related issues on my workplace", positive_negative_switch: "negative", select_options: "Never; Sometimes; No more than anywhere else; Frequently; Always")

80.times do
  user = User.new({
    email: Faker::Internet.email,
    password: "azazazazaz",
    password_confirmation: "azazazazaz",
    validated: true
  })
  user.save
  review = Review.new({
    firm_id: Random.rand(11) + 1,
    user_id: user.id,
    user_firm_relationship: "employee",
    confirmed_t_and_c: true,
    validated: true
  })
  review.save
  tests = Test.all
  tests.each do | test |
    Answer.create({
      user_rating: Random.rand(5) + 1,
      review_id: review.id,
      test_id: test.id
    })
  end
end

5.times do
  user = User.new({
    email: Faker::Internet.email,
    password: "azazazazaz",
    password_confirmation: "azazazazaz",
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
      test_id: test.id
    })
  end
end
