class File_cls
  @path = "#{File.dirname(__FILE__)}"
  def self.create(_filename,_text)
    file_new = File.new(_filename,"w+")
    file_new.syswrite(_text)
    file_new.close()
  end


end