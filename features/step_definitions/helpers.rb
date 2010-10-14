def get_project(identifier)
  Project.find(:first, :conditions => "identifier='#{identifier}'")
end

def initialize_sprint_params
  @sprint = HashWithIndifferentAccess.new(Sprint.new.attributes)
  @sprint['project_id'] = @project.id
  @sprint
end

def initialize_story_params
  @story = HashWithIndifferentAccess.new(Story.new.attributes)
  @story['project_id'] = @project.id
  @story['tracker_id'] = Story.trackers.first
  @story['author_id']  = @user.id
  @story
end

def initialize_task_params(story_id)
  params = HashWithIndifferentAccess.new(Task.new.attributes)
  params['project_id'] = @project.id
  params['tracker_id'] = Task.tracker
  params['author_id']  = @user.id
  params['parent_issue_id'] = story_id
  params['status_id'] = IssueStatus.find(:first).id
  params
end

def initialize_impediment_params(sprint_id)
  params = HashWithIndifferentAccess.new(Task.new.attributes)
  params['project_id'] = @project.id
  params['tracker_id'] = Task.tracker
  params['author_id']  = @user.id
  params['sprint_id'] = sprint_id
  params['status_id'] = IssueStatus.find(:first).id
  params
end

def login_as_product_owner
  visit url_for(:controller => 'account', :action=>'login')
  fill_in 'username', :with => 'jsmith'
  fill_in 'password', :with => 'jsmith'
  click_button 'Login »'
  @user = User.find(:first, :conditions => "login='jsmith'")
end

def login_as_scrum_master
  visit url_for(:controller => 'account', :action=>'login')
  fill_in 'username', :with => 'jsmith'
  fill_in 'password', :with => 'jsmith'
  click_button 'Login »'
  @user = User.find(:first, :conditions => "login='jsmith'")
end

def login_as_team_member
  visit url_for(:controller => 'account', :action=>'login')
  fill_in 'username', :with => 'jsmith'
  fill_in 'password', :with => 'jsmith'
  click_button 'Login »'
  @user = User.find(:first, :conditions => "login='jsmith'")
end

def login_as_admin
  visit url_for(:controller => 'account', :action=>'login')
  fill_in 'username', :with => 'admin'
  fill_in 'password', :with => 'admin'
  click_button 'Login »'
  @user = User.find(:first, :conditions => "login='admin'")
end  

def task_position(task)
  p1 = task.story.tasks.select{|t| t.id == task.id}[0].rank
  p2 = task.rank
  p1.should == p2
  return p1
end

def story_position(story)
  stories = Story.backlog(story.project, story.sprint_id)
  p1 = stories.select{|s| s.id == story.id}[0].rank
  p2 = story.rank
  puts "\n\nRanks: #{stories.collect{|c| c.rank}.inspect}, bulk=#{p1}, indiv=#{p2}\n\n"
  p1.should == p2
  
  by_rank = Story.at_rank(story.project_id, story.sprint_id, p1)

  puts "\n\nBy rank: #{by_rank.id} vs. #{story.id}\n\n"
  by_rank.id.should == story.id

  return p1
end

def logout
  visit url_for(:controller => 'account', :action=>'logout')
  @user = nil
end
