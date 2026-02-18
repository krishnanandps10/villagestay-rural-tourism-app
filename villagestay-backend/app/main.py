from fastapi import FastAPI
from app.routes import users
from app.db import supabase
from app.routes import submissions  # 👈 Import new route
from app.routes import bookings


app = FastAPI()

@app.get("/")
def read_root():
    response = supabase.table("users").select("*").limit(1).execute()
    return {
        "message": "Backend connected",
        "users_sample": response.data
    }

app.include_router(users.router)
app.include_router(submissions.router)  # 👈 Add this line
app.include_router(bookings.router)

