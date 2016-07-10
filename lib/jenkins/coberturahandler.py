from jenkinsapi.jenkinsbase import JenkinsBase

class CoberturaHandler(JenkinsBase):

    def __init__(self, jenkins_obj, job_name, build_number=None):
        self.jenkins_obj = jenkins_obj
        if build_number == None:
            try:
                build_number = jenkins_obj[job_name].get_last_good_buildnumber()
            except:
                build_number = 1
        url = '%s/job/%s/%s/cobertura/api/json?depth=2' % (jenkins_obj.baseurl, job_name, build_number)
        JenkinsBase.__init__(self, url)


    def get_jenkins_obj(self):
        return self.jenkins_obj

    def _poll(self, tree=None):
        data = None
        try:
            data = self.get_data(self.baseurl, tree=tree)
        except:
            data = {'results': {'elements': []}}
        return data

    def get_cobertura_info(self):
        return self._poll()['results']['elements']
