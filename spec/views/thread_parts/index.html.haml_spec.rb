require 'spec_helper'

describe "thread_parts/index.html.haml" do
  before(:each) do
    assign(:thread_parts, [
      stub_model(ThreadPart,
        :content => "MyText",
        :resource_info_id => 1
      ),
      stub_model(ThreadPart,
        :content => "MyText",
        :resource_info_id => 1
      )
    ])
  end

  it "renders a list of thread_parts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
