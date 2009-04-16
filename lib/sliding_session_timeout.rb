module SlidingSessionTimeout
  
  def self.included(controller)
    controller.extend(ClassMethods)
  end
  
  module ClassMethods
    
    def sliding_session_timeout(seconds, expiry_function = nil)
      @sliding_session_timeout = seconds
      @sliding_session_expiry_function = expiry_function
      
      prepend_before_filter do |c|
        if c.session[:sliding_session_expires_at] && c.session[:sliding_session_expires_at] < Time.now
          unless @sliding_session_expiry_function.blank?
            c.send @sliding_session_expiry_function
          else
            c.send :reset_session
          end
        else
          c.session[:sliding_session_expires_at] = Time.now + @sliding_session_timeout
        end
      end # before_filter
      
    end # sliding_session_timeout
  
  end # ClassMethods

end