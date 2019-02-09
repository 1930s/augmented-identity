from __future__ import print_function
from flask import Flask, request, redirect, url_for, render_template, Response, jsonify
import sys

app = Flask(__name__)
userDict = {}

#initial render
@app.route('/')
def registerPage():
    return render_template("registerPage.html")
    
# when POST method is called from website
@app.route("/register", methods=["GET", "POST"])
def register():
    data = request.get_json()
    userDict.update(data)
    print(userDict, file=sys.stderr)
    return render_template("finishedRegistration.html")

@app.route("/finishedRegistration", methods=["GET", "POST"])
def finishedRegistration():
    data = request.get_json()
    return render_template("EnterPortfolioInfo.html")

if __name__ == '__main__':
    app.run(debug=True, host='128.237.173.66')

#sudo lsof -i:5000