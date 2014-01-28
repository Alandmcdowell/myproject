namespace :dev do
  # Just run development env
  # This code run insert seed and agency data
  # A simple trick to over migration problem
  task :setup => [:environment] do
    raise 'Nah, You are at production' if Rails.env.production?
    Rake::Task['dev:kill_postgres_connections'].execute
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['db:seed'].execute
    Rake::Task['dev:user'].execute
    Rake::Task['dev:admin'].execute
  end

  task :user => [:environment] do
    guest = User.find_by_email('collaborall@outlook.com')
    Alan  = User.create!(email: 'collaborall@outlook.com',     password: '123456', password_confirmation: '123456', profile_attributes: { name: 'Muhammet Dilek' })

    project = guest.own_projects.create(name: 'Blog', description: 'My personel website', owner_id: guest.id)
    project.users << guest
    project.users << Alan
    project.users << tayfun
    project.users << hamit
    project.users << muhammet

    list_1 = project.lists.create(name: 'To Do')
    list_1.cards.create(title: 'Create Project With Cybele', owner_id: guest.id)
    list_1.cards.create(title: 'Setup Mandril', owner_id: alan.id)
    list_1.cards.create(title: 'Setup Bulutfon', owner_id: alan.id, assignment_id: alan.id)
    list_2 = project.lists.create(name: 'In Progress')
    list_2.cards.create(title: 'Setup Capistrano', owner_id: alan.id)

  end

  task :admin => [:environment] do
    Admin.create!(email: 'collaborall@outlook.com', password: '123456', password_confirmation: '123456')
  end



  task :kill_postgres_connections => [:environment] do
    db_name = "#{File.basename(Rails.root)}_#{Rails.env}"
    sh = <<EOF
ps xa \
  | grep postgres: \
  | grep #{db_name} \
  | grep -v grep \
  | awk '{print $1}' \
  | xargs kill
EOF
    puts `#{sh}`
  end

end