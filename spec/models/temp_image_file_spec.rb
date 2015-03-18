require 'rails_helper'

describe TempImage do
  it "is a wrapper for a temporary image file" do
    expect(subject).to respond_to(:file)
  end  
end