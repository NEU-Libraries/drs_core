require 'spec_helper'
require "#{Rails.root}/spec/models/concerns/properties_datastream_delegations_spec"
require "#{Rails.root}/spec/models/concerns/paranoid_rights_validation_spec"

describe CoreFile do 
  describe "Content Objects" do 
    before :all do 
      @core    = CoreFile.new 
      @core.apply_depositor_metadata "Will" 
      @core.save! 

      @wigwum  = Wigwum.new 
      @wigwum.core_file = @core 
      @wigwum.save!

      @wumpus  = Wumpus.new
      @wumpus.core_file = @core 
      @wumpus.canonize
      @wumpus.save! 

      @wigwum2 = Wigwum.create 
    end

    it "can be found in various ways" do 
      expected = [@wigwum, @wumpus] 

      expect(@core.content_objects).to match_array expected 
      expect(@core.canonical_object).to eq @wumpus
    end

    it "are destroyed on core record destruction" do 
      wigwum_pid = @wigwum.pid 
      wumpus_pid = @wumpus.pid

      @core.destroy 

      expect(Wumpus.exists?(wumpus_pid)).to be false 
      expect(Wigwum.exists?(wigwum_pid)).to be false 
    end

    after :all do 
      @wigwum2.destroy
    end
  end

  it_behaves_like "A Properties Delegator"
  it_behaves_like "a paranoid rights validator"
end