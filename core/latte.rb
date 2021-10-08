# frozen_string_literal
require 'inifile'
require 'open-uri'
require 'colorize'
# module to download Packages
module Pkg
  def self.findPkg(query)
    $query = query
    puts "Getting #{$query}".colorize(:yellow)
    Pkg.getPkgfile
  end

  def self.getPkgfile
    pfr = URI.open("https://raw.githubusercontent.com/Pandademic/Latte/master/pkgs/#{$query}.ini").read
    packageFileURL = "https://raw.githubusercontent.com/Pandademic/Latte/master/pkgs/#{$query}.ini"
    puts "Package file:#{pfr}"
    # implemnt no donwload of pkg file by using pfr
    system("curl  -O #{packageFileURL}")
    puts 'package file download complete'.colorize(:yellow)
    Pkg.downloadLatest
  end

  def self.downloadLatest
    file = IniFile.load("#{$query}.ini")
    puts 'loaded file'
    pkgdata = file['package']
    zipsupport = pkgdata['Media']
    if zipsupport == true
      @RURL = pkgdata['MediaUrl']
      system "curl -O #{@RURL}"
      puts "#$query install success!".colorize(:green)
    else
      @Isc = pkgdata['InstallCommand'] # install command
      system @Isc.to_s
      puts "#$query installed successfully".colorize(:green)
    end
  end
end
@param1 = ARGV[1]
if @param1 == 'add'
  Pkg.findPkg @param1.to_s
else
  puts 'Unknown Command' .colorize(:red)
  exit 1
end
