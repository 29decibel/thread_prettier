
class PhotoPreview < ActiveRecord::Base
  mount_uploader :photo, PhotoPreviewUploader

  def process_image(url)
    result = (self.remote_photo_url = url)
    self.update_attribute :photo,result
  end

  handle_asynchronously :process_image
end
