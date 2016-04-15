import JenkinsGetBuildInfo as build
import coberturahandler
import sys

def jenkins_job(project_name):
	server = build.connect_to_server()
	(con, cur) = build.connect_to_db()
	# cobertura = coberturahandler.CoberturaHandler(server, project_name)
	# code_coverage = cobertura.get_cobertura_info()
	build.fetch_last_build_properties_for_job(server, project_name, cur)
	con.commit()
	last_build_info = build.obtain_last_build_for_job(project_name, cur)
	# for nextObj in last_build_info['items']:
	# 	print nextObj
	# print last_build_info
	return last_build_info['totalCount']#{'last_build_info':last_build_info, 'tests_info':code_coverage}



def jenkins_all_job():
	server = build.connect_to_server()
	(con, cur) = build.connect_to_db()
	iosItems = server.views['iOS'].items()
	iosNightly = server.views['iOS.Nigthly'].items()
	for item in iosItems:#+iosNightly:
		build.fetch_last_build_properties_for_job(server, item[0], cur)
		con.commit()
	last_build_info = build.obtain_last_builds_stat(cur)# build.obtain_last_build_for_job(project_name, cur)
	dictionary = []
	for nextObj in last_build_info['items']:
		dictionary.append({"label":nextObj['projectName'], "value":nextObj['totalCount']})
	return {"items": dictionary}

def jenkins_success_job(project_name):
	server = build.connect_to_server()
	(con, cur) = build.connect_to_db()
	# cobertura = coberturahandler.CoberturaHandler(server, project_name)
	# code_coverage = cobertura.get_cobertura_info()
	build.fetch_last_success_build_properties_for_job(server, project_name, cur)
	last_build_info = build.obtain_last_succes_build_for_job(project_name, cur)
	# for nextObj in last_build_info['items']:
	# 	print nextObj
	# print last_build_info
	return {"items": [{"label": last_build_info['projectName'], "value": last_build_info['totalCount']}]}#['totalCount']


# for item in iosItems+iosNightly:
# 	job_name = item[0]
# 	fetch_last_build_properties_for_job(server, job_name, cur)
# 	con.commit()
# 	cobertura = coberturahandler.CoberturaHandler(server, job_name)
# 	print cobertura.get_cobertura_info()
#
#
#
#
# print obtain_last_builds_stat(cur)
if len(sys.argv) < 2:
	assert ()

job_name = sys.argv[1]
print jenkins_success_job(job_name)#jenkins_all_job()#jenkins_job(job_name)#
#
#server = build.connect_to_server()
#iosItems = server.views['iOS'].items()
#iosNightly = server.views['iOS.Nigthly'].items()
#
#for item in iosItems+iosNightly:
#	job_name = item[0]
#	build.fetch_some_last_builds_stat_for_job(build.connect_to_server(), job_name)