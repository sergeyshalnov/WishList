from flask import Flask
from marshmallow import Schema, fields, pre_load, validate
from flask_marshmallow import Marshmallow
from flask_sqlalchemy import SQLAlchemy


ma = Marshmallow()
db = SQLAlchemy()


class Item(db.Model):
    __tablename__ = 'items'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False)
    cost = db.Column(db.Integer, nullable=False)
    url = db.Column(db.String(250), nullable=False)
    comment = db.Column(db.String(250), nullable=False)
    creation_date = db.Column(db.TIMESTAMP, server_default=db.func.current_timestamp(), nullable=False)

    def __init__(self, name, cost, url, comment):
        self.name = name
        self.cost = cost
        self.url = url
        self.comment = comment
        

class ItemSchema(ma.Schema):
    id = fields.Integer()
    name = fields.String(required=True)
    cost = fields.Integer(required=True)
    url = fields.String(required=True)
    comment = fields.String(required=True)
    creation_date = fields.DateTime()

