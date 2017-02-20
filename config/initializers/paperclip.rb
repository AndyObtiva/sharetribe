module Paperclip
  class Attachment

    def url_with_remote_file(*args, &block)
       original_filename.to_s.start_with?('http') ? original_filename : url_without_remote_file(*args, &block)
    end
    alias_method_chain :url, :remote_file

    #TODO refactor above with implementing url_generator Paperclip::UrlGenerator
  end
end
