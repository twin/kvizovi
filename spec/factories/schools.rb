FactoryGirl.define do
  factory :school do
    name     "MIOC"
    level    "Srednja"
    username "mioc"
    password "mioc"
    email    "mioc@skola.hr"
    key      "mioc"
    place    "Zagreb"
    region   "Grad Zagreb"

    factory :other_school do
      username "other"
      email "other@skola.hr"
    end
  end

  factory :user, parent: :school
end
