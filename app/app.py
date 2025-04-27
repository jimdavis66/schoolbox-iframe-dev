from flask import Flask, request, render_template, jsonify
import hashlib
import time
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = Flask(__name__)

# Get the shared secret from environment variable
SHARED_SECRET = os.getenv('SCHOOLBOX_SHARED_SECRET')

def verify_schoolbox_auth(key, timestamp, user_id, username):
    """
    Verify the Schoolbox authentication parameters
    """
    # Check if timestamp is within 5 minutes
    current_time = int(time.time())
    if abs(current_time - int(timestamp)) > 300:  # 300 seconds = 5 minutes
        return False
    
    # Generate the expected key
    expected_key = hashlib.sha1(
        f"{SHARED_SECRET}{timestamp}{user_id}".encode()
    ).hexdigest()
    
    return key == expected_key

@app.route('/')
def index():
    # Get authentication parameters from Schoolbox
    key = request.args.get('key')
    timestamp = request.args.get('time')
    user_id = request.args.get('id')
    username = request.args.get('user')
    
    # Verify authentication
    if not all([key, timestamp, user_id, username]):
        return "Missing authentication parameters", 401
    
    if not verify_schoolbox_auth(key, timestamp, user_id, username):
        return "Invalid authentication", 401
    
    # If authenticated, render the main page
    return render_template('index.html', username=username)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=os.getenv('APP_PORT', 3000)) 