from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def home():
    return jsonify(
        application="AWS CI/CD DevOps Lab",
        status="running",
        version="1.0.0"
    )


@app.route("/health")
def health():
    return jsonify(status="unhealthy"), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)