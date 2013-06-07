class HeadlinesController < ApplicationController

  # GET /headlines
  # GET /headlines.json
  def index
    agencies = [:cnn, :reuters, :aljazeera, :bbc, :chinadaily]
    # agency = !params[:agency].nil? ? params.symbolize_keys[:agency].downcase.gsub(' ', '').to_sym : :cnn
    num_stories = !params[:limit].nil? ? params[:limit].to_i : 25
    @headlines = Headline.scrape(agencies, num_stories, Headline.scraper_options)
    @agencies = agencies

    respond_to do |format|
      format.js
      format.html
      format.json { render json: @headlines }
    end
  end

  # GET /headlines/1
  # GET /headlines/1.json
  def show
  end

  # GET /headlines/new
  def new
    @headline = Headline.new
  end

  # GET /headlines/1/edit
  def edit
  end

  # POST /headlines
  # POST /headlines.json
  def create
    @headline = Headline.new(headline_params)

    respond_to do |format|
      if @headline.save
        format.html { redirect_to @headline, notice: 'Headline was successfully created.' }
        format.json { render action: 'show', status: :created, location: @headline }
      else
        format.html { render action: 'new' }
        format.json { render json: @headline.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /headlines/1
  # PATCH/PUT /headlines/1.json
  def update
    respond_to do |format|
      if @headline.update(headline_params)
        format.html { redirect_to @headline, notice: 'Headline was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @headline.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /headlines/1
  # DELETE /headlines/1.json
  def destroy
    @headline.destroy
    respond_to do |format|
      format.html { redirect_to headlines_url }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def headline_params
      params[:headline]
    end
end
