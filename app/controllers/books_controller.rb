class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]

  # GET /books or /books.json
  def index
    @books = Book.all
  end

  # GET /books/1 or /books/1.json
  def show
    @comment = @book.comments.build
  end
  
  # GET /books/new
  def new
    @book = current_user.books.build
  end

  # GET /books/1/edit
  def edit
  end

  
  # POST /books or /books.json
  def create
    @book = current_user.books.build(book_params)
    # @book = @user.books.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to user_book_url(current_user,@book), notice: "Book was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to user_book_url(@book), notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def like
  @book = current_user.books.find(params[:id])
  @book.likes.create(user: current_user)
  redirect_to @book
  end

  def unlike
    @book = current_user.books.find(params[:id])
    @like = @book.likes.find_by(user: current_user)
    @like.destroy if @like
    redirect_to @book
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = current_user.books.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :description, :written_at, :user_id, :page)
    end
end
