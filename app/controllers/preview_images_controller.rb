# frozen_string_literal: true

class PreviewImagesController < ApplicationController
    include ApplicationHelper::GraphMethods
  
    skip_before_action :banned?
    skip_before_action :find_active_announcements
    skip_before_action :set_has_new_reports
  
    def user
      expires_in 7.days, public: true
  
      user = User.where("LOWER(screen_name) = ?", params[:username].to_s.downcase)
                 .includes(:profile)
                 .first
  
      fallback = "#{root_url}images/large/no_avatar.png"
  
      # Always redirect for non-existent users (don’t return a 404)
      unless user
        return redirect_to fallback
      end
  
      target = full_profile_picture_url(user)
  
      return if fresh_when(etag: target)
  
      redirect_to target, allow_other_host: true
    end
  
  end
  