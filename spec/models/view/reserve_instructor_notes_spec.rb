

describe ReserveInstructorNotes do

  context :video_reserve do
    before(:each) do
      @reserve = double(Reserve, id: 1, type: 'VideoReserve', note: "", language_track: "", subtitle_language: "", number_of_copies: "", requestor_owns_a_copy: false, length: "")
      @notes = ReserveInstructorNotes.new(@reserve)
    end

    it "calls the video version of the display if it is a video" do
      @notes.should_receive(:display_video)
      @notes.should_not_receive(:display_citation)

      @notes.display
    end


    it "includes the language track " do
      @reserve.stub(:language_track).and_return("lang")

      expect(@notes.display).to eq("<div class=\"display_instructor_text\"><p>Language Track: lang</p></div>")
    end


    it "does not print the language if it is not set" do
      expect(@notes.display).to eq("<div class=\"display_instructor_text\"></div>")
    end


    it "includes the subtitle language track " do
      @reserve.stub(:subtitle_language).and_return("lang")

      expect(@notes.display).to eq("<div class=\"display_instructor_text\"><p>Subtitle Language: lang</p></div>")
    end


    it "does not print the subtitle language if it is not set" do
      expect(@notes.display).to eq("<div class=\"display_instructor_text\"></div>")
    end


    it "adds the clips if they exist" do
      @reserve.stub(:length).and_return("CLIPS")

      expect(@notes.display).to eq("<div class=\"display_instructor_text\"><p>Clips: CLIPS</p></div>")
    end


    it "adds the special instructions to the display " do
      @reserve.stub(:note).and_return("note")

      expect(@notes.display).to eq("<div class=\"display_instructor_text\"><h5>Special Instructions</h5><p>note</p></div>")
    end


    it "returns them all together!!  " do
      @reserve.stub(:language_track).and_return("lang")
      @reserve.stub(:subtitle_language).and_return("lang")
      @reserve.stub(:note).and_return("note")

      expect(@notes.display).to eq("<div class=\"display_instructor_text\"><p>Language Track: lang</p><p>Subtitle Language: lang</p><h5>Special Instructions</h5><p>note</p></div>")
    end
  end

  context :non_video_reserve do
    before(:each) do
      @reserve = double(Reserve, id: 1, type: 'JournalReserve', note: "", citation: "", number_of_copies: "", requestor_owns_a_copy: false)
      @notes = ReserveInstructorNotes.new(@reserve)
    end

    it "calls the citation version for anything else" do
      @notes.should_not_receive(:display_video)
      @notes.should_receive(:display_citation)

      @notes.display
    end


    it "adds the citation to the into the display" do
      @reserve.stub(:citation).and_return("citation")

      expect(@notes.display).to eq("<div class=\"display_instructor_text\"><p><h5>Citation</h5>citation</p></div>")
    end


    it "adds the special instructions to the display " do
      @reserve.stub(:note).and_return("note")

      expect(@notes.display).to eq("<div class=\"display_instructor_text\"><p><h5>Citation</h5></p><h5>Special Instructions</h5><p>note</p></div>")
    end


    it "adds the number of copies needed if it is set" do
      @reserve.stub(:number_of_copies).and_return("4")

      expect(@notes.display).to eq("<div class=\"display_instructor_text\"><p><h5>Citation</h5></p><p>Number of Copies: 4</p></div>")
    end


    it "adds if the instructor owns a copy" do
      @reserve.stub(:requestor_owns_a_copy).and_return(true)
      @reserve.stub(:type).and_return('BookReserve')

      expect(@notes.display).to eq("<div class=\"display_instructor_text\"><p><h5>Citation</h5></p><p>Instructor Owns a Copy</p></div>")
    end


    it "adds if the instructor does not own a copy" do
      @reserve.stub(:requestor_owns_a_copy).and_return(false)
      @reserve.stub(:type).and_return('BookReserve')

      expect(@notes.display).to eq("<div class=\"display_instructor_text\"><p><h5>Citation</h5></p><p>Instructor did not Indicate they owned a copy.</p></div>")
    end


    it "returns them all toegether" do
      @reserve.stub(:citation).and_return("citation")
      @reserve.stub(:note).and_return("note")
      @reserve.stub(:number_of_copies).and_return("4")

      expect(@notes.display).to eq("<div class=\"display_instructor_text\"><p><h5>Citation</h5>citation</p><h5>Special Instructions</h5><p>note</p><p>Number of Copies: 4</p></div>")
    end

  end
end
