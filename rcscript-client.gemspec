Gem::Specification.new do |s|
  s.name = 'rcscript-client'
  s.version = '0.2.1'
  s.summary = 'RCscript-client is a utility for remotely executing Ruby Scripting Files (RSF)'
    s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb'] 
  s.signing_key = '../privatekeys/rcscript-client.pem'
  s.cert_chain  = ['gem-public_cert.pem']
end
