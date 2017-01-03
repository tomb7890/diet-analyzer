# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



seeddata = [8562,
  3822,
  1031,
  1133,
 11418,
  6460,
 16074,
 20092,
  9120,
  5092,
 16225,
 3900 ]


seeddata.each do |a|
  ndbno = a
  amt = rand(50) / 5
  seq = 1.to_i
  Food.create(ndbno: ndbno, measure: "", amount: amt )
end
