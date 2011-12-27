require 'spec_helper'

describe "thread_parts/show.html.haml" do
  before(:each) do
    @thread_part = assign(:thread_part, stub_model(ThreadPart,
      :content => "MyText",
      :resource_info_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
