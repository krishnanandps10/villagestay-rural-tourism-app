from supabase import create_client, Client
from dotenv import load_dotenv
import os

# Load environment variables from .env
load_dotenv()

# Read from environment
SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_SERVICE_KEY = os.getenv("SUPABASE_SERVICE_KEY")

# Create Supabase client
supabase: Client = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)
