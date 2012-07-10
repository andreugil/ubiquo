class AssetPrivate < Asset
  file_attachment :resource,
                  :visibility => "protected",
                  :styles     => self.correct_styles(Ubiquo::Settings.context(:ubiquo_media).get(:media_styles_list)),
                  :processors => Ubiquo::Settings.context(:ubiquo_media).get(:media_processors_list)
  validates_attachment_presence :resource

  after_resource_post_process :generate_geometries
end
