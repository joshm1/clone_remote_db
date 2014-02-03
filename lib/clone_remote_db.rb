require File.expand_path("../clone_remote_db/hash", __FILE__)

module CloneRemoteDb
  lib = File.expand_path('../clone_remote_db', __FILE__)
  autoload :Loader, "#{lib}/loader.rb"
  autoload :Version, "#{lib}/version.rb"
end
