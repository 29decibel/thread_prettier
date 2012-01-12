#coding: utf-8
require 'open-uri'
class ReadableArticle < ActiveRecord::Base

  def noko_doc(url)
    data = open(url).read
    doc = Nokogiri::HTML(data)
    doc.encoding = 'utf-8'
    doc
  end

  def fetch_content!
    return if self.url.blank?
    doc = noko_doc(self.url)
    self.title = doc.title

    results = ''
    doc.css('#postlist > div').each do |ele|
      ele.css('.postcontent').each do |pc|
        # get content info
        c = pc.at_css(".defaultpost .postmessage")
        next if !c
        c = fix_image(c)
        c = trim_nodes(c)
        c = trim_attrs(c)
        results << "<div class='pp_post'>#{c.inner_html}</div>"
      end
    end
    mafeng = doc.at_css('.artice_area')
    if mafeng
      results << mafeng.inner_html
    end
    self.content = results
    self.save
  end

  def host
    self.uri.host
  end

  def uri
    @uri ||= URI(self.url)
  end

  private

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
          img.attributes['src'].value = "http://#{host}/#{img.attr('file')}"
        end
      else
        img.attributes['src'].value = "http://#{host}/#{img.attr('src')}"
      end
    end
    node
  end

  def trim_nodes(node)
    node.css('.newrate,script').remove
    node
  end

  def trim_attrs(node)
    node.css('font').each do |f|
      f.attributes.each{|k,v| f.attributes[k].value=''}
    end
    node
  end
end
