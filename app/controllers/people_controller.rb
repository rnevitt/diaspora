class PeopleController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html
  respond_to :json, :only => [:index, :show]
  
  def index
    @people = Person.search params[:q]
    respond_with @people
  end
  
  def show
    @person = current_user.visible_person_by_id(params[:id])
    @profile = @person.profile

    @groups_with_person = current_user.groups_with_person(@person)
    @groups_dropdown_array = current_user.groups.collect{|x| [x.to_s, x.id]} 

    @posts = Post.where(:person_id => @person.id, :_id.in => current_user.visible_post_ids).paginate :page => params[:page], :order => 'created_at DESC'

    @latest_status_message = current_user.raw_visible_posts.find_all_by__type_and_person_id("StatusMessage", params[:id]).last
    @post_count = @posts.count
  end
  
  def destroy
    current_user.unfriend(current_user.visible_person_by_id(params[:id]))
    respond_with :location => people_url
  end
  
end
