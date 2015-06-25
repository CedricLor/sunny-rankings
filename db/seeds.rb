# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Award.create(name: "Diversity Charter in Sweden")
Award.create(name: "Charta der Vielfalt, Österreich")
Award.create(name: "Charte de la Diversité en Entreprise, France")
Award.create(name: "Label Egalité Diversité, Belgium")
Award.create(name: "Charter de la Diversidad, España")
Award.create(name: "Carta per le pari opportunità e l'uguaglianza sul lavoro, Italia")
Award.create(name: "Economics Dividend for Gender Equality, U.S.A")

Firm.create(name: "MyMicroInvest", url: "https://www.mymicroinvest.com/", country: "Belgium", headcount: "48", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-mymicroinvest.svg")
Firm.create(name: "Rabobank", url: "http://www.rabobank.be/‎", country: "Belgium", headcount: "56870", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-rabobank.png")
Firm.create(name: "ING Bank", url: "https://www.ing.be/", country: "Belgium", headcount: "84718", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-ing.svg")
Firm.create(name: "ABN AMRO", url: "https://www.abnamro.com/", country: "Belgium", headcount: "24225", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-abnamro.svg")
Firm.create(name: "KBC", url: "https://www.kbc.com/", country: "Belgium", headcount: "36187", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-kbc.png")
Firm.create(name: "BK CP", url: "https://www.bkcpbanque.be/", country: "Belgium", headcount: "380", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-bkcp.png")
Firm.create(name: "BNP Paribas Fortis", url: "https://www.bnpparibasfortis.be/", country: "Belgium", headcount: "200000", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-bnp-paribas.svg")
Firm.create(name: "bpost", url: "https://www.bpost.be/", country: "Belgium", headcount: "25683", business_description: "Lorem ipsum", industry: "financial services", icon_name: "logo-bpost.svg")

6.times do
  award = GrantedAward.new({
    award_id: Random.rand(7) + 1,
    firm_id: Random.rand(8) + 1
  })
  award.save
end

Test.create(test_question: "Absence of sexists comments")
Test.create(test_question: "Equal pay")
Test.create(test_question: "Equal promotion opportunities")
Test.create(test_question: "Absence of pregnancy related issues")
Test.create(test_question: "Absence of harrasment")

50.times do
  user = User.new({
    email: Faker::Internet.email,
    password: 'azazazazaz',
    password_confirmation: 'azazazazaz'
  })
  user.save
  review = Review.new({
    firm_id: Random.rand(8) + 1,
    user_id: user.id,
    user_firm_relationship: "employee",
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
    password: 'azazazazaz',
    password_confirmation: 'azazazazaz'
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
