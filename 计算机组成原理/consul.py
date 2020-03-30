import urllib
import httplib
import json
from flask import Flask, redirect, request, Response

app = Flask(__name__)


@app.route('/v1/lookup/name')
def hello():
    return get_data('/v1/lookup/name')


@app.route('/v1/agent/self')
def hello2():
    return get_data('/v1/agent/self')


@app.route('/v1/lookup/conf', methods=['POST'])
def hello3():
    return get_data('/v1/lookup/conf', is_post=True)


def get_data(path, is_post=False):
    client = httplib.HTTPConnection('10.3.23.40:2280')
    params = urllib.urlencode(request.args)
    data = {}
    print(request.method)
    print(request.data)
    print(params)
    client.request(request.method, path + "?" + params, request.data)
    response = client.getresponse()
    data = response.read()
    print(data)
    return data
    # return Response(response=)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=2280, debug=True)
