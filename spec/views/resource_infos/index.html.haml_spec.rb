require 'spec_helper'

describe "resource_infos/index.html.haml" do
  before(:each) do
    assign(:resource_infos, [
      stub_model(ResourceInfo,
        :url => "Url"
      ),
      stub_model(ResourceInfo,
        :url => "Url"
      )
    ])
  end

  it "renders a list of resource_infos" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Url".to_s, :count => 2
  end
end
