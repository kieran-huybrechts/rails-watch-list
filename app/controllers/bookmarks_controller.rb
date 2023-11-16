class BookmarksController < ApplicationController

  def new
    @list = List.find(params[:list_id])
    # bookmark is linked to list but other than that empty
    @bookmark = Bookmark.new(list: @list)
    @movies = Movie.all
  end

  def create
    @list = List.find(params['list_id'])
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.list_id = @list.id
    @bookmark.movie_id = params['bookmark']['movie_id']
    if @bookmark.save
      redirect_to list_path(@list), notice: 'Movie added to the list.'
    else
      @movies = Movie.all
      render :new
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    redirect_to list_path(@bookmark.list), status: :see_other
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:movie_id, :comment)
  end
end
