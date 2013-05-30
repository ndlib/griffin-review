

describe ReserveListing do


  it "has a title" do
    ReserveListing.new(Reserve.new).respond_to?(:title)
  end

  it "has an id" do
    ReserveListing.new(Reserve.new).respond_to?(:id)
  end


  it "has a file" do
    ReserveListing.new(Reserve.new).respond_to?(:file)
  end


  it "has a course" do
    ReserveListing.new(Reserve.new).respond_to?(:course)
  end


  it "has a creator_contributor" do
    ReserveListing.new(Reserve.new).respond_to?(:creator_contributor)
  end


  it "has details" do
    ReserveListing.new(Reserve.new).respond_to?(:details)
  end


  it "has publisher_provider" do
    ReserveListing.new(Reserve.new).respond_to?(:publisher_provider)
  end


  it "determins if the resource should be linked to " do
    ReserveListing.new(Reserve.new).respond_to?(:link_to_get_listing?)
  end

  describe :css_class do
    it "determins what the listing css class should be" do
      ReserveListing.new(Reserve.new).respond_to?(:css_class)
    end

    it "sets the book class to ...."

    it "sets the book chapter class to ...."

    it "sets the video class to ...."

    it "sets the audio class to ...."

    it "sets the journal class to ...."
  end

end
