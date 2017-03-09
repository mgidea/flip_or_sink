class State < ApplicationRecord
  CODE_TYPE = "ST"

  DECODER = {"id" => "code"}

  def self.import_states(states)
    states.map do |state_hash|
      updated_hash = state_hash.except("type").map{|key, value| [DECODER[key] || key, value]}.to_h
      state = State.find_by_name(updated_hash["name"])
      next if state
      State.create(updated_hash)
    end
  end

  def import_counties(counties)
    County.import_state_counties(self, counties)
  end

  has_many :counties, :inverse_of => :state, :dependent => :destroy
  has_many :cities, :inverse_of => :state, :dependent => :destroy
  has_many :points_of_interest, :inverse_of => :state, :dependent => :destroy
  has_many :properties, :inverse_of => :state, :dependent => :destroy
end
