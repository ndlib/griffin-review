class Admin::ItemController < AdminController
  respond_to :json, :html

  def index
    @items = Item.order('name').all
    respond_to do |format|
      format.html
      format.json { render :json => @items }
    end
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
