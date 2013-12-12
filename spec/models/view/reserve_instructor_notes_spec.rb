

describe ReserveInstructorNotes do

  context :video_reserve do
    before(:each) do
      @reserve = double(Reserve, id: 1, type: 'VideoReserve', note: "", language_track: "", subtitle_language: "")
      @notes = ReserveInstructorNotes.new(@reserve)
    end

    it "calls the video version of the display if it is a video" do
      @notes.should_receive(:display_video)
      @notes.should_not_receive(:display_citation)

      @notes.display
    end


    it "includes the language track " do
      @reserve.stub(:language_track).and_return("lang")

      expect(@notes.display).to eq("<p>Language Track: lang</p>")
    end


    it "does not print the language if it is not set" do
      expect(@notes.display).to eq("")
    end


    it "includes the subtitle language track " do
      @reserve.stub(:subtitle_language).and_return("lang")

      expect(@notes.display).to eq("<p>Subtitle Language: lang</p>")
    end


    it "does not print the subtitle language if it is not set" do
      expect(@notes.display).to eq("")
    end


    it "adds the special instructions to the display " do
      @reserve.stub(:note).and_return("note")

      expect(@notes.display).to eq("<h5>Special Instructions</h5><p>note</p>")
    end


    it "returns them all together!!  " do
      @reserve.stub(:language_track).and_return("lang")
      @reserve.stub(:subtitle_language).and_return("lang")
      @reserve.stub(:note).and_return("note")

      expect(@notes.display).to eq("<p>Language Track: lang</p><p>Subtitle Language: lang</p><h5>Special Instructions</h5><p>note</p>")
    end
  end

  context :non_video_reserve do
    before(:each) do
      @reserve = double(Reserve, id: 1, type: 'BookChapterReserve', note: "", citation: "")
      @notes = ReserveInstructorNotes.new(@reserve)
    end

    it "calls the citation version for anything else" do
      @notes.should_not_receive(:display_video)
      @notes.should_receive(:display_citation)

      @notes.display
    end


    it "adds the citation to the into the display" do
      @reserve.stub(:citation).and_return("citation")

      expect(@notes.display).to eq("<p><h5>Citation</h5>citation</p>")
    end


    it "adds the special instructions to the display " do
      @reserve.stub(:note).and_return("note")

      expect(@notes.display).to eq("<p><h5>Citation</h5></p><h5>Special Instructions</h5><p>note</p>")
    end


    it "returns them all toegether" do
      @reserve.stub(:citation).and_return("citation")
      @reserve.stub(:note).and_return("note")

      expect(@notes.display).to eq("<p><h5>Citation</h5>citation</p><h5>Special Instructions</h5><p>note</p>")
    end
  end
end
