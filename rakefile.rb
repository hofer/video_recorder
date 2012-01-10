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
  sh "cd ffmpeg-0.8.6 && sudo make clean install"
end
  
desc "Install player."
task :install_player => :install_packages do
  
  # Install mplayer
	sh "wget --no-check-certificate https://github.com/downloads/hofer/video_recorder/mplayer.tar.gz"
  sh "tar -xvzf mplayer.tar.gz"
  sh "cd mplayer-export-2012-01-09/ && ./configure"
  sh "cd mplayer-export-2012-01-09/ && sudo make clean install"
  sh "rm -rf mplayer*"
  
  # Install ruby script which allows to play a video from url
  sh "sudo gem install sinatra"
  sh "wget --no-check-certificate https://raw.github.com/hofer/video_recorder/master/videoplayer.rb"
  sh "ruby videoplayer.rb &"
end

desc "Play recorded video"
task :play do
	puts "Want to play ...."
  sh "mplayer -fs out.mpg"
end

desc "Record from screen"
task :record_start do
	puts "Start recording from screen :0"
	sh "rm -f out.mpg"
	sh "ffmpeg -f x11grab -s 1000x700 -i :0 out.mpg"
end

desc "Stop recording"
task :record_stop do
	puts "Stop recording from screen :0"
	sh "killall ffmpeg"
end

desc "Record a test"
task :test_application do
  sh "mkdir artifacts"
  sh "cp download-*.sh artifacts/"
  sh "cd artifacts && sh download-core-artifacts.sh"
  sh "cd artifacts && sh download-ml-artifacts.sh"
  sh "sh artifacts/ci/prepare-tests.sh"
end

desc "Recording a test"
task :record_test => [:record_start, :test_application, :record_stop] do
	puts "Start recording a test"
end

# desc "create a directory"
# directory "dist"
# desc "package the whole app"
# task :package => "dist" do
#   sh "tar -czf dist/ImageConverter-#{version}.tar.gz #{src}"
# end