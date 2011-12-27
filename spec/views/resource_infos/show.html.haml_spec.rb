require 'spec_helper'

describe "resource_infos/show.html.haml" do
  before(:each) do
    @resource_info = assign(:resource_info, stub_model(ResourceInfo,
      :url => "Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Url/)
  end
end
