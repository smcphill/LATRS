namespace :latrs do
  task :make_rdoc do
    sh "rdoc -t 'LATRS documentation' --op rdoc  README license app"
  end
end
