from fastapi import APIRouter
from app.db import supabase

router = APIRouter(prefix="/users", tags=["Users"])

@router.get("/")
def list_users():
    result = supabase.table("users").select("*").execute()
    return result.data

@router.post("/add")
def create_user(auth_id: str, role: str, phone_number: str):
    result = supabase.table("users").insert({
        "auth_id": auth_id,
        "role": role,
        "phone_number": phone_number
    }).execute()
    return {"status": "success", "inserted": result.data}
