Gem::Specification.new do |s|
  s.name = 'rcscript-client'
  s.version = '0.3.0'
  s.summary = 'RCscript-client is a utility for remotely executing Ruby Scripting Files (RSF)'
    s.authors = ['James Robertson']
  s.files = Dir['lib/rcscript-client.rb'] 
  s.signing_key = '../privatekeys/rcscript-client.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/rcscript-client'
  s.required_ruby_version = '>= 2.1.2'
end
