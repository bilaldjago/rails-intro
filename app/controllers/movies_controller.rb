class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @title
    @release_date
    sort = params[:sort] || 'id'
    @picked_ratings = []
    #if params[:ratings]
    #  @picked_ratings = params[:ratings].keys
    #else
    #  @picked_ratings = ratings
    #end
    if params[:ratings]
      @picked_ratings = params[:ratings].keys
      @movies = Movie.where(rating: @picked_ratings).order(sort)
    else
      @movies = Movie.order(sort)
    end
    @picked_hash = params[:ratings]
    #if params[:ratings]
    #  @movies = Movie.where :rating => params[:ratings].keys
    #else
    #  @movies = Movie.all
    #end
    #if params[:sort] 
    #  @movies = @movies.order(params[:sort])
    @title = 'hilite' if params[:sort] == 'title'
    @release_date = 'hilite' if params[:sort] == 'release_date'
    #else
      #@movies = Movie.all
      #@movies = Movie.where :rating => params[:ratings].keys
    #end
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
    #array = []
    #var = Movie.all
    #var.each { |movie|
    #  array.push(movie.rating) if !array.include?(movie.rating)
    #}
    #array
    Movie.uniq.pluck(:rating)
  end

end
