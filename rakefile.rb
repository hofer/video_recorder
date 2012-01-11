task :default => :play

desc "Install screen recorder."
task :install_packages do
  sh "sudo yum -y install wget gcc yasm-devel.x86_64 libXfixes-devel.x86_64 libXext-devel.x86_64 libX11-devel.x86_64"
end

desc "Install screen recorder."
task :install_recorder => :install_packages do

  sh "wget http://ftp.br.debian.org/debian-multimedia/pool/main/x/xvidcore/xvidcore_1.3.2.orig.tar.gz"
  sh "tar -xvzf xvidcore_1.3.2.orig.tar.gz"
  sh "cd xvidcore-1.3.2/build/generic && ./configure"
  sh "cd xvidcore-1.3.2/build/generic && make"
  sh "cd xvidcore-1.3.2/build/generic && sudo make install"
  sh "rm -rf xvidcore*"

  sh "wget http://ffmpeg.org/releases/ffmpeg-0.8.6.tar.gz"
  sh "tar -xvzf ffmpeg-0.8.6.tar.gz" 
  sh "cd ffmpeg-0.8.6 && ./configure --enable-gpl --enable-x11grab --enable-nonfree --enable-libxvid"
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
  sh "mplayer -fs -zoom out.mp4"
end

desc "Play on tv"
task :play_on_tv do
  sh "scp out.mp4 repo.tools:/var/www/html/out.mp4"
  sh "wget http://172.18.10.249:59623/play?p='http://repo.tools/out.mp4'"
end

desc "Record from screen"
task :record_start do
  puts "Start recording from screen :0"
  sh "rm -f out.mp4"
  sh "ffmpeg -f x11grab -s 940x970 -i :13+20,100 -vcodec libxvid -r 25 -b 4000k -f mp4 out.mp4 > /dev/null 2>&1 &"
end

desc "Stop recording"
task :record_stop do
  puts "Stop recording from screen :99"
  sh "killall ffmpeg"
end

desc "Prepare a test run"
task :test_prepare do

  artifactsUrl = "http://repo.tools/repos/go-artifacts"
  mlVersion = "0.84"
  coreVersion = "0.2911"

  mkdir "artifacts"
  sh "cd artifacts && wget -q -r -np -nH --cut-dirs=4 -R index.html* #{artifactsUrl}/ml/#{mlVersion}/"
  sh "cd artifacts && wget -q -r -np -nH --cut-dirs=4 -R index.html* #{artifactsUrl}/core/#{coreVersion}/"
  sh "sh artifacts/ci/prepare-tests.sh"
  cp "ff-test-driver", "artifacts/ci/"
  cp "run-tests.sh", "tests/"
end

desc "Record a test"
task :test_run do
  sh "cd tests && sudo sh run-tests.sh functional" do |ok, status|
  end
end

desc "Recording a test"
task :record_test => [:test_prepare, :record_start, :test_run, :record_stop]

task :cleanup do
  sh "sudo rm -rf artifacts core marklogic tests out.mp4 nohup.out"
end
