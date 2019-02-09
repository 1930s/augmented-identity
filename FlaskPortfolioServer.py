from __future__ import print_function
from flask import Flask, request, redirect, url_for, render_template, Response, jsonify
import sys

app = Flask(__name__)

##user data
userDict = {}
personalWebsite = "None"
github = {}
linkedIn = "None"
facebook = "None"
skills = "None"

##Web pages
#initial render
@app.route('/')
def index():
    return render_template ("registerPageOffish.html")
    
# when POST method is called from register page
@app.route("/", methods = ["POST", "GET"])
def register():
    userName = request.form ['user']
    password = request.form ['pass']
    confirm = request.form ['confirmPass']
    if request.form ['button'] != "Or Login" and userName != "" and password != "" and password == confirm:
        userDict [userName] = password
        return redirect("/finishedRegistration")
    elif request.form ['button'] == "Or Login":
        return redirect("/loginPage")
    else:
        return redirect ("/")
        
@app.route("/loginPage")
def loginTemplate():
    return render_template("PrettyLoginPage.html")

#login screen, must check if user is in system
@app.route("/loginPage", methods = ["POST", "GET"])
def login():
    username = request.form ['username']
    password = request.form ['password']
    if username not in userDict:
        return redirect("/")
    elif username in userDict and userDict[username][0] != password:
        return redirect("/loginPage")
    else:
        return redirect("/viewData")
        
#redirects the registration page to the finished registration page
@app.route("/finishedRegistration")
def finishedRegistration():
    return render_template("finishedRegistration.html")

#redirects the finished registration page to the enter portfolio screen
@app.route("/finishedRegistration", methods = ["POST", "GET"])
def Continue():
    return redirect("/enterPortfolioScreen")
    
#loads the enter portfolio template
@app.route("/enterPortfolioScreen")
def enterDataScreen():
    return render_template("EnterPortfolioInformation.html")

#retrieves the linkes and stores it with users
@app.route("/enterPortfolioScreen", methods = ["POST", "GET"])
def enterPortfolioData():
    global personalWebsite
    global github
    global linkedIn
    global facebook
    global skills
    personalWebsiteLink = request.form ["PersonalWebsite"]
    githubLink = request.form ["Github"]
    linkedInLink = request.form ["LinkedIn"]
    facebookLink = request.form ["Facebook"]
    skillsList = request.form ["Skills"]
    if personalWebsiteLink != "enter URL" and personalWebsiteLink != "":
        personalWebsite = personalWebsiteLink
    if githubLink != "enter URL" and githubLink != "":
        github = githubLink
    if linkedInLink != "enter URL" and linkedInLink != "":
        linkedIn = linkedInLink
    if facebookLink != "enter URL" and facebookLink != "":
        facebook = facebookLink
    if skillsList != "enter your skills" and skillsList != "":
        skills = skillsList
    print([personalWebsite, github, linkedIn, facebook, skills], file=sys.stderr)
    return redirect("/viewData")

@app.route("/viewData")
def viewData():
    return render_template("ViewPortfolioData.html")

@app.route("/viewData", methods=["POST", "GET"])
def clickEdit():
    return redirect("/enterPortfolioScreen")

if __name__ == '__main__':
    app.run(debug=True, host='128.237.173.66')

