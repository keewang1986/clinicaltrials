require 'rubygems'
require 'nokogiri'
require 'open-uri'

class Drug
  #读取记录的URL
  @record_url = 'https://clinicaltrials.gov/ct2/show/record/'

  #读取整个页面的HTML并解析成JSON
  def self.json_data(_id_query)

    url = @record_url+"#{_id_query}"
    doc = Nokogiri::HTML(open(url))
    #标题
    title = doc.css("h1[class=solo_record]").text
    #受理号
    identifier = doc.css("div[class=identifier]").text
    #主办方
    sponsor = doc.css("div#sponsor").text
    #责任方
    responsible = doc.css("div[class=info-text]")[1].text

    json = ""
    json += "{"
    json += "\"title\":\""+title+"\","
    json += "\"identifier\":\""+identifier+"\","
    json += "\"sponsor\":\""+sponsor+"\","
    json += "\"responsible\":\""+responsible+"\","

    json += read_tr(doc)

    json += "}"
    puts json
    #read_tr(doc)
  end

  #读取每个TR
  private
  def self.read_tr(_doc)
    json = ""
    #查询所有的tr
    trs = _doc.css("tr")
    trs.each do |tr|
      #tr转字符串
      tr_text = "#{tr}"
      doc =  Nokogiri::HTML(tr_text)
      json += read_row(doc,tr_text)
    end
    return "{" + json[0,json.length-1]+ "}}"
  end

  #读取每行的HR和TD
  private
  def self.read_row(_doc,_tr)
    tr = _tr
    doc = _doc
    json = ""
    if tr.include? "header2"
      th = doc.css("th").text
      json += "\""+th+"\":{"
    end


    if tr.include? "header3"
      th = doc.css("th").text
      td = doc.css("td").text
      json += "\""+th+"\":\""+td+"\","
    end
    return json
  end

end