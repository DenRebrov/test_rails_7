# frozen_string_literal: true

module PhotosHelper
  PLUG = 'plug.jpg'.freeze
  
  def hlpr_photo_url(photo)
    if photo.url.attached?
      photo.url
    else
      asset_path(PLUG)
    end
  end
end
