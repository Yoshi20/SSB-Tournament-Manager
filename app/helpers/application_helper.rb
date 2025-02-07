module ApplicationHelper

  def flash_class(level)
    case level.to_sym
      when :notice then "alert-info"
      when :success then "alert-success"
      when :error then "alert-danger"
      when :alert then "alert-warning"
    end
  end

  def unaccent(text)
    charactersProcessed = "" # To avoid doing a replace multiple times
    newText = text.downcase
    text = newText # Case statement is expecting lowercase
    text.each_char do |c|
      next if  charactersProcessed.include? c
      replacement = ""
      case c
        when '1'
          replacement = "¹"
        when '2'
          replacement = "²"
        when '3'
          replacement = "³"
        when 'a'
          replacement = "á|à|â|ã|ä|å|ā|ă|ą|À|Á|Â|Ã|Ä|Å|Ā|Ă|Ą|Æ"
        when 'c'
          replacement = "ć|č|ç|©|Ć|Č|Ç"
        when 'e'
          replacement = "è|é|ê|ё|ë|ē|ĕ|ė|ę|ě|È|Ê|Ë|Ё|Ē|Ĕ|Ė|Ę|Ě|€"
        when 'g'
          replacement = "ğ|Ğ"
        when 'i'
          replacement = "ı|ì|í|î|ï|ì|ĩ|ī|ĭ|Ì|Í|Î|Ï|Ї|Ì|Ĩ|Ī|Ĭ"
        when 'l'
          replacement = "ł|Ł"
        when 'n'
          replacement = "ł|Ł"
        when 'n'
          replacement = "ń|ň|ñ|Ń|Ň|Ñ"
        when 'o'
          replacement = "ò|ó|ô|õ|ö|ō|ŏ|ő|ø|Ò|Ó|Ô|Õ|Ö|Ō|Ŏ|Ő|Ø|Œ"
        when 'r'
          replacement = "ř|®|Ř"
        when 's'
          replacement = "š|ş|ș|ß|Š|Ş|Ș"
        when 'u'
          replacement = "ù|ú|û|ü|ũ|ū|ŭ|ů|Ù|Ú|Û|Ü|Ũ|Ū|Ŭ|Ů"
        when 'y'
          replacement = "ý|ÿ|Ý|Ÿ"
        when 'z'
          replacement = "ž|ż|ź|Ž|Ż|Ź"
      end
      if !replacement.empty?
        charactersProcessed = charactersProcessed + c
        newText = newText.gsub(c, "(" + c + "|" + replacement + ")")
      end
    end
    return newText
  end

  def default_meta_tags
    if session['country_code'] == 'ch'
      {
        reverse: true,
        separator: '|',
        description: 'Swiss Super Smash Bros. Ultimate Community Hub',
        keywords: 'super smash bros, nintendo, esports, ultimate',
        canonical: request.original_url,
        noindex: !Rails.env.production?,
        icon: [
          { href: image_url('ch_favicon.ico') },
          { href: image_url('ch_icon.jpg'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
        ],
        og: {
          site_name: 'swisssmash.ch',
          title: 'SwissSmash',
          description: 'Swiss Super Smash Bros. Ultimate Community Hub',
          type: 'website',
          url: request.original_url,
          image: image_url('ch_logo.png')
        }
      }
    elsif session['country_code'] == 'de'
      {
        reverse: true,
        separator: '|',
        description: 'German Super Smash Bros. Ultimate Community Hub',
        keywords: 'super smash bros, nintendo, esports, ultimate',
        canonical: request.original_url,
        noindex: !Rails.env.production?,
        icon: [
          { href: image_url('de_logo.png') },
          { href: image_url('de_logo.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
        ],
        og: {
          site_name: 'germanysmash.de',
          title: 'GermanySmash',
          description: 'German Super Smash Bros. Ultimate Community Hub',
          type: 'website',
          url: request.original_url,
          image: image_url('de_logo.png')
        }
      }
    elsif session['country_code'] == 'fr'
      {
        reverse: true,
        separator: '|',
        description: 'France Super Smash Bros. Ultimate Community Hub',
        keywords: 'super smash bros, nintendo, esports, ultimate',
        canonical: request.original_url,
        noindex: !Rails.env.production?,
        icon: [
          { href: image_url('fr_logo.jpg') },
          { href: image_url('fr_logo.jpg'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
        ],
        og: {
          site_name: 'SmashUltimate.fr',
          title: 'SmashUltimate.fr',
          description: 'France Super Smash Bros. Ultimate Community Hub',
          type: 'website',
          url: request.original_url,
          image: image_url('fr_logo.jpg')
        }
      }
    elsif session['country_code'] == 'lu'
      {
        reverse: true,
        separator: '|',
        description: 'Luxembourg Super Smash Bros. Ultimate Community Hub',
        keywords: 'super smash bros, nintendo, esports, ultimate',
        canonical: request.original_url,
        noindex: !Rails.env.production?,
        icon: [
          { href: image_url('lu_logo.png') },
          { href: image_url('lu_logo.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
        ],
        og: {
          site_name: 'luxsmash.lu',
          title: 'LuxSmash',
          description: 'Luxembourg Super Smash Bros. Ultimate Community Hub',
          type: 'website',
          url: request.original_url,
          image: image_url('lu_logo.png')
        }
      }
    elsif session['country_code'] == 'it'
      {
        reverse: true,
        separator: '|',
        description: 'Italy Super Smash Bros. Ultimate Community Hub',
        keywords: 'super smash bros, nintendo, esports, ultimate',
        canonical: request.original_url,
        noindex: !Rails.env.production?,
        icon: [
          { href: image_url('it_logo.jpg') },
          { href: image_url('it_logo.jpg'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/svg' },
        ],
        og: {
          site_name: 'italysmash.it',
          title: 'ItalySmash',
          description: 'Italy Super Smash Bros. Ultimate Community Hub',
          type: 'website',
          url: request.original_url,
          image: image_url('it_logo.jpg')
        }
      }
    elsif session['country_code'] == 'uk'
      {
        reverse: true,
        separator: '|',
        description: 'UK & Ireland Super Smash Bros. Ultimate Community Hub',
        keywords: 'super smash bros, nintendo, esports, ultimate',
        canonical: request.original_url,
        noindex: !Rails.env.production?,
        icon: [
          { href: image_url('uk_logo.jpg') },
          { href: image_url('uk_logo.jpg'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
        ],
        og: {
          site_name: 'SmashUltimate.uk',
          title: 'SmashUltimate.uk',
          description: 'UK & Ireland Super Smash Bros. Ultimate Community Hub',
          type: 'website',
          url: request.original_url,
          image: image_url('uk_logo.jpg')
        }
      }
    elsif session['country_code'] == 'pt'
      {
        reverse: true,
        separator: '|',
        description: 'PT Super Smash Bros. Ultimate Community Hub',
        keywords: 'super smash bros, nintendo, esports, ultimate',
        canonical: request.original_url,
        noindex: !Rails.env.production?,
        icon: [
          { href: image_url('pt_logo.jpg') },
          { href: image_url('pt_logo.jpg'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
        ],
        og: {
          site_name: 'SmashBrosPortugal.com',
          title: 'SmashBrosPortugal',
          description: 'PT Super Smash Bros. Ultimate Community Hub',
          type: 'website',
          url: request.original_url,
          image: image_url('pt_logo.jpg')
        }
      }
    elsif session['country_code'] == 'is'
      {
        reverse: true,
        separator: '|',
        description: 'Iceland Super Smash Bros. Ultimate Community Hub',
        keywords: 'super smash bros, nintendo, esports, ultimate',
        canonical: request.original_url,
        noindex: !Rails.env.production?,
        icon: [
          { href: image_url('is_logo.png') },
          { href: image_url('is_logo.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/svg' },
        ],
        og: {
          site_name: 'smashiceland.com',
          title: 'SmashIceland',
          description: 'Iceland Super Smash Bros. Ultimate Community Hub',
          type: 'website',
          url: request.original_url,
          image: image_url('is_logo.png')
        }
      }
    elsif session['country_code'] == 'us_ca'
      {
        reverse: true,
        separator: '|',
        description: 'USA California Super Smash Bros. Ultimate Community Hub',
        keywords: 'super smash bros, nintendo, esports, ultimate',
        canonical: request.original_url,
        noindex: !Rails.env.production?,
        icon: [
          { href: image_url('us_ca_logo.png') },
          { href: image_url('us_ca_logo.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/svg' },
        ],
        og: {
          site_name: 'ca-smash.com',
          title: 'CaliSmash',
          description: 'USA California Super Smash Bros. Ultimate Community Hub',
          type: 'website',
          url: request.original_url,
          image: image_url('us_ca_logo.png')
        }
      }
    end
  end

  def meta_tag_description(str)
    if session['country_code'] == 'ch'
      "Swiss Smash #{str}"
    elsif session['country_code'] == 'de'
      "Germany Smash #{str}"
    elsif session['country_code'] == 'fr'
      "SmashUltimate.fr #{str}"
    elsif session['country_code'] == 'lu'
      "Lux Smash #{str}"
    elsif session['country_code'] == 'it'
      "Italy Smash #{str}"
    elsif session['country_code'] == 'uk'
      "SmashUltimate.uk #{str}"
    elsif session['country_code'] == 'pt'
      "Smash Bros Portugal #{str}"
    elsif session['country_code'] == 'is'
      "SmashIceland #{str}"
    elsif session['country_code'] == 'us_ca'
      "CaliSmash #{str}"
    end
  end

end
