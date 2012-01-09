task :default => :play

desc "Install screen recorder."
task :install_packages do
	sh "sudo yum -y install wget gcc yasm-devel.x86_64 libXfixes-devel.x86_64 libXext-devel.x86_64 libX11-devel.x86_64"
end

desc "Install screen recorder."
task :install_recorder => :install_packages do
	sh "wget http://ffmpeg.org/releases/ffmpeg-0.8.6.tar.gz"
  sh "tar -xvzf ffmpeg-0.8.6.tar.gz" 
  sh "cd ffmpeg-0.8.6 && ./configure --enable-gpl --enable-x11grab --enable-nonfree"
  sh "cd ffmpeg-0.8.6 && make clean install"
end
  
desc "Install player."
task :install_player => :install_packages do
	sh "wget --no-check-certificate https://github.com/downloads/hofer/video_recorder/mplayer.tar.gz"
  sh "tar -xvzf mplayer.tar.gz"
  sh "cd mplayer-export-2012-01-09/ && ./configure"
  sh "cd mplayer-export-2012-01-09/ && make clean install"
end

desc "Play recorded video"
task :play do
	puts "Want to play ...."
  sh "mplayer -fs out.mpg"
end

desc "Record from screen"
task :record do
	puts "Start recording from screen :0"
	sh "rm out.mpg"
	sh "ffmpeg -f x11grab -s 1000x700 -i :0 out.mpg"
end

# desc "create a directory"
# directory "dist"
# desc "package the whole app"
# task :package => "dist" do
#   sh "tar -czf dist/ImageConverter-#{version}.tar.gz #{src}"
# end