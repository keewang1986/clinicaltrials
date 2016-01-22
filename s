require File.dirname(__FILE__)+'/drug'
require File.dirname(__FILE__)+'/file_cls'


#打开查询页面
page = Nokogiri::HTML(open('https://clinicaltrials.gov/ct2/results?term=&Search=Search'))
links = page.css("a")
links.each do |link|
  href = link['href']
  if href.include? "/show/"

    #读取URL的唯一标识
    id_query = href.match(/(?<=\/show\/).*?(?=\?)/)
    #进入封装类结构转换成JSON
    hash_drug = Drug.json_data(id_query)

    file_name = "#{id_query}" + ".txt"
    File_cls.create file_name,hash_drug.to_json
    #puts hash_drug.to_json
    break
  end
end
#end


