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

@router.get("/catalog/")
def list_medicines(db: Session = Depends(get_db)):
    medicines = db.query(models.Medicine).all()
    return medicines