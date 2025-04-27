# Schoolbox iframe Integration

This is a Flask application that can be used to test the integration into Schoolbox via an iframe with authentication.

## Setup

### Local Development

1. Navigate to the app directory:
```bash
cd app
```

2. Install the required dependencies:
```bash
pip install -r requirements.txt
```

3. Create a `.env` file in the app directory with your Schoolbox shared secret:
```
SCHOOLBOX_SHARED_SECRET=your_shared_secret_here
APP_PORT=3000
```

4. Run the application:
```bash
python app.py
```

### Docker Deployment

1. Build the Docker image:
```bash
docker build -t schoolbox-iframe .
```

2. Create a `.env` file in the app directory with your Schoolbox shared secret:
```
SCHOOLBOX_SHARED_SECRET=your_shared_secret_here
APP_PORT=3000
```

3. Run the container:
```bash
docker compose up -d
```

## Schoolbox Integration

To integrate this application into Schoolbox:

1. Base64 encode your application URL (e.g., `http://your-server:3000/`)
2. Use the following format in Schoolbox:
   ```
   http://schoolbox/modules/remote/{base64encodedURL}
   ```

### Optional Parameters

- Add `/window` to open in a new window instead of an iframe
- Add `#zx_h=800px` to control the iframe height

## Security

The application verifies:
- The timestamp is within 5 minutes of the current time
- The authentication key matches the expected SHA1 hash of the shared secret, timestamp, and user ID
