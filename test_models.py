import os
from google import genai

# Set API key
API_KEY = "AIzaSyBt_Joe6w0wa2RrqpSODWvz6ViErGJyPic"
os.environ['GOOGLE_API_KEY'] = API_KEY

client = genai.Client(api_key=API_KEY)

print("Available models:")
print("-" * 50)

try:
    models = client.models.list()
    for model in models:
        print(f"* {model.name}")
        print(f"   Display Name: {getattr(model, 'display_name', 'N/A')}")
        print()
except Exception as e:
    print(f"Error: {e}")
