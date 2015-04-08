class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    #@posts = Post.all
    if params[:c] 
      @posts = Post.joins(:comments).where("comments.body LIKE '%#{params[:c]}%'").select("distinct posts.* ")
    elsif params[:category] and params[:category] != ""
      @posts = Post.where(:category=>params[:category])
    else
      q = params[:q] ? "body LIKE '%#{params[:q]}%'" : ""
      @posts = Post.where(q).order(:created_at).reverse  
    end
  end

  def list
    @posts = Post.where(:state=>'1').order(:created_at).reverse
    @count_words = Hash.new(0)
    @posts.map {|p| p.body}.join(" ").split(" ").each{ |word| @count_words[word]+=1}    
  end
  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  def view
    @post = Post.find(params[:id])
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.state = '1'
    @post.user_id = 1
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post fue creado excitosamente.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def publish
    @post = Post.find(params[:id])
    @post.state = params[:state]
    @post.save!
    redirect_to posts_path, notice: 'Post fue actualizado en el Blog.'
  end

   def report

    @order = params[:order] ? params[:order] : 'id'
    @posts = Post.all
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post fue actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post fue eliminado corectamente.' }
      format.json { head :no_content }
    end
  end

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :category, :user_id)
    end
end
