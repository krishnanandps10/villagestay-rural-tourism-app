# app/routes/submissions.py

from fastapi import APIRouter
from app.db import supabase

router = APIRouter(prefix="/submissions", tags=["submissions"])

# Tourist: Get all approved listings
@router.get("/")
def get_approved_listings():
    response = supabase.table("community_submissions") \
        .select("*") \
        .eq("is_admin_approved", True) \
        .order("created_at", desc=True) \
        .execute()
    return {"approved_listings": response.data}

# Merchant: Submit new experience
@router.post("/")
def create_submission(submission: dict):
    response = supabase.table("community_submissions").insert(submission).execute()
    return {"message": "Submission created", "data": response.data}
