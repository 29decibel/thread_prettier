#coding: utf-8
require 'open-uri'

class ResourceInfo < ActiveRecord::Base
  validates :url,:presence=>true,:uniqueness=>true

  has_many :thread_parts,:dependent => :destroy
  has_many :photo_previews,:dependent => :destroy
  has_many :user_rates
  has_many :favorates
  has_many :users,:through=>:favorates

  scope :by_score,order('score desc')
  belongs_to :user

  after_save :regenerate
  SUPPORT_HOST = %w(bbs.go2eu.com bbs.16fan.com www.daododo.com)

  def update_score
    self.update_attribute :score,(self.user_rates.average(:rate) || 0)
  end

  def score
    self[:score] || 0
  end

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
    author_avatar_img = doc.at_css('#postlist .postauthor .avatar img')

    self.update_attribute :author,author
    self.update_attribute :title,doc.title
    self.update_attribute(:author_avatar,author_avatar_img.attr('src')) if author_avatar_img

    puts author
    t = tid
    (1..page_num).each do |p|
      u = "http://#{host}/viewthread.php?tid=#{t}&page=#{p}"
      get_contents(u,author)
    end
  end
  
  def host
    self.uri.host
  end

  def uri
    @uri ||= URI(self.url)
  end

  def support_url?
    if self.uri and SUPPORT_HOST.include?(self.uri.host) and !self.tid.blank?
      return true
    else
      self.update_attribute :title,'url not support'
      return false
    end
  end

  handle_asynchronously :work

  def regenerate(force=false)
    if url_changed? or force
      self.thread_parts.clear
      self.photo_previews.clear
      self.work
    end
  end

  def tid
    if uri.path.end_with?('.html') and uri.path.include?('thread')
      uri.path.split('-')[1]
      # http://bbs.16fan.com/thread-41770-1-1.html
    else
      query = uri.query
      tid_query = query.split('&').select{|a|a.include?('tid=')}.first
      tid_query.blank? ? '' : tid_query[4..-1]
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
        ele.css('.postcontent').each do |pc|
          # get content info
          c = pc.at_css(".defaultpost .postmessage")
          next if !c
          c = fix_image(c)
          c = trim_nodes(c)
          c = trim_attrs(c)
          # get post date
          date_info = pc.at_css('.posterinfo .authorinfo em').try(:content)
          post_date = date_info.blank? ? '' : date_info[4..-1]
          self.thread_parts.create :content=> c.content,:raw_content=>c.inner_html,:uid=>uid,:post_date=>post_date
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
          img.attributes['src'].value = "http://#{host}/#{img.attr('file')}"
        end
      else
        img.attributes['src'].value = "http://#{host}/#{img.attr('src')}"
      end
      # add image thumb info
      if !img.attr('src').blank? and (img.attr('src').end_with?('.jpg') or img.attr('src').end_with?('.png')) and (self.photo_previews.count < 10)
        pp = self.photo_previews.create
        # pp.remote_photo_url = img.attributes['src'].value
        pp.process_image(img.attr('src'))
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
