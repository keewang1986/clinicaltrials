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
    #存储sub_title内容
    hash_trs = Hash.new
    #存储sub_title子类内容
    hash_trs_child = Hash.new
    #sub_title子类的KEY建
    sub_title = ""

    #查询所有的tr
    trs = _doc.css("tr")
    trs.each do |tr|
      #tr转字符串
      tr_text = "#{tr}".gsub(' ','')
      tr_text = "#{tr}".gsub('<br>','\r\n')
      doc =  Nokogiri::HTML(tr_text)
      if tr_text.include? "header2"
          #将sub_title子类的内容存入
          if hash_trs_child != {}
            hash_trs[sub_title] = hash_trs_child
          end
          hash_trs_child = Hash.new
          hash_trs_child = Hash.new
          th = doc.css("th").text
          sub_title = "#{th}"
          sub_title = sub_title.gsub('ICMJE','').gsub(' ','').lstrip.rstrip
          hash_trs[sub_title] = Hash.new
      else
        tr_text=tr_text.gsub(' ','')
        hash_new = read_row(doc,tr_text)
        if hash_new !={}
          hash_trs_child = hash_trs_child.merge hash_new
      end
    end
      if hash_trs_child != {}
        hash_trs[sub_title] = hash_trs_child
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
         td = td.lstrip.rstrip
         th_text = th_text.gsub("ICMJE","")
         th_text = th_text.gsub(" ","")
         th_text = th_text.lstrip
         th_text = th_text.rstrip
         hash_tr[th_text] = td
      end
    end

    return hash_tr
  end

end
