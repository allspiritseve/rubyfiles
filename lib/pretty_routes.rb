module PrettyRoutes
  # Allows you to specify short routes that link to longer routes and know how
  # to pull out dependencies, e.g. pulling a category from a post when you have
  # a url structure like /:category/:post.
  #
  # Sample route override:
  #
  # def post_url(post, options = {})
  #   post_category_url(post.category, post, options)
  # end
  #
  # Enable by including this module in ApplicationController and ApplicationHelper.
  #
  # If you want your custom routes available in mailers:
  #
  # class PostMailer < ActionMailer::Base
  #   helper PrettyRoutes
  # end
  #
  def self.included(base)
    public_instance_methods.map do |url_route|
      path_route = url_route.to_s.sub(/url$/, 'path')
      if !method_defined?(path_route)
        define_method path_route do |record, options = {}|
          send url_route, record, options.merge(:only_path => true)
        end
      end
      if base.respond_to? :helper_method
        base.helper_method url_route, path_route
      end
    end
  end
end
