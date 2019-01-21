# 
# A big image:
# {% flickr_image 6829790399 b %}
# 
# A medium-sized image:
# {% flickr_image 7614906062 m %}
# 
# The same image, as a small square thumbnail: 
# {% flickr_image 7614906062 sq %}
# 
# Examples:
# {% flickr_image 8409934727 m .left %}
# {% flickr_image 8409934727 m nolink .left %}
# 
# Output:
# <a href='http://www.flickr.com/photos/user/8409934727/' title='Title' class='left'>
#   <img src='http://farm9.static.flickr.com/server/8409934727_da53112a53_m.jpg' alt='Title'/>
# </a>
# 
# <img src='http://farm9.static.flickr.com/server/8409934727_da53112a53_m.jpg' title='Title' class='left'/>
# 
require 'flickraw'
class FlickrImage < Liquid::Tag

  def initialize(tag_name, markup, tokens)
     super
     @markup = markup
     @id   = markup.split(' ')[0]
     @size = markup.split(' ')[1]
     @withlink = markup.include? 'nolink'
     @class = /\.\w+/.match(markup).to_s
  end

  def render(context)

    FlickRaw.api_key        = ENV["FLICKR_KEY"]
    FlickRaw.shared_secret  = ENV["FLICKR_SECRET"]

    info = flickr.photos.getInfo(:photo_id => @id)

    server        = info['server']
    farm          = info['farm']
    id            = info['id']
    secret        = info['secret']
    title         = info['title']
    description   = info['description']
    size          = "_#{@size}" if @size
    src           = "http://farm#{farm}.static.flickr.com/#{server}/#{id}_#{secret}#{size}.jpg"
    page_url      = info['urls'][0]["_content"]

    className     = ""
    if @class != nil
      @class = @class.gsub(/\./, '')
      className   = "class='#{@class}'"
    end
    
    if @withlink
      img_tag     = "<img src='#{src}' title='#{title}' #{className}/>"
    else
      img_tag     = "<img src='#{src}' alt='#{title}'/>"
      link_tag    = "<a href='#{page_url}' title='#{title}' #{className}>#{img_tag}</a>"
    end
  end
end

Liquid::Template.register_tag('flickr_image', FlickrImage)