class ReserveMigrator
  attr_accessor :errors, :successes


  def import!
   ['2013F', '2014S'].each do | term |
      import_for_term!(term)
   end
  end


  private


    def import_for_term!(term)
      i = 0

      missing_courses.each do | id |
        add_success(id)
      end

      OpenCourse.where(term: term).each do | from_course |

        id = determine_current_course_id(term, "#{from_course.course_prefix}_#{from_course.course_number}", from_course.instructor_lastname, from_course.instructor_firstname)
        puts "#{i += 1}: #{id}"
        if id
          add_success(id)
        end

        # check the cross lists.
        puts "check cross lists--->"
        OpenCrosslist.where(term_parent: term).where(course_id_parent: from_course.course_id).each do | crosslist |
          id = determine_current_course_id(term, "#{crosslist.course_prefix_child}_#{crosslist.course_number_child}", crosslist.instructor_lastname_child, crosslist.instructor_firstname_child, true)
          puts "#{i += 1}: #{id}"

          if id && !@successes.include?(id)
            puts "---->NEW NEW NEW NEW<-------"
            add_success(id)
          end
        end
        puts "---> done"
      end
    end


    def determine_current_course_id(term, course_number, instructor_lastname, instructor_firstname, crosslist = false)
      if missing_courses[course_number]
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


    def add_success(course)
      @successes ||= []
      @successes << course
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

      }
    end
end
