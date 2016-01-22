require File.dirname(__FILE__)+'/drug'

#打开查询页面
page = Nokogiri::HTML(open('https://clinicaltrials.gov/ct2/results?term=&Search=Search'))
links = page.css("a")
links.each do |link|
  href = link['href']
  if href.include? "/show/"
    puts href
    #读取URL的唯一标识
    id_query = href.match(/(?<=\/show\/).*?(?=\?)/)
    #进入封装类结构转换成JSON
    Drug.json_data(id_query)
  end
end

