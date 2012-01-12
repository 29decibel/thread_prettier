# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
google.load('search', '1', {language : 'zh-CN', style : google.loader.themes.GREENSKY})
gload_callback = ->
  customSearchControl = new google.search.CustomSearchControl('003556337014962056360:mz5bdsf2e0u')
  customSearchControl.setResultSetSize(google.search.Search.FILTERED_CSE_RESULTSET)
  customSearchControl.draw('cse')
google.setOnLoadCallback(gload_callback, true)

$ ->
  $('.gs-webResult').live 'click',->
    $('.article_details').html($(this).clone()).show()
    url = $(this).find('.gs-visibleUrl-long').text()
    #$("#page_infos").attr('src','http://'+url)
    $.post("/readable_articles", { 'url': 'http://'+url })
    $('.readable_article').html("<div class='loading'>Loading...</div>")
  # $(".resource_info").sticky({topSpacing:0})
