require 'spec_helper'

describe "thread_parts/edit.html.haml" do
  before(:each) do
    @thread_part = assign(:thread_part, stub_model(ThreadPart,
      :content => "MyText",
      :resource_info_id => 1
    ))
  end

  it "renders the edit thread_part form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => thread_parts_path(@thread_part), :method => "post" do
      assert_select "textarea#thread_part_content", :name => "thread_part[content]"
      assert_select "input#thread_part_resource_info_id", :name => "thread_part[resource_info_id]"
    end
  end
end
