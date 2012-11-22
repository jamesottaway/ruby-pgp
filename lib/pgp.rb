require 'java'
require 'pgp/jars/bcprov-jdk15on-147.jar' if JRUBY_VERSION < '1.7'
require 'pgp/jars/bcpg-jdk15on-147.jar'
require 'pgp/jruby-pgp.jar'

require 'pgp/decryptor'
require 'pgp/encryptor'
require 'pgp/private_key'

module PGP
  autoload :VERSION,        'pgp/version'
  autoload :RubyDecryptor,  'pgp/ruby_decryptor'

  BC_Provider_Code = "BC"

  java_import 'java.io.ByteArrayInputStream'
  java_import 'java.security.Security'
  java_import 'org.bouncycastle.jce.provider.BouncyCastleProvider'

  Security.add_provider BouncyCastleProvider.new

  def self.string_to_bais(string)
    ByteArrayInputStream.new string.to_java_bytes
  end

  # This exists for stubbing during tests
  def self.time_now
    Time.now
  end

end
