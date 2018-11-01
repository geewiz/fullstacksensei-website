require 'rspec/core/rake_task'

PROJECT_NAME = File.basename(Dir.getwd)
DOCKER_REGISTRY = "quay.io/freistil"
DOCKER_IMAGE = "#{DOCKER_REGISTRY}/#{PROJECT_NAME}"

task :default => :build

desc "Build the website from source"
task :build do
  sh "bundle exec jekyll build"
end

desc "Run the preview server at http://localhost:5000"
task :preview do
  sh "bundle exec rackup -p 5000"
end

RSpec::Core::RakeTask.new(:spec)

desc "Run integration tests"
task :test => [ :build ]

namespace :docker do
  desc "Build Docker image"
  task :build do
    sh "bin/build.sh"
  end

  desc "Run container locally"
  task :run do
    sh "docker run --rm --name #{PROJECT_NAME} -p 5000 -e DEV_ENV=true #{DOCKER_IMAGE}"
  end

  desc "Get published port of local container"
  task :port do
    sh "docker port #{PROJECT_NAME}"
  end
end

namespace :k8s do
  desc "Deploy to Kubernetes"
  task :deploy do
    sh "bin/deploy.sh"
  end
end
