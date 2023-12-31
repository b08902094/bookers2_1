class BooksController < ApplicationController
  protect_from_forgery

  before_action :authenticate_user!, except: [:top, :about]

  def new
    @book = Book.new
  end

  def create
    @user = current_user
    @books = Book.all
    @book = Book.new(post_image_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "Your book has been created successfully"
      redirect_to book_path(@book.id)
    else
      flash.now[:notice] = "error: failed to create"
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user.id != current_user.id
        redirect_to books_path
    end
  end

  def update
    @user = current_user
    @books = Book.all
    @book = Book.find(params[:id])
    if @book.update(post_image_params)
      flash[:notice] = "Your book has been updated successfully"
      redirect_to book_path(@book.id)
    else
      flash.now[:notice] = "error: failed to update"
      render :edit
    end
  end

  def index
    @books = Book.all
    @book = Book.new
    @user = User.find(current_user.id)
  end

  def show
    @book = Book.find(params[:id])
    @user = User.find(current_user.id)
    @book_new = Book.new
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to '/books'
  end

  private

  def post_image_params
    params.require(:book).permit(:title, :body, :image)
  end
end
