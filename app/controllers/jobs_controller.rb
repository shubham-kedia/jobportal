class JobsController < ApplicationController
  require 'open-uri'
  require 'json'
  def index

  end

  def search
    @device= URI.encode(request.user_agent)
    @ip=request.remote_ip
    @query=params[:q]||=""
    @loc=URI.encode(params[:l]||="")
    @jobs=[]
    if @query.present? || @loc.present?
      @url="http://api.indeed.com/ads/apisearch?publisher=3083679641906722&q=#{@query}&l=#{@loc}&sort=&radius=&st=&jt=&start=&limit=&fromage=&filter=&latlong=1&co=us&chnl=&userip=#{@ip}&useragent=#{@device}&v=2&format=json"
      @results=open(@url).read
      @jobs = JSON.parse(@results)
      @jobs = @jobs["results"]
    end
    # binding.pry
  end
end
