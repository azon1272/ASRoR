#!/usr/bin/env ruby
# coding: utf-8
require 'rubygems'
require 'zip/zip' # rubyzip gem
require 'nokogiri'

class WordXmlFile
  def self.open(path, &block)
    self.new(path, &block)
  end

  def initialize(path, &block)
    @replace = {}
    if block_given?
      @zip = Zip::ZipFile.open(path)
      yield(self)
      @zip.close
    else
      @zip = Zip::ZipFile.open(path)
    end
  end

  def force_settings
    @replace["word/settings.xml"] = %{<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <w:settings xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:sl="http://schemas.openxmlformats.org/schemaLibrary/2006/main"><w:zoom w:percent="100"/></w:settings>}
    end
  def merge(rec)
    xml = @zip.read("word/document.xml")
    #puts xml
    #puts rec.keys

    doc = Nokogiri::XML(xml) {|x| x.noent}
    puts doc
    (doc/"//w:r").each do |field|
        #if field.attributes['instr'].value =~ /MERGEFIELD (\S+)/
      text_node = (field/".//w:t").first
      puts text_node
      text  = text_node.to_s
      text=text.scan(/([0-9А-Яа-яіґїє_\+\-’\,\.\$]*\s*)/)#.sub("city",'TOOOOOOOT').to_s
      text = text.join
      puts text
      #puts rec.keys.size
      for i in 0..(rec.keys.size-1) do
        text = text.gsub(rec.keys[i],rec[rec.keys[i]])
      end
      if text_node
        text_node.inner_html = text#rec[$1].to_s
      #else
        
        #puts "No text node for #{$1}"
      end
        #end
      end
    @replace["word/document.xml"] = doc.serialize :save_with => 0
  end
  
  def save(path)
    Zip::ZipFile.open(path, Zip::ZipFile::CREATE) do |out|
      @zip.each do |entry|
        out.get_output_stream(entry.name) do |o|
          if @replace[entry.name]
            o.write(@replace[entry.name])
          else
            o.write(@zip.read(entry.name))
          end
        end
      end
    end
    @zip.close
  end
end

if __FILE__ == $0
  file = 'dog.docx'
  out_file = file.sub(/\.docx/, '11.docx')
  w = WordXmlFile.open(file)
  w.force_settings
  w.merge('$Місто' => 'Миколаїв', '$Місяць' => 'Листопад')
  w.save(out_file)
end