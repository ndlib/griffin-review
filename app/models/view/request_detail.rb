class RequestDetail

  include RailsHelpers

  attr_accessor :reserve

  delegate :workflow_state, :title, :length, :created_at, :course, to: :reserve

  def initialize(controller)
    @controller = controller
    @reserve = reserve_search(@controller.params[:id])

    ReserveCheckInprogress.new(@reserve).check!
  end


  def delete_link
    helpers.link_to(helpers.raw("<i class=\"icon-remove\"></i> Delete Reserve"),
                    routes.course_reserve_path(@reserve.course.id, @reserve.id, redirect_to: 'admin'),
                    data: { confirm: 'Are you sure you wish to remove this reserve from this semester?' },
                    :method => :delete,
                    class: 'btn btn-danger',
                    :id => "delete_reserve_#{@reserve.id}")

  end


  def workflow_state_html
    if @reserve.workflow_state == 'available'
      css_class = 'text-success'
    elsif @reserve.workflow_state == 'removed'
      css_class = 'text-error'
    else
      css_class = 'text-warning'
    end

    "<span class=\"#{css_class}\">#{@reserve.workflow_state}</span>"
  end


  def instructor_notes
    ReserveInstructorNotes.new(@reserve).display
  end


  def instructor
    helpers.link_to(@reserve.course.primary_instructor, routes.new_masquerades_path(:username => @reserve.requestor_netid))
  end


  def requestor
    if @reserve.requestor_name == "imported"
      "Imported"
    else
      helpers.link_to(@reserve.requestor_name, routes.new_masquerades_path(:username => @reserve.requestor_netid)) + " - #{@reserve.requestor.email} "
    end
  end



  def number_of_views_for_current_request
    ReserveStat.all_request_stats(@reserve).count
  end


  def number_of_views_all_time
    ReserveStat.all_item_stats(@reserve).count
  end


  def overall_views
    result = ReserveStat.all_item_stats(@reserve)
    totals = Hash.new
    result.each do |row|
      if totals.has_key?(row['semester_id'])
        totals[row['semester_id']] = totals[row['semester_id']] + 1
      else
        totals[row['semester_id']] = 1
      end
    end

    # retrieve semester ids for codes and get a totals count
    total_views = 0
    semester_codes = Hash.new
    totals.each do |key,val|
      semester = Semester.find_by(id: totals[key])
      if semester.present?
        semester_codes[key] = semester['code']
        total_views += val
      else
        totals.delete(key)
      end
    end

    # swap semester ids for semester codes
    totals.keys.each { |k| totals[ semester_codes[k] ] = totals.delete(k) if semester_codes[k] }
    totals = totals.sort.to_h
    totals["Alltime"] = total_views

    totals
  end


  def semester_code
    @reserve.semester.code
  end


  def needed_by
    if @reserve.needed_by.nil?
      "Not Entered"
    else
      @reserve.needed_by.to_s(:long)
    end
  end


  def library
    if @reserve.library.nil?
      "Not Entered"
    else
      library_code = @reserve.library
      I18n.t "libraries.#{library_code}"
    end
  end


  def fair_use_comments
    helpers.simple_format(@reserve.fair_use.comments)
  end


  def physical_electronic_link
    PhysicalElectronicReserveForm.new(@reserve, {}).link_to_form
  end


  def required_material
    if @reserve.required_material
      "Yes"
    else
      "No"
    end
  end


  private

    def reserve_search(id)
      ReserveSearch.new.get(id)
    end



end
