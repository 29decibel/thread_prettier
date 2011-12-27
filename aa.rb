require 'open-uri'
require 'nokogiri'
UrlPattern = "http://bbs.go2eu.com/viewthread.php?extra=page%3D1"

def fetch_infos(url)
  doc = Nokogiri::HTML(open(url))
  puts doc.title
  trim_nodes(doc)
  page_num = doc.css('.pages .last').first.content.delete('.').to_i
  author = doc.css('#postlist .postauthor .postinfo a').first.content
  puts author
  (1..1).each do |p|
    u = "#{UrlPattern}&tid=#{tid(url)}&page=#{p}"
    get_contents(url,author)
  end
  page_num
end

def get_contents(url,author='')
  doc = Nokogiri::HTML(open(url))
  doc.css('#postlist > div').each do |ele|
    if ele.css('.postauthor .postinfo a').first.content==author
      puts '@@@@@@@@@@@@@@@@@@@@@@@'
      ele.css('.postcontent .defaultpost .postmessage').each do |post|
        post.css('img').each do |img|
          img.attributes['src'].value = 'tt'
          puts img.attr('src')
        end
      end
    end
  end
end

def trim_nodes(node)
  node.css('.newrate').remove
  node
end

def tid(url)
  start_i = url.index 'tid'
  end_i = url.index '&'
  url[(start_i+4)..(end_i-1)]
end

puts fetch_infos('http://bbs.go2eu.com/viewthread.php?tid=547752&extra=page%3D1&page=1')
