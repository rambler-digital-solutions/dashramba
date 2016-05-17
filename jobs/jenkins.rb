require 'json'
SCHEDULER.every '1h', :first_in => 0 do
    correct_array = []
    tmp_dir = File.expand_path("lib/jenkins/", Dir.pwd)
    project_manager = Infrastructure::ProjectManager.new
    project_manager.obtain_all_projects.each do |project|
      puts project.jenkins_name
        name = project.jenkins_name
        output = `python #{tmp_dir}/jenkins_job.py #{name}`.gsub('\'', '"').gsub('u"', '"')
        result = JSON.parse(output)
        new_hash = result['items'].map { |item| { label: item["label"], value: item["value"] } }
        correct_array = correct_array.concat(new_hash)
        
    end
    correct_array = correct_array.sort_by {|hash| hash[:value]}.reverse!
    send_event('jenkins', { items: correct_array })
end