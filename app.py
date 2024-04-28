from flask import Flask
from flask import render_template
from requests import get, Response

app = Flask(__name__)


@app.route("/")
def index() -> str:
    return render_template("index.html")
    
@app.route("/beacon")
def beacon() -> str:
    response: Response = get("https://beacon.nist.gov/beacon/2.0/pulse/last")
    result: dict = response.json()
    output_value: str = result["pulse"]["outputValue"]
    output_split_in_pairs: list = [output_value[i:i+2] for i in range(0, len(output_value), 2)]
    colors: list = [f"#"+pair*3 for pair in output_split_in_pairs]
    return render_template("beacon.html", colors=colors, output_value=output_value)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
