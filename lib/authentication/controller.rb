module Authentication
  module Controller
    def self.included(base)
      base.helper_method :current_user, :logged_in?
    end

    def current_user
      @__current_user ||= get_current_user
    end

    def logged_in?
      current_user.present?
    end

    def log_in(user)
      session[:user_id] = user.id
      flash[:notice] = t 'sessions.logged_in'
    end

    def log_out
      session.delete(:user_id)
      flash[:notice] = t 'sessions.logged_out'
    end

    def require_user!
      not_authenticated! unless logged_in?
    end

    def not_authenticated!
      session[:return_to_path] = request.path if request.get?
      redirect_to login_path, :alert => t('sessions.not_authenticated')
      return
    end

    private

    def after_login_path
      session.delete(:return_to_path) || root_path
    end

    def get_current_user
      return unless session[:user_id]
      User.where(:id => session[:user_id]).first.tap do |user|
        session.delete(:user_id) unless user
      end
    end
  end
end
