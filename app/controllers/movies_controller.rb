class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    
  end
# If the user explicitly includes new sorting/filtering settings in params[],
# the session should not override them.
# On the contrary, the new settings should be remembered in the session.
  def index
    redirection unless params[:ratings] or params[:sort]
    @title
    @release_date
    if params[:sort]
      sort = params[:sort]
      session[:sort] = sort
    else
      if session[:sort]
        sort = session[:sort]
        params[:sort] = sort
      else
        sort = 'id'
      end
    end
    session[:picked_ratings] = params[:ratings] if params[:ratings]
    if params[:ratings]
      @picked_ratings = params[:ratings].keys
    else
      if session[:picked_ratings]
        @picked_ratings = session[:picked_ratings].keys
        params[:ratings] = session[:picked_ratings]
      else
        @picked_ratings = ratings
      end
    end
    @movies = Movie.where(rating: @picked_ratings).order(sort)
    @title = 'hilite' if session[:sort] == 'title'
    @release_date = 'hilite' if session[:sort] == 'release_date'
    @all_ratings = ratings
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  private
  def ratings
    Movie.uniq.pluck(:rating)
  end

  def redirection
    if session[:picked_ratings]
      if session[:sort]
        redirect_to movies_path(@index, ratings: session[:picked_ratings], sort: session[:sort])
      else
        redirect_to movies_path(@index, ratings: session[:picked_ratings])
      end
    else
      if session[:sort]
        redirect_to movies_path(@index, sort: session[:sort])
      else
        redirect_to movies_path
      end
    end
    flash.keep
  end

end
