require 'spec_helper'


describe ReserveStat do

  before(:each) do
    @semester = double(Semester, id: 1)
    @user = double(User, id: 2)
    @request = double(Request, id: 3)
    @item = double(Item, id: 4)

    @reserve = double(Reserve, semester: @semester, user: @user, request: @request, item: @item)
  end


  it "can add new stat records " do
    obj = ReserveStat.add_statistic!(@user, @reserve, true)
    expect(obj.valid?).to be_truthy
    expect(obj.new_record?).to be_falsey
  end

  it "has as created at field" do
    obj = ReserveStat.add_statistic!(@user, @reserve, true)
    expect(obj.created_at.class).to eq(ActiveSupport::TimeWithZone)
    expect(obj.created_at.nil?).to be(false)
  end


  it "has a field for if it is a part of sakai or not" do
    obj = ReserveStat.add_statistic!(@user, @reserve, true)
    expect(obj.from_lms?).to be(true)
  end



  describe :query do
    before(:each) do
      @request2 = double(Request, id: 5)
      @reserve2  = double(Reserve, semester: @semester, user: @user, request: @request2, item: @item)

      @saved1 = ReserveStat.add_statistic!(@user, @reserve, true)
      @saved2 = ReserveStat.add_statistic!(@user, @reserve2, true)
    end


    it "can return results by request" do
      expect(ReserveStat.all_request_stats(@reserve)).to eq( [ @saved1 ])
      expect(ReserveStat.all_request_stats(@reserve2)).to eq( [ @saved2 ])
    end


    it "can return results by item" do
      expect(ReserveStat.all_item_stats(@reserve)).to eq( [ @saved1, @saved2 ])
    end

  end
end
