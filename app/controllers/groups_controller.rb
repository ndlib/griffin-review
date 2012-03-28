class GroupsController < ApplicationController

  def show
    @group = Group.find_by_group_name(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @group }
    end
  end

  def new
    @group = Group.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @group }
    end
  end

  def create
    @group = Group.new(params[:group])
    respond_to do |format|
      if @group.save
        flash[:notice] = ‘Group was successfully created.’
        format.html { redirect_to(@group) }
        format.xml { render :xml => @group,
        :status => :created,
        :location => @group }
      else
        format.html { render :action => “new” }
        format.xml { render :xml => @group.errors,
        :status => :unprocessable_entity }
      end
    end
  end

  def index
    Group.order('group_name')
    @groups = Group.all
    respond_to do |format|
      format.html
      format.xml { render :xml => @groups }
    end
  end

end
