from __future__ import print_function
from flask import Flask, request, redirect, url_for, render_template, Response, jsonify
import sys

app = Flask(__name__)

personalWebsite = "None"
github = "None"
linkedIn = "None"
facebook = "None"

#initial render
@app.route('/')
def index():
    return render_template("EnterPortfolioInformation.html")
    
# when POST method is called from website for saving links
@app.route("/", methods = ["POST", "GET"])
def saveData():
    personalWebsiteLink = request.form ["PersonalWebsite"]
    githubLink = request.form ["Github"]
    linkedInLink = request.form ["LinkedIn"]
    facebookLink = request.form ["Facebook"]
    if personalWebsiteLink != "enter URL" and personalWebsiteLink != "":
        personalWebsite = personalWebsiteLink
    if githubLink != "enter URL" and githubLink != "":
        github = githubLink
    if linkedInLink != "enter URL" and linkedInLink != "":
        linkedIn = linkedInLink
    if facebookLink != "enter URL" and facebookLink != "":
        facebook = facebookLink
    print([personalWebsite, github, linkedIn, facebook], file=sys.stderr)
    return redirect("/")
    
    

@app.route("/finishedRegistration")
def finishedRegistration():
     #data = request.get_json()
    return render_template ("finishedRegistration.html")

if __name__ == '__main__':
    app.run(debug=True, host='128.237.173.66')