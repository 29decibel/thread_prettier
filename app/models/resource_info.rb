require 'open-uri'

class ResourceInfo < ActiveRecord::Base
  validate :url,:presence
  has_many :thread_parts,:dependent => :destroy
  after_save :regenerate

  UrlPattern = "http://bbs.go2eu.com/viewthread.php?extra=page%3D1"
  Host = "http://bbs.go2eu.com/"

  def work
    self.thread_parts.clear
    self.fetch_infos
  end

  def fetch_infos
    doc = Nokogiri::HTML(open(url))
    page_num = doc.css('.pages a').count
    last_page = doc.css('.pages .last').first
    if last_page
      page_num = last_page.content.delete('.').to_i
    end
    author = doc.css('#postlist .postauthor .postinfo a').first.content
    self.update_attribute :author,author
    self.update_attribute :title,doc.title
    puts author
    t = tid
    (1..page_num).each do |p|
      u = "#{UrlPattern}&tid=#{t}&page=#{p}"
      get_contents(u,author)
    end
  end

  handle_asynchronously :work

  def regenerate
    if url_changed?
      self.work
    end
  end

  private

  def get_contents(url,author='')
    doc = Nokogiri::HTML(open(url))
    doc.css('#postlist > div').each do |ele|
      if ele.css('.postauthor .postinfo a').first.content==author
        ele.css('.postcontent .defaultpost .postmessage').each do |c|
          c = fix_image(c)
          c = trim_nodes(c)
          self.thread_parts.create :content=> c.content,:raw_content=>c.inner_html
        end
      end
    end
  end

  def fix_image(node)
    node.css('img').each do |img|
      # remove event
      if !img.attr('onload').blank?
        img.attributes['onload'].value = ''
      end
      # ok images
      next if (!img.attr('src').blank? and img.attr('src').start_with?('http'))
      # src is blank or
      # src is not start with http
      if !img.attr('file').blank?
        if img.attr('file').start_with?('http')
          img.attributes['src'].value = img.attr('file')
        else
          img.attributes['src'].value = "#{Host}#{img.attr('file')}"
        end
      else
        img.attributes['src'].value = "#{Host}#{img.attr('src')}"
      end
    end
    node
  end

  def trim_nodes(node)
    node.css('.newrate,script').remove
    node
  end

  def tid
    start_i = url.index 'tid'
    end_i = url.index '&'
    url[(start_i+4)..(end_i-1)]
  end

end
