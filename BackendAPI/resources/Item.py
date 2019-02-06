from flask import request
from flask_restful import Resource
from Model import db, Item, ItemSchema

items_schema = ItemSchema(many=True)
item_schema = ItemSchema()

# Items manipulation model

class ItemsResource(Resource):

    # GET Method

    def get(self):
        items = Item.query.all()
        items = items_schema.dump(items).data
        return {'status': 'success', 'data': items}, 200


    # POST Method

    def post(self):
        json_data = request.get_json(force=True)
        
        if not json_data:
               return {'message': 'No input data provided'}, 400

        # Validate and deserialize input
        data, errors = item_schema.load(json_data)
 
        if errors:
            return errors, 422

        item = Item.query.filter_by(name=data['name']).first()

        if item:
            return {'message': 'Item with that name already exists'}, 400

        item = Item(
            name=json_data['name'], 
            cost=json_data['cost'], 
            url=json_data['url'], 
            comment=json_data['comment']
        )

        db.session.add(item)
        db.session.commit()

        result = item_schema.dump(item).data

        return { "status": 'success', 'data': result }, 201


    # PUT Method

    def put(self):
        json_data = request.get_json(force=True)

        if not json_data:
               return {'message': 'No input data provided'}, 400

        # Validate and deserialize input
        data, errors = item_schema.load(json_data)

        if errors:
            return errors, 422

        item = Item.query.filter_by(id=data['id']).first()
        
        if not item:
            return {'message': 'Item does not exist'}, 400

        if data.get('name'):
            item.name = data['name']
        if data.get('cost'):
            item.cost = int(data['cost'])
        if data.get('url'):
            item.url = data['url']
        if data.get('comment'):
            item.comment = data['comment']

        db.session.commit()
        result = item_schema.dump(item).data
        
        return { "status": 'success', 'data': result }, 204


    # DELETE method

    def delete(self):
        json_data = request.get_json(force=True)

        if not json_data:
               return {'message': 'No input data provided'}, 400

        # Validate and deserialize input
        data, errors = item_schema.load(json_data)

        if errors:
            return errors, 422

        item = Item.query.filter_by(id=data['id']).delete()
        db.session.commit()
        result = item_schema.dump(item).data

        return { "status": 'success', 'data': result}, 204