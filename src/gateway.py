import requests

url = 'http://localhost:3333/xml-files'

def get_xml():
    request = requests.get(url)
    #print(request.text)
    return request

def get_xml_by_id(xml_id):
    request = requests.get(f"{url}/{xml_id}")
    #print(request.text)
    return request

def post_xml(body):
    request = requests.post(url, json=body)
    #print(request.text)
    return request

def time_xml():
    request = requests.get(f"{url}/time")
    #print(request.text)
    return request

def reset_xml():
    request = requests.post(f"{url}/reset")
    #print(request.text)
    return request