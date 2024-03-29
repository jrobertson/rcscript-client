#!/usr/bin/env ruby

# file: rcscript-client.rb

require 'open-uri'
require 'cgi'
require 'rexml/document'

class RCScriptClient
  include REXML

  attr_reader :doc, :result, :text   
  attr_accessor :package
  
  def initialize(opts={})        
    
    o = {:hostname => 'rscript.heroku.com', :package => '', https: false}\
        .merge(opts)
    @hostname = o[:hostname]
    @package = o[:package]
    @protocol = o[:https] ? 'https' : 'http'
    
    if @package.length > 0 then
      jobs_to_methods(@package)    
      init_content_types
    end   

  end
  
  def package=(s)
    if s then
      @package = s
      jobs_to_methods(@package)    
      init_content_types
    end
  end
  
  private
  
  def jobs_to_methods(package)
    #url = "http://a0.jamesrobertson.me.uk/rorb/r/heroku/%s.rsf" % package
    url = "%s://%s/source/%s" % [@protocol, @hostname, package]
    puts 'url : ' + url
    buffer = URI.open(url, 'UserAgent' => 'ClientRscript').read
    puts 'buffer: ' + buffer.inspect
    doc = Document.new(buffer)
    a = XPath.match(doc.root, 'job/attribute::id')
    a.each do |attr|
      method_name = attr.value.to_s.gsub('-','_')
      method = "def %s(param={}); query_method('%s', param); end" % [method_name, method_name]
      self.instance_eval(method)
    end
  end  
  
  def init_content_types  
  
    @return_type = {}
    
    xmlproc = Proc.new {
      @doc = Document.new(@result.sub(/xmlns=["']http:\/\/www.w3.org\/1999\/xhtml["']/,''))
      summary_node = XPath.match(@doc.root, 'summary/*')
      if summary_node then
        summary_node.each do |node|
    
        if node.cdatas.length > 0 then
          if node.cdatas.length == 1 then
            content =  node.cdatas.join.strip
          else
            if node.elements["@value='methods'"] then
            
            else
              content = node.cdatas.map {|x| x.to_s[/^\{.*\}$/] ? eval(x.to_s) : x.to_s}
            end
            
          end
        else
          content = node.text.to_s.gsub(/"/,'\"').gsub(/#/,'\#')
        end

        
method =<<EOF
def #{node.name}()
  #{content}
end
EOF
          self.instance_eval(method)
        end
        records = XPath.match(@doc.root, 'records/*/text()')
        method = "def %s(); %s; end" % [@doc.root.name, records.inspect] if records      
        self.instance_eval(method)
      end
    }
    
    textproc = Proc.new {@text = @result}  
    @return_type['text/plain'] = textproc
    @return_type['text/html'] = textproc
    @return_type['text/xml'] = xmlproc
    @return_type['application/xml'] = xmlproc
    @return_type['application/rss+xml'] = xmlproc
    
  end
  
  def query_method(method, params={})
    base_url = "http://#{@hostname}/do/#{@package}/"
    param_list = params.to_a.map{|param, value| "%s=%s" % [param, CGI.escape(value)]}.join('&')
    url = "%s%s?%s" % [base_url, method.gsub('_','-'), param_list]
    puts 'url: ' + url.inspect
    response = URI.open(url, 'UserAgent' => 'RScriptClient')    
    @result = response.read
    @return_type[response.content_type].call
    return self
  end
  
end
