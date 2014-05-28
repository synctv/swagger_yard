require 'spec_helper'

describe SwaggerYard, '.generate' do
  let(:app_path) {'../../fixtures/dummy/app/'}

  context "for a valid controller" do
    let(:model_path) {File.expand_path(app_path+'models/pet.rb', __FILE__)}
    let(:controller_path) {File.expand_path(app_path+'controllers/pets_controller.rb', __FILE__)}

    before(:each) do
      # generates a listing but we only really care
      #   that it sets the controller and model path config
      SwaggerYard.generate!(controller_path, model_path)
    end

    let(:api_json) {File.read(File.expand_path('../../fixtures/api.json', __FILE__))}

    it 'generates swagger api json for the given controllers and models' do
      expect(SwaggerYard.get_listing).to eq(JSON.parse(api_json))
    end

    let(:pets_json) {File.read(File.expand_path('../../fixtures/pets.json', __FILE__))}

    it 'generates swagger json for an individual controller' do
      expect(SwaggerYard.get_api('/pets')).to eq(JSON.parse(pets_json))
    end
  end



  context "for non-controllers (modules) in the path" do
    let(:controllers_path) {File.expand_path('../../fixtures/dummy/app/controllers/**/*.rb', __FILE__)}

    it 'does not error' do
      expect { SwaggerYard.generate!(controllers_path) }.to_not raise_error
    end
  end
end
