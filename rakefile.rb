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
  sh "rm -rf ffmpeg-*"
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
	sh "ffmpeg -f x11grab -s 1000x700 -i :0 out.mpg > /dev/null 2>&1 &"
end

desc "Stop recording"
task :record_stop do
	puts "Stop recording from screen :99"
	sh "killall ffmpeg"
end

desc "Record a test"
task :test_prepare do
  sh "mkdir artifacts"
  sh "cp download-*.sh artifacts/"
  sh "cd artifacts && sh download-core-artifacts.sh"
  sh "cd artifacts && sh download-ml-artifacts.sh"
  sh "sh artifacts/ci/prepare-tests.sh"
  sh "cp ff-test-driver artifacts/ci"
  sh "cp run-tests.sh tests/"
end

desc "Record a test"
task :test_run do
  sh "cd tests && sudo sh run-tests.sh functional"
end

desc "Recording a test"
task :record_test => [:record_start, :test_prepare, :test_run, :record_stop] do
	puts "Start recording a test"
end

task :cleanup do
	sh "sudo rm -rf artifacts core marklogic tests out.mpg"
end
