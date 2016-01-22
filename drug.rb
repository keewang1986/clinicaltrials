require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'

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
    hash_data = Hash.new
    hash_data[:title] = title
    hash_data[:identifier] = identifier
    hash_data[:sponsor] = sponsor
    hash_data[:responsible] = responsible

    hash_data[:sub_title] = read_tr(doc)

    return hash_data
  end

  #读取每个TR
  private
  def self.read_tr(_doc)

    hash_trs = Hash.new

    #查询所有的tr
    trs = _doc.css("tr")
    trs.each do |tr|
      #tr转字符串
      tr_text = "#{tr}"
      doc =  Nokogiri::HTML(tr_text)
      hash_new = read_row(doc,tr_text)
      if hash_new !={}
        hash_trs = hash_trs.merge hash_new
      end
    end
    return hash_trs
  end

  #读取每行的HR和TD
  private
  def self.read_row(_doc,_tr)
    tr = _tr
    doc = _doc

    hash_tr = Hash.new

    if tr.include? "header3"
      th = doc.css("th").text
      th_text = "#{th}"
      if th_text!=""
         td = doc.css("td").text
         hash_tr[th_text] = td
      end
    end

    return hash_tr
  end

end
