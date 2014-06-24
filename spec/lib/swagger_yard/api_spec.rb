require 'spec_helper'

describe SwaggerYard::Api do
  context "with a parsed yard object" do
    let(:yard_object) {stub(docstring: 'A Description')}
    let(:resource_listing) {SwaggerYard::ResourceListing.new(nil, nil)}

    let(:api) {SwaggerYard::Api.new(resource_listing, yard_object)}

    context "with a path" do
      let(:tags) { [stub(tag_name: "path", text: "[GET] /accounts/ownerships.{format_type}")] }

      before(:each) do
        yard_object.stubs(:tags).returns(tags)
      end

      it 'is valid?' do
        expect(api.valid?).to be_true
      end
    end
  end
end
