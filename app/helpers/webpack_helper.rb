module WebpackHelper
  def webpack_assets_path(path)
    return "http://localhost:3333/#{path}" if Rails.env.development?

    host = Rails.application.config.action_controller.asset_host
    manifest = Rails.application.config.assets.webpack_manifest
    path = manifest[path] if manifest && manifest[path].present?
    "#{host}/assets/#{path}"
  end

  def webpack_css_tag(filename)
    if !Rails.env.development?
      stylesheet_link_tag webpack_assets_path("#{filename}.css", request)
    end
  end
end
