#coding: utf-8
require 'open-uri'

class ResourceInfo < ActiveRecord::Base
  validate :url,:presence,:uniqueness=>true
  has_many :thread_parts,:dependent => :destroy
  belongs_to :user
  after_save :regenerate

  UrlPattern = "http://bbs.go2eu.com/viewthread.php?extra=page%3D1"
  Host = "http://bbs.go2eu.com/"

  def work
    self.update_attribute :state,'生成中'
    self.fetch_infos
    self.update_attribute :state,'完毕'
  end

  def fetch_infos
    return if !support_url?
    doc = noko_doc(url)
    page_num = doc.css('.pages a').count
    last_page = doc.css('.pages .last').first
    if last_page
      page_num = last_page.content.delete('.').to_i
    end
    page_num = page_num==0 ? 1 : page_num
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

  def support_url?
    if !self.url.start_with?('http://bbs.go2eu.com/') or !self.url.include?('tid=')
      self.update_attribute :title,'url not support'
      return false
    end
    true
  end

  handle_asynchronously :work

  def regenerate(force=false)
    if url_changed? or force
      self.thread_parts.clear
      self.work
    end
  end

  private

  def get_contents(url,author='')
    doc = noko_doc(url)
    doc.css('#postlist > div').each do |ele|
      uid = ele.attr('id')
      if !uid.blank?
        tp = ThreadPart.find_by_uid(uid)
        next if tp
      end
      if ele.css('.postauthor .postinfo a').first.content==author
        ele.css('.postcontent .defaultpost .postmessage').each do |c|
          c = fix_image(c)
          c = trim_nodes(c)
          c = trim_attrs(c)
          self.thread_parts.create :content=> c.content,:raw_content=>c.inner_html,:uid=>uid
        end
      end
    end
  end

  def noko_doc(url)
    data = open(url).read
    Nokogiri::HTML(data)
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

  def trim_attrs(node)
    node.css('font').each do |f|
      f.attributes.each{|k,v| f.attributes[k].value=''}
    end
    node
  end

  def tid
    start_i = url.index 'tid'
    end_i = url.index '&'
    url[(start_i+4)..(end_i-1)]
  end

end
