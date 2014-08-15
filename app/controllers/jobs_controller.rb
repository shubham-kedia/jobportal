class JobsController < ApplicationController
  require 'open-uri'
  require 'json'
  $pub_id="3083679641906722"
  def index

  end

  def search
    $device= URI.encode(request.user_agent)
    $ip=request.remote_ip
    @jobs=[]
    @jobs_new=[]
    if params[:q].present? || params[:l].present?
      @jobs = init_jobs(params[:q],params[:l],"","fulltime",10,"")
      @jobs.delete(@jobs.last)
      @jobs_new = init_jobs(params[:q],params[:l],"date","fulltime",10,"")
      @jobs_new.delete(@jobs_new.last)
    end
  end
  def browse
    @limit=20
    @pagen=params[:page].present? ? params[:page].to_i : 1
    @start=@limit*@pagen
    @counter=(@pagen/10).to_i
    if params[:q].present? || params[:l].present?
      @browse_jobs=init_jobs(params[:q],params[:l],"","fulltime",@limit,@start)
    else
      @browse_jobs=init_jobs("us",params[:l],"","fulltime",@limit,@start)
    end
    @browse_jobs_count=@browse_jobs.last
    @topages=(@browse_jobs_count["totalResults"]/@limit).to_i
    @browse_jobs.delete(@browse_jobs.last)
  end
  private
  def init_jobs(query,loc,sort,jt,limit,start)
    query=URI.encode(query||="")
    loc=URI.encode(loc||="")
    @url="http://api.indeed.com/ads/apisearch?publisher=#{$pub_id}&q=#{query}&l=#{loc}&sort=#{sort}&radius=&st=&jt=#{jt}&start=#{start}&limit=#{limit}&fromage=&filter=&latlong=1&co=us&chnl=&userip=#{$ip}&useragent=#{$device}&v=2&format=json"
    begin
      @feeds=JSON.parse(open(@url).read)
      @j_res=@feeds["results"]
      @j_res.push("totalResults"=> @feeds["totalResults"])
      # binding.pry
    rescue
      []
    end
  end
end
