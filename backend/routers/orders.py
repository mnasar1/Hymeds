from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.models import models, database

router = APIRouter()

def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/orders/")
def place_order(user_id: int, medicine_id: int, quantity: int, db: Session = Depends(get_db)):
    order = models.Order(user_id=user_id, medicine_id=medicine_id, quantity=quantity)
    db.add(order)
    db.commit()
    db.refresh(order)
    return {"message": "Order placed successfully", "order_id": order.id}