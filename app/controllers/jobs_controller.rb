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
      @url="http://api.indeed.com/ads/apisearch?publisher=3083679641906722&q=#{@query}&l=#{@loc}&sort=&radius=&st=&jt=fulltime&start=&limit=5&fromage=&filter=&latlong=1&co=us&chnl=&userip=#{@ip}&useragent=#{@device}&v=2&format=json"
      @url_job_new="http://api.indeed.com/ads/apisearch?publisher=3083679641906722&q=#{@query}&l=#{@loc}&sort=date&radius=&st=&jt=fulltime&start=&limit=5&fromage=&filter=&latlong=1&co=us&chnl=&userip=#{@ip}&useragent=#{@device}&v=2&format=json"
      @results=open(@url).read
      @results_new=open(@url_job_new).read
      @jobs = JSON.parse(@results)
      @jobs = @jobs["results"]
      @jobs_new = JSON.parse(@results_new)
      @jobs_new = @jobs_new["results"]
    end
    # binding.pry
  end
end
