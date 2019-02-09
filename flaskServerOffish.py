from __future__ import print_function
from flask import Flask, request, redirect, url_for, render_template, Response, jsonify
import sys

app = Flask(__name__)
userDict = {}

#initial render
@app.route('/')
def index():
    return render_template ("registerPageOffish.html", alert = "")
    
# when POST method is called from website
@app.route("/", methods = ["POST", "GET"])
def register():
    userName = request.form ['user']
    password = request.form ['pass']
    confirm = request.form ['confirmPass']
    print (userName, file = sys.stderr)
    print (password, file = sys.stderr)
    print (confirm, file = sys.stderr)
    if userName != "" and password != "" and password == confirm:
        userDict [userName] = password
        print(userDict, file=sys.stderr)
        return redirect("/finishedRegistration")
    else:
        alert = "hey you suck"
        return redirect ("/", alert = alert)
        

@app.route("/finishedRegistration")
def finishedRegistration():
     #data = request.get_json()
    print (9099088980099798709897089009, file=sys.stderr)
    return render_template ("finishedRegistration.html")

if __name__ == '__main__':
    app.run(debug=True, host='128.237.168.24')
# @app.route('/')
# def index():
#    return render_template('log_in.html')
# 
# @app.route('/login',methods = ['POST', 'GET'])
# def login():
#    if request.method == 'POST':
#       if request.form['username'] == 'admin' :
#          return redirect(url_for('success'))
#       else:
#          abort(401)
#    else:
#       return redirect(url_for('index'))
# 
# @app.route('/success')
# def success():
#    return 'logged in successfully'
# 
# if __name__ == '__main__':
#    app.run(debug = True)
#sudo lsof -i:5000