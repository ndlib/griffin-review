require 'spec_helper'


describe API::PrintReserves do


  describe :all do
    it "returns an array with the results" do
      results = ''
      VCR.use_cassette 'print_reserves--all' do
        results = API::PrintReserves.all
      end

      expect(results.class).to eq(Array)
    end

    it "has a bib_id" do
      record = ''
      VCR.use_cassette 'print_reserves--first' do
        record = API::PrintReserves.all.first
      end

      expect(record.has_key?("bib_id")).to be_truthy
    end

    it "has a crosslist id" do
      record = ''
      VCR.use_cassette 'print_reserves--first' do
        record = API::PrintReserves.all.first
      end

      expect(record.has_key?("crosslist_id")).to be_truthy
    end


    it "has a doc_number" do
      record = ''
      VCR.use_cassette 'print_reserves--first' do
        record = API::PrintReserves.all.first
      end

      expect(record.has_key?("doc_number")).to be_truthy
    end
  end


  describe :find_by_bib_id_course_id do

    it "returns an array " do
      record = ''
      VCR.use_cassette 'print_reserves--find_by_bib_id' do
        record = API::PrintReserves.find_by_bib_id_course_id('001028236', '201310_PQ')
      end

      expect(record.class).to eq(Array)
    end

    it "finds a record " do
      record = ''
      VCR.use_cassette 'print_reserves--find_by_bib_id' do
        record = API::PrintReserves.find_by_bib_id_course_id('001028236', '201310_PQ')
      end

      expect(record.first['sid']).to eq("NDU01-001028236-IIPS-60219-01")
    end

    it "returns empty array if not found" do
      record = ''
      VCR.use_cassette 'print_reserves--find_by_bib_id-not-found' do
        record = API::PrintReserves.find_by_bib_id_course_id('notanid', '201310_PQ')
      end

      expect(record).to eq([])
    end
  end


  describe :find_by_rta_id do

    it "returns an array " do
      record = ''
      VCR.use_cassette 'print_reserves--find_by_rta_id' do
        record = API::PrintReserves.find_by_rta_id_course_id('000045021', '201310_PQ')
      end

      expect(record.class).to eq(Array)
    end

    it "finds a record " do
      record = ''
      VCR.use_cassette 'print_reserves--find_by_rta_id' do
        record = API::PrintReserves.find_by_rta_id_course_id('000045021', '201310_PQ')
      end

      expect(record.first['sid']).to eq("NDU01-001028236-IIPS-60219-01")
    end

    it "returns empty array if not found" do
      record = ''
      VCR.use_cassette 'print_reserves--find_by_rta_id-not-found' do
        record = API::PrintReserves.find_by_rta_id_course_id('notanid', '201310_PQ')
      end

      expect(record).to eq([])
    end
  end



  def all_results
    file = File.join(Rails.root, 'spec', 'fixtures', 'json_save', 'print_reserves', 'all.json')
    File.read(file)
  end

end
