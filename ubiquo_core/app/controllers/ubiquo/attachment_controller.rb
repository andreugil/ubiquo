class Ubiquo::AttachmentController < UbiquoController
  def show
    send_multimedia(params[:path], :x_sendfile => Ubiquo::Settings.get(:attachments)[:use_x_send_file])
  end

  protected

  def send_multimedia(requested_path, options = {})
    protected_path = Rails.root.join(Ubiquo::Settings.get(:attachments)[:private_path])
    absolute_path = File.expand_path(File.join(protected_path, requested_path))
    # TODO: Look for a better way to do this. Here we need to make sure that we only 
    # serve assets that belong to the protected_path to avoid security issues 
    # (using a regexp against the expanded path).
    unless absolute_path && File.exists?(absolute_path) && absolute_path =~ /^#{protected_path}/
      raise ActiveRecord::RecordNotFound 
    end
    
    filename = File.basename(absolute_path)
    case File.extname(filename).downcase
      when ".jpg", ".jpeg"
        content_type = "image/jpeg"
        disposition = "inline"
        send_data open(absolute_path, "rb").read, { :filename    => filename,
                                                    :type        => content_type,
                                                    :disposition => disposition }.merge(options)
        return
      when ".png"
        content_type = "image/png"
        disposition = "inline"
        send_data open(absolute_path, "rb").read, { :filename    => filename,
                                                    :type        => content_type,
                                                    :disposition => disposition }.merge(options)
        return
      when ".gif"
        content_type = "image/gif"
        disposition = "inline"
        send_data open(absolute_path, "rb").read, { :filename    => filename,
                                                    :type        => content_type,
                                                    :disposition => disposition }.merge(options)
        return
      when ".mp3"
        content_type = "audio/mpeg"
        disposition = "inline"
        send_data open(absolute_path, "rb").read, { :filename    => filename,
                                                    :type        => content_type,
                                                    :disposition => disposition }.merge(options)
        return
      when ".wmv"
        content_type = "video/x-ms-wmv"
        disposition = "attachment"
      when ".avi"
        content_type = "video/avi"
        disposition = "attachment"
      when ".mov"
        content_type = "video/quicktime"
        disposition = "attachment"
      when ".mp4"
        content_type = "video/mp4"
        disposition = "attachment"
      when ".mpg"
        content_type = "video/mpeg"
        disposition = "attachment"
      when ".flv"
        content_type = "video/x-flv"
        disposition = "attachment"
      when ".zip"
        content_type = "application/zip"
        disposition = "attachment"
      else
        content_type = "application/octet-stream"
        disposition = "attachment"
    end

    response.headers["Content-type"] = content_type
    response.headers['Content-length'] = File.size(absolute_path)
    response.headers['Cache-Control'] = 'must-revalidate'

    send_file absolute_path, { :filename    => filename,
                               :type        => content_type,
                               :disposition => disposition }.merge(options)
  end
end
