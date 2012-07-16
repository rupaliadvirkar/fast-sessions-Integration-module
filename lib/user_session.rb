module UserSession
  #This method creates the session for logged in user and accepts two arguments
  #1.Data - This is the session data needs to store in the db
  #2.User object
  def self.create(data,user)
    ses = ActiveRecord::SessionStore::FastSessions.new(:session_id => UserSession.session_id(user), :data => data)
    ses.save
    ses
  end
  
  #This method gives the valid session of the logged in user.
  #This method accepts User objet.
  def user_session(user)
    if !@user_session
      ses = ActiveRecord::SessionStore::FastSessions.find_by_session_id(UserSession.session_id(user))
      if !ses.data.empty?
        @user_session = ses
      else
        @user_session = nil
      end
    end  
    @user_session
  end
  
  #This method creates required session_id. This depends upon the individual need.
  #For me its combination of user.id and user.vcgblorganization_id
  #This method accepts user object.
  def self.session_id(user)
    user.id.to_s + '-' + user.vcgblorganization_id.to_s
  end
  
  #This is just to make user_session available in the views if needed.
  def self.included(base)
    base.send :helper_method, :user_session
  end
  
  #This method updates the session data of particular user if needed.and accepts two arguments
  #1.Data - This is the session data needs to store in the db
  #2.User object
  def self.update(user,hdata)
    ses = ActiveRecord::SessionStore::FastSessions.find_by_session_id(UserSession.session_id(user))
    new_data = ses.data.merge(hdata)
    Usersession.create(new_data,user) 
  end
  
  #This is to delete the session of an user when he logs out.
  #This method accepts User object.
  def self.expire(user)
     ses = ActiveRecord::SessionStore::FastSessions.find_by_session_id(UserSession.session_id(user))
     ses.destroy
  end
end