from flask import Flask, request, render_template
app = Flask(__name__)
    
@app.route('/')
def hello_world():
    return render_template("htmltest.html")


if __name__ == '__main__':
    app.run(debug=True, host='128.237.173.66')

#sudo lsof -i:5000