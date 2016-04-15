from jenkinsapi.jenkins import Jenkins
import json
import coberturahandler
import sqlite3
import sys

def  connect_to_server():
	server = Jenkins('http://ci.dev.rambler.ru/jenkins', username='dashramba', password='mPfmzzP')
	return server

def connect_to_db():
	con = sqlite3.connect('../../database.db')
	cur = con.cursor()
	cur.execute('CREATE TABLE IF NOT EXISTS jenkins_projects (id INTEGER PRIMARY KEY, '
	            'projectName TEXT, '
	            'buildNumber INTEGER,'
	            'totalCount INTEGER,'
	            'failCount INTEGER,'
	            'lastBuildDuration TEXT, '
	            'isSucceed BOOLEAN,'
	            'UNIQUE(buildNumber, projectName))')
	con.commit()
	return (con, cur)


def fetch_properties_for_build(job_name, build_number, build):
	(con, cur) = connect_to_db()
	dict = {"name": job_name, "time": build.get_duration()}
	if 'failCount' in build.get_actions():
		dict['failCount'] = build.get_actions()['failCount']
	if 'totalCount' in build.get_actions():
		dict['testsNumber'] = build.get_actions()['totalCount']
	if build.is_good():
		dict['isGood'] = 1
	else:
		dict['isGood'] = 0
	try:
		cur.execute('INSERT INTO jenkins_projects (id, projectName, buildNumber, totalCount, failCount, lastBuildDuration, isSucceed)'
				'VALUES(NULL, ?, ?, ?, ?, ?, ?)', (job_name, build_number, dict['testsNumber'] if 'testsNumber' in dict else 0, dict['failCount'] if 'failCount' in dict else 0, str(dict['time']), dict['isGood']))
	except:
		pass
		# sys.stderr.write('Didn\'t add anything to Table for project %s' % job_name)
	con.commit()
		# sys.stderr.write('Didn\'t add anything to Table for project %s' % job_name)
	return dict



def fetch_last_build_properties_for_job(server, job_name, cur):
	job = server[job_name]
	last_build = 0
	try:
		last_build = job.get_last_build()
	except:
		return {}
	return fetch_properties_for_build(job_name, last_build)



def fetch_last_success_build_properties_for_job(server, job_name, cur):
	job = server[job_name]
	build_number = 0
	try:
		build_number = job.get_last_good_buildnumber()
	except:
		return {}
	last_build = job.get_build(build_number)
	return fetch_properties_for_build(job_name, build_number, last_build)




def fetch_some_last_builds_stat_for_job(server, job_name):
	testsList = []
	job = server[job_name]
	last_build_number = job.get_last_buildnumber()
	max_build = last_build_number+1
	for i in range(max_build-5, max_build, 1):
		try:
			build = job.get_build(i)
			fetch_properties_for_build(job_name, i, build)
		except:
			continue


def obtain_last_builds_stat(cur):
	items = []
	for row in cur.execute('select * '
	                       'from jenkins_projects JP '
	                       'where JP.buildNumber=(select max(buildNumber) '
	                       'from jenkins_projects JP2 '
	                       'where JP2.projectName = JP.projectName) '
	                       'order by JP.projectName'):
		items.append(dict(zip(zip(*cur.description)[0], row)))
	return {'items': items}


def obtain_last_succes_build_for_job(job_name, cur):
	items = []
	for row in cur.execute('select * '
	                       'from jenkins_projects JP '
	                       'where JP.buildNumber=(select max(buildNumber) '
	                       'from jenkins_projects JP2 '
	                       'where JP2.projectName = ? AND JP2.isSucceed) '
	                       'order by JP.projectName', [job_name]):
		items.append(dict(zip(zip(*cur.description)[0], row)))
	return items[0]

def obtain_last_build_for_job(job_name, cur):
	for row in cur.execute('select * from jenkins_projects where projectName=? ORDER BY buildNumber DESC LIMIT 1',  [job_name]):
		return dict(zip(zip(*cur.description)[0], row))








