class ReserveMigrator
  attr_accessor :errors, :converted_courses, :completed


  def import!
    pre_parsed_courses

    ['2013F'].each do | term |
      convert_courses_for_term!(term)
    end

    fix_courses_that_did_not_get_copied

    #process_courses!

    #BookReserveImporter.new.import!
  end


  private


    def fix_courses_that_did_not_get_copied
      current_user = User.where(username: 'jhartzle').first

      res = []
      @converted_courses.each_pair do | from_course_id, cc |
        cc.each do | to_course |
          count = Request.where(course_id: to_course).count
          if count == 0
            res << "#{from_course_id} -> #{to_course}: #{count}"
            CopyOldCourseReservesForm.new(current_user, { course_id: to_course, from_course_id: from_course_id, term: '201310', auto_complete: true }).copy!
          end
        end
      end

      res
    end


    def process_courses!
      return

      current_user = User.where(username: 'jhartzle').first

      @converted_courses.each_pair do | from_course_id, to_courses |
        to_course = to_courses.pop

        CopyOldCourseReservesForm.new(current_user, { course_id: to_course, from_course_id: from_course_id, term: '201310', auto_complete: true }).copy!

        add_course_completed(to_courses.pop)

        to_courses.each do | to_course |
          CopyOldCourseReservesForm.new(current_user, { course_id: to_course, from_course_id: from_course_id, term: '201310', auto_complete: true }).copy!

          add_course_completed(to_course)
        end
      end
    end


    def convert_courses_for_term!(term)
      i = 0

      OpenCourse.where(term: term).each do | from_course |
        course = "#{from_course.course_prefix}_#{from_course.course_number}"
        id = determine_current_course_id(term, course, from_course.instructor_lastname, from_course.instructor_firstname)
        puts "#{i += 1}: #{id}"

        if id
          add_match(from_course.id, id)
        end

        OpenCrosslist.where(term_parent: term).where(course_id_parent: from_course.course_id).each do | crosslist |
          course = "#{crosslist.course_prefix_child}_#{crosslist.course_number_child}"
          id = determine_current_course_id(term, course, crosslist.instructor_lastname_child, crosslist.instructor_firstname_child, true)
          puts "#{i += 1}: #{id}"

          if id
            add_match(from_course.id, id)
          end
        end
      end
    end


    def determine_current_course_id(term, course_number, instructor_lastname, instructor_firstname, crosslist = false)
      if missing_courses.has_key?(course_number)
        return false
      end

      search_term = (term == '2013F') ? '201310' : '201320'

      begin
        result = API::CourseSearchApi.course_by_triple("#{search_term}_#{course_number}")
      rescue
        add_error("#{course_number}: unable to find new course. #{instructor_firstname} #{instructor_lastname} #{crosslist ? ' - crosslist' : '' }")
        return false
      end

      result['section_groups'].each do | section_group |
        # section_group['primary_instructor']['first_name'] == from_course.instructor_firstname &&
        if section_group['primary_instructor']['last_name'].gsub(" ","").downcase == instructor_lastname.gsub(" ","").downcase
          return section_group['crosslist_id']
        end
      end

      add_error("#{course_number}: unable to match new course. #{instructor_firstname} #{instructor_lastname} #{crosslist ? ' - crosslist' : '' }")
      return false
    end


    def add_error(msg)
      @errors ||= []
      @errors << msg
    end


    def add_match(from_course, to_course)
      @converted_courses ||= { }
      @converted_courses[from_course] ||= []
      if !@converted_courses[from_course].include?(to_course)
        @converted_courses[from_course] << to_course
      end
    end


    def add_course_completed(id)
      @completed ||= []
      @completed << id
    end


    def missing_courses
      @missing_courses ||= {
        "AME_60623" => "201310_18931",
        "ANTH_34240" => "201310_G3",
        "BASC_20100" => "201310_KD",
        "BAEG_20100" => "201310_KD",
        "BAAL_20100" => "201310_KD",
        "ACMS_4890" => "201310_F3",
        "SOC_34440" => "201310_G3",
        "ARCH_51111" => "201310_14904",
        "ARCH_51411" => "201310_19819",
        "BIOS_10161" => "201310_10742",
        "BIOS_10191" => "201310_10645",
        "BIOS_20201" => "201310_11252",
        "CSC_33960"  => "201310_TC",
        "ESS_33606"  => "201310_14218",
        "FIN_20150"  => "201310_14678_14108_14679",
        "FTT_44702"  => "201310_13926",
        "HIST_30466" => "201310_DS",
        "HIST_43253" => "201310_18704",
        "MATH80770_01" => "201310_19811",
        "MTH_60510" => "201310_11829",
        "PHYS_10411" => "201310_11889",
        "PHYS_40441" => "201310_11556",
        "POLS_10200" => "201310_14357",
        "POLS_30266" => "201310_P8",
        "HESB_30561" => "201310_P8",
        "IDS_30505" => "201310_P8",
        "AFST_30693" => "201310_P8",
        "IIPS_30542" => "201310_P8",
        "POLS_43001" => "201310_13809",
        "ANTH_10141" => "201310_U2",
        "POLS_60662" => "201310_18851",
        "ENGL_13186" => "201310_14409",
        "SCPP_34315" => "201310_G3",
        "STV_34330" => "201310_G3",
        "FIN_60220" => false,
        "CONS_00000" => false,
        "PE_10000" => false,
        "ACCT_20100" => false
      }
    end


    def pre_parsed_courses
      @converted_courses ||= {
        "2013F_PE_10000_01" => [ '201310_12711', '201310_12706', '201310_12707', '201310_12708', '201310_12709', '201310_12710', '201310_12712', '201310_12713', '201310_12714', '201310_12715'],
        "2013F_ACCT_20100_04" => [ '201310_N3', '201310_JD', '201310_JE_JH_JJ_JK', '201310_JL_JM_JN', '201310_JO_JT_JU_JV', '201310_JX', '201310_JY_JZ_KB_KC', '201310_KD']
      }
    end
end
