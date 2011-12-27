require 'spec_helper'

describe "resource_infos/new.html.haml" do
  before(:each) do
    assign(:resource_info, stub_model(ResourceInfo,
      :url => "MyString"
    ).as_new_record)
  end

  it "renders new resource_info form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => resource_infos_path, :method => "post" do
      assert_select "input#resource_info_url", :name => "resource_info[url]"
    end
  end
end
