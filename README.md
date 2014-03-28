# Using RScript Client

    require 'requestor'
    eval Requestor.read('http://rorbuilder.info/r/ruby'){|x| x.require 'rcscript-client'}

    RScriptClient.new({hostname: '192.168.1.159:4446', package: 'r'}).hello.text
    #=> "hello 2011-10-01 14:57:02 +0100"

