require 'json'
SCHEDULER.every '1h', :first_in => 0 do
    correct_array = []
    tmp_dir = File.expand_path("lib/jenkins/", Dir.pwd)
    project_manager = Infrastructure::ProjectManager.new
    project_manager.obtain_all_projects.each do |project|
      name = project.jenkins_name
      next until name != nil
      output = `python #{tmp_dir}/jenkins_job.py #{name}`.gsub('\'', '"').gsub('u"', '"')
      result = JSON.parse(output)
      new_hash = result['items']
      correct_array = correct_array.concat(new_hash)

      separate_widget_name = "jenkins_#{project.jenkins_name}"
      number_of_tests = new_hash[0]["value"]
      send_event(separate_widget_name, { current: number_of_tests })
    end
    correct_array = correct_array.sort_by {|hash| hash[:value]}.reverse!
    send_event('jenkins', { items: correct_array })
end