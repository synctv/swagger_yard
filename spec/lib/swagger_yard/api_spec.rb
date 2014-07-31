require 'spec_helper'

describe SwaggerYard::Api do
  context "with a parsed yard object" do
    let(:yard_object) {stub(docstring: 'A Description')}
    let(:api_declaration) {SwaggerYard::ApiDeclaration.new(nil)}

    let(:api) {SwaggerYard::Api.from_yard_object(yard_object, api_declaration)}

    context "from yard object" do
      let(:tags) { [stub(tag_name: "path", types: ["GET"], text: "/accounts/ownerships.{format_type}")] }

      before(:each) do
        yard_object.stubs(:tags).returns(tags)
      end

      it 'to have a path' do
        expect(api.path).to eq("/accounts/ownerships.{format_type}")
      end
    end
  end
end
