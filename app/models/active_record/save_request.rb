class SaveRequest < ActiveRecord::Base
  attr_accessor :errors

  belongs_to :user

  def self.update_all
    errors = []
    SaveRequest.where(:semester_id => 3).each do | req |
        req.copy_to_new_reserves
        errors += req.errors if req.errors
    end

    errors
  end


  def copy_to_new_reserves
    begin
        course_id = find_course(self.course)
        if !course_id
            add_error "Course id: #{self.course}"
        end

        req = Request.new(self.attributes)
        req.build_item
        req.course = nil
        req.id = nil

        r = Reserve.factory(req)

        r.item
        r.overwrite_nd_meta_data = true
        r.title = self.title
        r.type  = 'VideoReserve'

        r.workflow_state = 'new'

        r.language_track = req.language
        r.subtitle_language = req.subtitles

        r.requestor_netid = self.user.username

        r.course = CourseSearch.new.get(course_id)

        r.save!

        fu = r.fair_use
        fu.user_id = approving_user.id
        fu.comments = "Auto approved from the tranistion between reserve systems."
        fu.approve
        fu.save!

        self.destroy
    rescue Exception => e
        add_error "Error id: #{self.id}"
    end
  end


  def approving_user
    return @user if @user

    @user = User.where(username: 'prader').first || User.new(username: 'prader')
    if @user.new_record?
      @user.send(:fetch_attributes_from_ldap)
      @user.save!
    end

    @user
  end


  def add_error(err)
    @errors ||= []
    @errors << err
  end


  def course_lookup
    {
        "FA13 CSEM 23101 11" => '201310_12144',
        "FA13 ROFR 27500 SS01" => "201310_12519",
        "FA13 ROFR 20201 SS02" => "201310_10085_10086",
        "FA13 HIST 30145 01" => "201310_18663",
        "FA13 PS 43000 01" => "201310_18518",
        "FA13 ENGL 20701 CX" => "201310_19093",
        "FA13 ENGL 40817 CX" => "201310_16624",
        "FA13 GE 30104 01" => "201310_15614",
        "FA13 ANTH 20203 01" => "201310_18488_18487",
        "FA13 CSC 33975 01" => "201310_12788",
        "FA13 WR 13300 02" => "201310_15536",
        "FA13 ENGL 20544 01" => "201310_18583",
        "FA13 PS 33400 01" => "201310_19178",
        "FA13 WR 13100 02" => "201310_15382_17201",
        "FA13 ESS 33600 01" => "201310_10191",
        "FA13 AFST 13181 02" => "201310_19924",
        "FA13 PS 34571 01" => "201310_19843",
        "FA13 ROSP 63768 01" => "201310_19966",
        "FA13 AMST 30116 01" => "201310_18466_19115",
        "FA13 CSEM 23101 06" => "201310_12132",
        "FA13 AFST 33075 01" => "201310_19108",
        "FA13 ROFR 47500 01" => "201310_16366",
        "FA13 LLEA 33317 01" => "201310_19164"
    }
  end


  def find_course(id)
    course_lookup[id.upcase]
  end
end
