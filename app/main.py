from fastapi import FastAPI
from app.models import models, database
from app.routers import users, catalog, orders

models.Base.metadata.create_all(bind=database.engine)

app = FastAPI()

app.include_router(users.router)
app.include_router(catalog.router)
app.include_router(orders.router)