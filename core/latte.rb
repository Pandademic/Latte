# frozen_string_literal
require 'inifile'
require 'open-uri'
require 'facter'
# TODO: bring back helper
# module to download Packages
module Pkg
  def self.findPkg(query)
    $query = query
    puts "Getting #{$query}"
    Pkg.getPkgfile
  end

  def self.getPkgfile
  rescue OpenURI::HTTPError
    puts 'this package does not exist'
    pfr = URI.open("https://raw.githubusercontent.com/Pandademic/Latte/master/pkgs/#{$query}.ini").read
    packageFileURL = "https://raw.githubusercontent.com/Pandademic/Latte/master/pkgs/#{$query}.ini"
    puts "Package file:#{pfr}"
    system("curl  -O #{packageFileURL}")
    puts 'package file download complete'
    Pkg.downloadLatest
  end

  def self.downloadLatest
    file = IniFile.load("#{$query}.ini")
    puts 'loaded file'
    pkgdata = file['package']
    zipsupport = pkgdata['Zip']
    if zipsupport == true
      @RURL = pkgdata['Release']
      system("curl -O #{@RURL}")
    else
      @Isc = pkgdata['InstallCommand'] # install command
      system @Isc.to_s
    end
  end
end
@param1 = ARGV[1]
$os = Facter['osfamily'].value
abort('That is not a command') while ARGV.empty?
# Helper.man if ARGV[0] == 'man'
# Pkg.findPkg(@param1.to_s) if ARGV[0] == 'add'
# Pkg.findPkg(@param1.to_s) if ARGV[0] == 'install'
if ARGV[0] == 'add'
  Pkg.findPkg @param1.to_s
elsif Pkg.findPkg @param1.to_s
else
  puts 'Unknown Command'
end
