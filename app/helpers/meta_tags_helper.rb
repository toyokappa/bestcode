module MetaTagsHelper
  def default_meta_tags(title = nil)
    {
      site: title.present? ? "#{title} | #{t('app.title')}" : t("app.title"),
      reverse: true,
      charset: "utf-8",
      description: t("app.description"),
      keyword: t("app.keyword"),
      og: {
        site_name: t("app.title"),
        title: title.present? ? "#{title} | #{t('app.title')}" : t("app.title"),
        description: t("app.description"),
        type: "website",
        url: request.original_url,
        image: image_url("/images/meta_image.png"),
        locale: "ja_JP",
      },
      twitter: {
        card: "summary large image",
        title: title.present? ? "#{title} | #{t('app.title')}" : t("app.title"),
        description: t("app.description"),
        site: "@toyokappa",
      },
    }
  end
end
