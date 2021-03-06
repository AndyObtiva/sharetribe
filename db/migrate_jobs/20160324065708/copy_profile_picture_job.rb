class CopyProfilePictureJob < Struct.new(:person_id)

  PAPERCLIP_OPTIONS =
    if (APP_CONFIG.s3_bucket_name && APP_CONFIG.aws_access_key_id && APP_CONFIG.aws_secret_access_key)
      {
        :path => "images/people/:attachment/:id/:style/:filename",
        :url => ":s3_path_url"
      }
    else
      {
        :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
        :url => "/system/:attachment/:id/:style/:filename"
      }
    end

  class Person < ActiveRecord::Base
    self.primary_key = "id"

    has_attached_file(:image,
                      {
                        :styles => {
                          :medium => "288x288#",
                          :small => "108x108#",
                          :thumb => "48x48#",
                          :original => "600x800>"
                        }
                      }.merge(PAPERCLIP_OPTIONS))

    validates_attachment_size :image, :less_than => 9.megabytes
    validates_attachment_content_type :image,
                                      :content_type => ["image/jpeg", "image/png", "image/gif",
                                        "image/pjpeg", "image/x-png"] #the two last types are sent by IE.
  end

  def perform
    cloned_user = Person.find(person_id)

    if cloned_user.image.blank?
      cloned_from_user = Person.find(cloned_user.cloned_from)

      cloned_user.image = cloned_from_user.image
      cloned_user.save!
    end
  end
end
