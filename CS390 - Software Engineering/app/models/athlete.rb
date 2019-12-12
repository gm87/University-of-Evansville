class Athlete < ApplicationRecord

  has_many :taggings
  has_many :teams, through: :taggings
  
  validates :name, presence: true
  validates :email, presence: true,
                    uniqueness: {allow_blank: true, message: "Email already registered!" }
  
  def self.fmorning_email
    @athlete = Athlete.all
    @athlete.each do |u|
      ActivityMailer.fmorning_required(u.email).deliver
    end
  end
  def self.factivity_email
    @athlete = Athlete.all
    @athlete.each do |u|
      ActivityMailer.factivity_required(u.email).deliver
    end
  end

end


