# vim:filetype=ruby:fileencoding=utf-8

Vagrant.configure('2') do |config|
  config.vm.hostname = 'docker-build-server'
  config.vm.box = 'dockerprecise64'
  config.vm.box_url = 'http://bit.ly/dockerprecise64'

  config.vm.network :private_network, ip: '33.33.33.10', auto_correct: true
  config.vm.network :forwarded_port, guest: 8080, host: 11_913,
                                     auto_correct: true
  config.vm.network :forwarded_port, guest: 5000, host: 11_914,
                                     auto_correct: true
  config.vm.network :forwarded_port, guest: 6379, host: 11_915,
                                     auto_correct: true

  dbw_path = ENV['DOCKER_BUILD_WORKER_PATH'] ||
             "#{ENV['HOME']}/workspace/docker-build-worker"
  if File.exist?(dbw_path)
    config.vm.synced_folder dbw_path, '/docker-build-worker'
  end
  config.vm.provision :shell, path: '.vagrant-provision.sh'
end
