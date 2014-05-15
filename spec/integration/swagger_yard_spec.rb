require 'spec_helper'

describe SwaggerYard, '.generate' do

  context "for a valid controller" do
    let(:controller_path) {File.expand_path('../../fixtures/dummy/app/controllers/pets_controller.rb', __FILE__)}
    let(:pets_json) {File.read(File.expand_path('../../fixtures/pets.json', __FILE__))}

    let(:swagger_json) {JSON.dump(SwaggerYard.generate!(controller_path))}

    it 'generates swagger api json for the given controller' do
      expect(swagger_json).to eq(pets_json)
    end
  end

  context "for non-controllers (modules) in the path" do
    let(:controllers_path) {File.expand_path('../../fixtures/dummy/app/controllers/**/*.rb', __FILE__)}

    it 'does not error' do
      expect { SwaggerYard.generate!(controllers_path) }.to_not raise_error
    end
  end
end
