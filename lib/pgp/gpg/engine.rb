require 'tempfile'
require 'tmpdir'

module GPG
  class Engine
    attr_accessor :runner
    attr_accessor :verbose

    def initialize(runner = nil, verbose = false)
      self.runner = runner || GPG::Runner.new
      self.verbose = verbose
      self.runner.verbose = self.verbose
    end

    def import_key(key_contents)
      log("Import Key")
      Tempfile.open do |f|
        f.write(key_contents)
        f.rewind
        runner.import_key_from_file(f.path)
      end
    end

    def verify_signature(signature_data)
      log("Verify Signature")

      data = ''
      result = false

      GPG::TempPathHelper.create do |path1|
        GPG::TempPathHelper.create do |path2|
          File.write(path1, signature_data)
          result = runner.verify_signature_file(path1, path2)

          data = File.read(path2) if result
        end
      end

      [result, data]
    end

    def delete_all_keys
      delete_all_private_keys
      delete_all_public_keys
    end

    def delete_all_private_keys
      log('Delete all private keys')
      runner.read_private_key_fingerprints.each do |k|
        runner.delete_private_key k
      end
    end

    def delete_all_public_keys
      log('Delete all public keys')
      runner.read_public_key_fingerprints.each do |k|
        runner.delete_public_key k
      end
    end

    protected

    def log(message)
      if verbose
        PGP::Log.logger.info(message)
      end
    end

    def random_string(length=20)
      (0...length).map { (65 + rand(26)).chr }.join
    end
  end
end