#Delete this eventually, just to keep UI populated

module MixinDummyDataDecorator
  extend ::ActiveSupport::Concern

  shorter_dummy_titles = [
    "Malkovich malkovich: Yes, Malkovich.",
    "Malkovich? No, no more Malkovich."
  ]

  longer_dummy_blurbs = [
    "The Bridgettine or Birgittine Order (formally the Order of the Most Holy Savior (lat.: Ordo sanctissimi Salvatoris), abbreviated as O.Ss.S.) is a monastic religious order of Augustinian nuns, Religious Sisters and monks founded by Saint Birgitta (Saint Bridget) of Sweden in 1344,[1] and approved by Pope Urban V in 1370.[2] There are today several different branches of Bridgettines.",
    "The Order of Saint Benedict (OSB; Latin: Ordo Sancti Benedicti), also known – in reference to the colour of its members' habits – as the Black Monks, is a Roman Catholic religious order of independent monastic communities that observe the Rule of Saint Benedict. Each community (monastery, priory or abbey)",
    "The Cluniac Reforms (also called the Benedictine Reform)[1] were a series of changes within medieval monasticism of the Western Church focused on restoring the traditional monastic life, encouraging art, and caring for the poor."
  ]

  arr_dummy_data = [
    ["Saturday"],
    ["Sunday"]
  ]

  %w( name title ).each do |m_name|
    define_method m_name do
      shorter_dummy_titles[rand(2)]
    end
  end

  %w( teaching_style core_competencies qualification_description description goals customer_gains display_tech_stack customer_requirements misc_note week_one week_two week_three week_four week_five week_six ).each do |m_name|
    define_method m_name  do
      longer_dummy_blurbs[rand(3)]
    end
  end

  %w( days_of_week ).each do |m_name|
    define_method m_name do
      arr_dummy_data[rand(2)]
    end
  end

  def meeting_time_range(thing)
    "12:00 PM - 3:00 PM"
  end

  def rolling
    true
  end

  def rolling?
    true
  end

  def start_date
    "August 15, 2015"
  end

  def amount_cents
    1200
  end

  def location
    "Workshop Cafe, 10 Montgommery St., SF"
  end

end
