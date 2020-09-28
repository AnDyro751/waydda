class PhoneCode
  include Mongoid::Document
  include Mongoid::Timestamps
  field :verification_code, type: String
  field :exp_date, type: String
  field :status, type: String, default: "unused"

  belongs_to :user



  def self.generate_random_number
    6.times.map { rand(10) }.join("")
  end

end
