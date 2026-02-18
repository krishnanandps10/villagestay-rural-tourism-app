# app/routes/bookings.py

from fastapi import APIRouter, Query
from app.db import supabase

router = APIRouter(prefix="/bookings", tags=["bookings"])

# Tourist: Create a booking
@router.post("/")
def create_booking(booking: dict):
    response = supabase.table("bookings").insert(booking).execute()
    return {"message": "Booking created", "data": response.data}

# Tourist: View their own bookings
@router.get("/tourist")
def get_bookings_by_user(user_id: str = Query(...)):
    response = supabase.table("bookings").select("*").eq("user_id", user_id).execute()
    return {"your_bookings": response.data}

# Merchant: View bookings for their submissions
@router.get("/merchant")
def get_bookings_for_merchant(user_id: str = Query(...)):
    # Step 1: Get submission IDs owned by this merchant
    submissions = supabase.table("community_submissions") \
        .select("id") \
        .eq("user_id", user_id) \
        .execute()

    submission_ids = [sub["id"] for sub in submissions.data]

    if not submission_ids:
        return {"message": "No submissions found for this merchant", "bookings": []}

    # Step 2: Fetch bookings for those submissions
    response = supabase.table("bookings") \
        .select("*") \
        .in_("submission_id", submission_ids) \
        .execute()

    return {"bookings_for_your_listings": response.data}
