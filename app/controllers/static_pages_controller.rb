class StaticPagesController < ApplicationController
  # skip_before_action :authenticate_user!

  def home
  end

  def meet
    client = Instagram.client
    shawns_id = "1300104176"
    @shawns_feed = client.user_recent_media(shawns_id) # can pass count: n ; default returns 20
    # TODO refactor
  end

  def faq
  end
end