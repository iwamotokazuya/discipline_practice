module ApplicationHelper
  def default_meta_tags
    {
      site: 'しつけメーター',
      title: 'Discipline-meter',
      reverse: true,
      charset: 'utf-8',
      description: 'ペットが可愛くて仕方なく、あまり怒れない人に怒る基準を明確にして, しつけの練習をするサービスです。',
      keywords: 'ペット,しつけ',
      canonical: request.original_url,
      separator: '|',
      icon: [
        { href: image_url('dog-icon.jpg') },
        { href: image_url('dog-icon.jpg'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
      ],
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('dog-icon.jpg'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary',
      }
    }
  end
end
