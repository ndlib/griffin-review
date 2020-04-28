class LoadsTitlesController < ApplicationController
  def load_titles
    if params.key?(:upload)
      @sample = params[:upload][:vidfile]
      VideoTitle.delete_all
      File.readlines(@sample.tempfile.path).each do |line|
        VideoTitle.create({:name => line})
      end
      flash[:success] = "Video title list updated."
    else
      flash[:notice] = "Upload file first and try again."
    end
    redirect_to '/masquerades/new'
  end
end