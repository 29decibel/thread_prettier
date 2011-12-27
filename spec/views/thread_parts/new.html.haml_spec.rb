require 'spec_helper'

describe "thread_parts/new.html.haml" do
  before(:each) do
    assign(:thread_part, stub_model(ThreadPart,
      :content => "MyText",
      :resource_info_id => 1
    ).as_new_record)
  end

  it "renders new thread_part form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => thread_parts_path, :method => "post" do
      assert_select "textarea#thread_part_content", :name => "thread_part[content]"
      assert_select "input#thread_part_resource_info_id", :name => "thread_part[resource_info_id]"
    end
  end
end
