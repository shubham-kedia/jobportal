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
      @jobs = init_jobs(params[:q],params[:l],"","fulltime","10")
      @jobs_new = init_jobs(params[:q],params[:l],"date","fulltime","10")
    end
  end
  def browse
    if params[:q].present? || params[:l].present?
      @browse_jobs=init_jobs(params[:q],params[:l],"","fulltime","14")
    else
      @browse_jobs=init_jobs("us",params[:l],"","fulltime","14")
    end
  end
  private
  def init_jobs(query,loc,sort,jt,limit)
    query=URI.encode(query||="")
    loc=URI.encode(loc||="")
    @url="http://api.indeed.com/ads/apisearch?publisher=#{$pub_id}&q=#{query}&l=#{loc}&sort=#{sort}&radius=&st=&jt=#{jt}&start=&limit=#{limit}&fromage=&filter=&latlong=1&co=us&chnl=&userip=#{$ip}&useragent=#{$device}&v=2&format=json"
    # binding.pry
    begin
      JSON.parse(open(@url).read)["results"]
    rescue
      @j=[]
    end
  end
end
