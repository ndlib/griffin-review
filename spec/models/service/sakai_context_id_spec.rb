require 'spec_helper'

describe SakaiContextId do

  it "parses a course triple for a supersection" do
    id = "SP15-HIST-32080-SS-02"
    expect(described_class.new(id).course_number).to eq("HIST 32080")
  end

  it "parsers a context id for a non super section" do
    id = "SP15-HIST-32080-02"
    expect(described_class.new(id).course_number).to eq("HIST 32080")
  end

  it "parses a term with for summer " do
    id = "SU15-HIST-32080-SS-02"
    expect(described_class.new(id).term).to eq('201500')
  end

  it "parsers a term for fall " do
    id = "FA15-HIST-32080-SS-02"
    expect(described_class.new(id).term).to eq('201510')
  end

  it "parsers a term for spring" do
    id = "SP15-HIST-32080-SS-02"
    expect(described_class.new(id).term).to eq('201420')
  end

end
