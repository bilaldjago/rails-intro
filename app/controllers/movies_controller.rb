class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    
  end

  def index
    @title
    @release_date
    sort = params[:sort] || 'id'
    @picked_ratings = []
    if params[:ratings]
      @picked_ratings = params[:ratings].keys
    else
      @picked_ratings = ratings
    end
    @movies = Movie.where(rating: @picked_ratings).order(sort)
    @title = 'hilite' if params[:sort] == 'title'
    @release_date = 'hilite' if params[:sort] == 'release_date'
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

  def ratings
    Movie.uniq.pluck(:rating)
  end

end
