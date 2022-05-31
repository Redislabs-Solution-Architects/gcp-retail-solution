import os
import pymysql
from app import app
from db_config import mysql
from flask import flash, session, render_template, request, redirect, url_for
from werkzeug.security import generate_password_hash, check_password_hash


@app.template_filter()
def currencyFormat(value):
	value = float(value)
	return "${:,.2f}".format(value)

@app.route('/add', methods=['POST'])
def add_product_to_cart():
	cursor = None
	try:
		_quantity = int(request.form['quantity'])
		_code = request.form['code']
		if _quantity and _code and request.method == 'POST':
			conn = mysql.connect()
			cursor = conn.cursor(pymysql.cursors.DictCursor)
			cursor.execute("SELECT * FROM product WHERE code=%s", _code)
			row = cursor.fetchone()
			
			itemArray = { row['code'] : {'name' : row['name'], 'code' : row['code'], 'quantity' : _quantity, 'price' : row['price'], 'image' : row['image'], 'total_price': _quantity * row['price']}}
			
			sub_total_price = 0
			sub_total_quantity = 0
			
			session.modified = True
			if 'cart_item' in session:
				if row['code'] in session['cart_item']:
					for key, value in session['cart_item'].items():
						if row['code'] == key:
							current_quantity = session['cart_item'][key]['quantity']
							total_quantity = current_quantity + _quantity
							session['cart_item'][key]['quantity'] = total_quantity
							session['cart_item'][key]['total_price'] = total_quantity * row['price']
				else:
					session['cart_item'] = array_merge(session['cart_item'], itemArray)

				for key, value in session['cart_item'].items():
					individual_quantity = int(session['cart_item'][key]['quantity'])
					individual_price = float(session['cart_item'][key]['total_price'])
					sub_total_quantity = sub_total_quantity + individual_quantity
					sub_total_price = sub_total_price + individual_price
			else:
				session['cart_item'] = itemArray
				sub_total_quantity = sub_total_quantity + _quantity
				sub_total_price = sub_total_price + _quantity * row['price']
			
			session['sub_total_quantity'] = sub_total_quantity
			session['sub_total_price'] = sub_total_price
			
			return redirect(url_for('.products'))
		else:			
			return 'Error while adding item to cart'
	except Exception as e:
		print(e)
	finally:
		cursor.close() 
		conn.close()
		
@app.route('/')
def products():
	try:
		conn = mysql.connect()
		cursor = conn.cursor(pymysql.cursors.DictCursor)
		cursor.execute("SELECT * FROM product order by code, name ASC")
		rows = cursor.fetchall()
		gcp_region = os.environ.get("GCPREGION", "Undefined")
		return render_template('products.html', products=rows, gcp_region=gcp_region)
	except Exception as e:
		print(e)
	finally:
		cursor.close() 
		conn.close()

@app.route('/empty')
def empty_cart():
	try:
		session.clear()
		return redirect(url_for('.products'))
	except Exception as e:
		print(e)

@app.route('/delete/<string:code>')
def delete_product(code):
	try:
		sub_total_price = 0
		sub_total_quantity = 0
		session.modified = True
		
		for item in session['cart_item'].items():
			if item[0] == code:				
				session['cart_item'].pop(item[0], None)
				if 'cart_item' in session:
					for key, value in session['cart_item'].items():
						individual_quantity = int(session['cart_item'][key]['quantity'])
						individual_price = float(session['cart_item'][key]['total_price'])
						sub_total_quantity = sub_total_quantity + individual_quantity
						sub_total_price = sub_total_price + individual_price
				break
		
		if sub_total_quantity == 0:
			session.clear()
		else:
			session['sub_total_quantity'] = sub_total_quantity
			session['sub_total_price'] = sub_total_price
		
		#return redirect('/')
		return redirect(url_for('.products'))
	except Exception as e:
		print(e)
		
def array_merge( first_array , second_array ):
	if isinstance( first_array , list ) and isinstance( second_array , list ):
		return first_array + second_array
	elif isinstance( first_array , dict ) and isinstance( second_array , dict ):
		return dict( list( first_array.items() ) + list( second_array.items() ) )
	elif isinstance( first_array , set ) and isinstance( second_array , set ):
		return first_array.union( second_array )
	return False		
		
if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
