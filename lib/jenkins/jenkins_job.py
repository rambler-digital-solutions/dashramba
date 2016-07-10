import JenkinsGetBuildInfo as build
import coberturahandler
import sys

def jenkins_job(project_name):
	server = build.connect_to_server()
	(con, cur) = build.connect_to_db()
	build.fetch_last_build_properties_for_job(server, project_name, cur)
	con.commit()
	last_build_info = build.obtain_last_build_for_job(project_name, cur)
	return last_build_info['totalCount']



def jenkins_all_job():
	server = build.connect_to_server()
	(con, cur) = build.connect_to_db()
	iosItems = server.views['iOS'].items()
	iosNightly = server.views['iOS.Nigthly'].items()
	for item in iosItems:
		build.fetch_last_build_properties_for_job(server, item[0], cur)
		con.commit()
	last_build_info = build.obtain_last_builds_stat(cur)
	dictionary = []
	for nextObj in last_build_info['items']:
		dictionary.append({"label":nextObj['projectName'], "value":nextObj['totalCount']})
	return {"items": dictionary}

def jenkins_success_job(project_name):
	server = build.connect_to_server()
	(con, cur) = build.connect_to_db()
	build.fetch_last_success_build_properties_for_job(server, project_name, cur)
	last_build_info = build.obtain_last_succes_build_for_job(project_name, cur)
	return {"items": [{"label": last_build_info['projectName'], "value": last_build_info['totalCount']}]}

if len(sys.argv) < 2:
	assert ()

job_name = sys.argv[1]
print jenkins_success_job(job_name)