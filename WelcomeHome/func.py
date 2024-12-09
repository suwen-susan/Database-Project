import mysql.connector
from flask import (
    Blueprint, flash, g, redirect, render_template, request, url_for, current_app, session
)
from datetime import datetime, timedelta
from .db import get_db
from flask_login import LoginManager, UserMixin
from flask_login import login_user, logout_user, current_user, login_required
from collections import defaultdict

def create_func_blueprint():
    bp = Blueprint('func', __name__, url_prefix='/func')
    
    @bp.route("/mainpage_client", methods = (["GET", "POST"]))
    def mainpage_client():
        if request.method == "GET":
            return render_template("func/mainpage_client.html")
        
    @bp.route("/mainpage_staff", methods = (["GET", "POST"]))
    def mainpage_staff():
        if request.method == "GET":
            return render_template("func/mainpage_staff.html")


    @bp.route('/find_order_items', methods=('GET', 'POST'))
    @login_required
    def find_order_items():
        items = defaultdict(list)
        error = None
        
        if request.method == 'POST':
            order_id = request.form['orderID']
            
            if not order_id:
                error = "Order ID is required."
            else:
                db = get_db()
                cursor = db.cursor(dictionary=True)

                # Query to find items and their locations for the given orderID
                if not is_staff(current_user):
                    query = """
                    SELECT 
                        i.ItemID,
                        i.iDescription AS ItemDescription,
                        i.mainCategory,
                        i.subCategory,
                        p.pieceNum,
                        p.pDescription AS PieceDescription,
                        p.roomNum,
                        p.shelfNum
                    FROM ItemIn ii
                    JOIN Item i ON ii.ItemID = i.ItemID
                    LEFT JOIN Piece p ON i.ItemID = p.ItemID
                    WHERE ii.orderID = %s AND p.shelfNum != -1;
                """
                
                else:
                    query = """
                        SELECT 
                            i.ItemID,
                            i.iDescription AS ItemDescription,
                            i.mainCategory,
                            i.subCategory,
                            p.pieceNum,
                            p.pDescription AS PieceDescription,
                            p.roomNum,
                            p.shelfNum
                        FROM ItemIn ii
                        JOIN Item i ON ii.ItemID = i.ItemID
                        LEFT JOIN Piece p ON i.ItemID = p.ItemID
                        WHERE ii.orderID = %s;
                    """
                cursor.execute(query, (order_id,))
                result = cursor.fetchall()
                print(result)
                cursor.close()

                if not result:
                    error = f"No items found for Order ID: {order_id}."

                else:
                    for row in result:
                        item_id = row['ItemID']
                        item_data = {
                            "ItemDescription": row['ItemDescription'],
                            "mainCategory": row['mainCategory'],
                            "subCategory": row['subCategory'],
                        }
                        piece_data = {
                            "pieceNum": row['pieceNum'],
                            "PieceDescription": row['PieceDescription'],
                            "roomNum": row['roomNum'],
                            "shelfNum": row['shelfNum']
                        }

                        if not items[item_id]:
                            items[item_id].append(item_data)
                        
                        items[item_id].append(piece_data)


        if error:
            flash(error)

        return render_template('func/find_order_items.html', items=items)
    
    @bp.route('/client_orders', methods=('GET',))
    @login_required
    def client_orders():
        if not current_user.is_authenticated:
            return redirect(url_for('auth.login'))  # Redirect to login if user is not logged in

        db = get_db()
        cursor = db.cursor(dictionary=True)

        # Query to fetch client orders
        query = """
            SELECT 
                o.orderID, 
                o.orderDate, 
                o.status 
            FROM Ordered as o
            WHERE o.client = %s
        """
        cursor.execute(query, (current_user.username,))
        client_orders = cursor.fetchall()

        cursor.close()

        return render_template(
            'func/client_orders.html', 
            client_orders=client_orders
        )
    

    @bp.route('/staff_orders', methods=('GET',))
    @login_required
    def staff_orders():
        if not current_user.is_authenticated:
            return redirect(url_for('auth.login'))  # Redirect to login if user is not logged in

        db = get_db()
        cursor = db.cursor(dictionary=True)

        # Query to fetch client orders
        query = """
            SELECT 
                o.orderID, 
                o.orderDate, 
                o.status 
            FROM Ordered as o
            WHERE o.client = %s
        """
        cursor.execute(query, (current_user.username,))
        client_orders = cursor.fetchall()

        # Query to fetch supervisor orders
        query = """
            SELECT 
                o.orderID, 
                o.orderDate, 
                o.status 
            FROM Ordered as o
            WHERE o.supervisor = %s
        """
        cursor.execute(query, (current_user.username,))
        supervisor_orders = cursor.fetchall()

        # Query to fetch volunteer orders
        query = """
            SELECT 
                o.orderID, 
                o.orderDate, 
                o.status 
            FROM Ordered as o
            Join Delivered as d on o.orderID = d.orderID
            WHERE d.userName = %s
        """
        cursor.execute(query, (current_user.username,))
        volunteer_orders = cursor.fetchall()

        cursor.close()


        return render_template(
            'func/staff_orders.html', 
            client_orders=client_orders, 
            supervisor_orders=supervisor_orders, 
            volunteer_orders=volunteer_orders
        )
    

    @bp.route('/update_status', methods=('GET', 'POST'))
    @login_required
    def update_status():
        if not current_user.is_authenticated:
            return redirect(url_for('auth.login'))  # Redirect to login if user is not logged in

        db = get_db()
        cursor = db.cursor(dictionary=True)

        if request.method == 'POST':
            order_id = request.form['orderID']
            new_status = request.form.get('status')
            error = None

            # check availability
            query = """
                SELECT *
                FROM Ordered as o
                WHERE o.supervisor = %s and o.orderID = %s
            """
            cursor.execute(query, (current_user.username,order_id))
            supervisor = cursor.fetchone()

            query = """
                SELECT *
                From Delivered as d
                WHERE d.userName = %s and d.orderID = %s
            """
            cursor.execute(query, (current_user.username,order_id))
            deliver = cursor.fetchone()

            if not supervisor or deliver:
                error = "You are not authorized to update the status of this order."

            if not new_status:
                error = 'New status is required.'

            if error:
                flash(error)
            else:
                try:
                    # Update the status in the database
                    query = """
                        UPDATE Ordered
                        SET status = %s WHERE orderID = %s
                    """
                    cursor.execute(query, (new_status, order_id))
                    db.commit()
                    flash("Order status updated successfully.")
                    # return redirect(url_for('orders.view_order', order_id=order_id))  # Redirect to a view page
                except mysql.connector.Error as error:
                    db.rollback()
                    flash(f"Database Error: {str(error)}")
                    
        cursor.close()

        return render_template('func/update_status.html')
    

    def is_staff(user):
        db = get_db()
        cursor = db.cursor()
        cursor.execute('SELECT roleID FROM Act WHERE userName = %s', (user.username,))
        roles = cursor.fetchall()
        return any(role[0] == 'staff' for role in roles)

    @bp.route('/accept', methods=['GET', 'POST'])
    @login_required
    def accept_donation():
        if not current_user.is_authenticated:
            return redirect(url_for('auth.login'))  # Redirect to login if user is not logged in
        
        if not is_staff(current_user):
            flash('You do not have permission to perform this action.')
            return redirect(url_for('auth.index'))
        
        if request.method == 'POST':
            donor_username = request.form['donor_username']
            db = get_db()
            cursor = db.cursor()
            
            # Check if donor is registered
            cursor.execute('SELECT * FROM Person WHERE userName = %s', (donor_username,))
            donor = cursor.fetchone()
            if not donor:
                flash('Donor is not registered.')
                return render_template('/accept.html')
            
            # Get item information
            iDescription = request.form['iDescription']
            color = request.form['color']
            isNew = request.form.get('isNew') == 'on'
            hasPieces = request.form.get('hasPieces') == 'on'
            material = request.form['material']
            mainCategory = request.form['mainCategory']
            subCategory = request.form['subCategory']
            
            try:
                # **Check if Category exists; insert if it doesn't**
                cursor.execute('''
                    SELECT * FROM Category WHERE mainCategory = %s AND subCategory = %s
                ''', (mainCategory, subCategory))
                category = cursor.fetchone()
                if not category:
                    cursor.execute('''
                        INSERT INTO Category (mainCategory, subCategory)
                        VALUES (%s, %s)
                    ''', (mainCategory, subCategory))
                    # Optionally handle 'catNotes' if needed
                
                # Insert item information
                cursor.execute(
                    '''
                    INSERT INTO Item (iDescription, color, isNew, hasPieces, material, mainCategory, subCategory)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                    ''',
                    (iDescription, color, isNew, hasPieces, material, mainCategory, subCategory)
                )
                item_id = cursor.lastrowid
                
                # Record donation information
                donateDate = datetime.now().date()
                cursor.execute(
                    '''
                    INSERT INTO DonatedBy (ItemID, userName, donateDate)
                    VALUES (%s, %s, %s)
                    ''',
                    (item_id, donor_username, donateDate)
                )
                
                # If item has pieces, get pieces information
                if hasPieces:
                    piece_nums = request.form.getlist('piece_num')
                    pDescriptions = request.form.getlist('pDescription')
                    lengths = request.form.getlist('length')
                    widths = request.form.getlist('width')
                    heights = request.form.getlist('height')
                    roomNums = request.form.getlist('roomNum')
                    shelfNums = request.form.getlist('shelfNum')
                    pNotes_list = request.form.getlist('pNotes')
                    for i in range(len(piece_nums)):
                        # Ensure the Location exists
                        cursor.execute('''
                            SELECT * FROM Location WHERE roomNum = %s AND shelfNum = %s
                        ''', (roomNums[i], shelfNums[i]))
                        location = cursor.fetchone()
                        if not location:
                            cursor.execute('''
                                INSERT INTO Location (roomNum, shelfNum)
                                VALUES (%s, %s)
                            ''', (roomNums[i], shelfNums[i]))
                        
                        cursor.execute(
                            '''
                            INSERT INTO Piece (ItemID, pieceNum, pDescription, length, width, height, roomNum, shelfNum, pNotes)
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                            ''',
                            (
                                item_id,
                                piece_nums[i],
                                pDescriptions[i],
                                lengths[i],
                                widths[i],
                                heights[i],
                                roomNums[i],
                                shelfNums[i],
                                pNotes_list[i]
                            )
                        )
                
                db.commit()
                flash('Donation accepted successfully.')
                return redirect(url_for('auth.index'))
            except mysql.connector.Error as e:
                db.rollback()
                flash(f"Database Error: {str(e)}")
        
        return render_template('func/accept.html')
    
    
    @bp.route('/prepare_order', methods=['GET', 'POST'])
    @login_required
    def prepare_order():
        if not current_user.is_authenticated:
            return redirect(url_for('auth.login'))  # Redirect to login if user is not logged in
        
        if not is_staff(current_user):
            flash('You do not have permission to perform this action.')
            return redirect(url_for('auth.index'))

        db = get_db()
        cursor = db.cursor()

        if request.method == 'POST':
            search_type = request.form.get('search_type')
            search_query = request.form.get('search_query')

            if search_type and search_query:
                if search_type == 'order_id':
                    cursor.execute('SELECT * FROM Ordered WHERE orderID = %s', (search_query,))
                elif search_type == 'client_username':
                    cursor.execute('SELECT * FROM Ordered WHERE client = %s', (search_query,))
                orders = cursor.fetchall()
            else:
                flash('Please enter a search query.')
                orders = []
            print(orders)

            return render_template('func/prepare_order.html', orders=orders)
        
        return render_template('func/prepare_order.html', orders=[])



    @bp.route('/update_location', methods=['POST'])
    @login_required
    def update_order_location():
        if not current_user.is_authenticated:
            return redirect(url_for('auth.login'))  # Redirect to login if user is not logged in
        
        if not is_staff(current_user):
            flash('You do not have permission to perform this action.')
            return redirect(url_for('auth.index'))
        
        order_id = request.form.get('order_id')
        print(order_id)
        print('update location')

        db = get_db()
        cursor = db.cursor(dictionary=True)
        
        query = """
            SELECT status FROM Ordered WHERE orderID = %s
        """
        cursor.execute(query, (order_id,))
        order_status = cursor.fetchone()
        order_status = order_status['status']

        if order_status == 'pending':
            flash("You need to confirm this order first")
            return redirect(url_for('func.start_order'))
        elif order_status == 'shipped' or order_status == 'complete' or order_status == 'returned':
            flash("The order has been shipped")
            return redirect(url_for('func.prepare_order'))
        else:
            try:
                cursor.execute('''
                    UPDATE Piece
                    SET roomNum = %s, shelfNum = %s
                    WHERE ItemID IN (SELECT ItemID FROM ItemIn WHERE orderID = %s);
                ''', (0, -1, order_id))

                cursor.execute('''
                    UPDATE Ordered
                    SET status = 'ready for delivery'
                    WHERE orderID = %s;
                ''', (order_id,))
                
                db.commit()
                flash(f'All items of order with OrderID {order_id}  have been moved to the holding location and order status has been updated.')
                return redirect(url_for('func.prepare_order'))
            
            except mysql.connector.Error as e:
                db.rollback()
                flash(f"Database Error: {str(e)}")

        return redirect(url_for('func.prepare_order'))

    @bp.route('/ranking', methods=['GET'])
    @login_required
    def view_rankings():
        if not current_user.is_authenticated:
            return redirect(url_for('auth.login'))  # Redirect to login if user is not logged in
        
        db = get_db()
        cursor = db.cursor()
        
        # Get the time period from query parameters, default to last 30 days
        days = request.args.get('days', 30, type=int)
        
        # Calculate the start date
        start_date = datetime.now() - timedelta(days=days)
        
        # Query to count tasks per staff within the time period
        cursor.execute('''
            SELECT supervisor, COUNT(*) as task_count
            FROM Ordered
            WHERE orderDate >= %s
            GROUP BY supervisor
            ORDER BY task_count DESC
        ''', (start_date,))
        
        rankings = cursor.fetchall()
        
        return render_template('func/ranking.html', rankings=rankings, days=days)
    
    @bp.route('/find_single_item', methods=('GET', 'POST'))
    @login_required
    def find_single_item():
        
        locations = []
        item_id = None
        error = None

        if request.method == 'POST':
            item_id = request.form.get('itemID')

            if not item_id:
                error = "Item ID is required."
            else:
                db = get_db()
                cursor = db.cursor(dictionary=True)
                
                if not is_staff(current_user):
                    cursor.execute('''
                        SELECT p.pieceNum, p.roomNum, p.shelfNum, l.shelfDescription, l.shelf
                        FROM Piece p
                        JOIN Location l ON (p.roomNum = l.roomNum AND p.shelfNum = l.shelfNum)
                        WHERE p.ItemID = %s AND p.shelfNum != -1;
                    ''', (item_id,))
                    locations = cursor.fetchall()
                else:
                    query = """
                        SELECT p.pieceNum, p.roomNum, p.shelfNum, l.shelfDescription, l.shelf
                        FROM Piece p
                        JOIN Location l ON (p.roomNum = l.roomNum AND p.shelfNum = l.shelfNum)
                        WHERE p.ItemID = %s
                    """
                    cursor.execute(query, (item_id,))
                    locations = cursor.fetchall()
                cursor.close()

        if error:
            flash(error)

        return render_template('func/find_single_item.html', locations=locations, item_id=item_id)
    

    
    @bp.route('/start_order', methods=('GET', 'POST'))
    @login_required
    def start_order():
        if not current_user.is_authenticated:
            return redirect(url_for('auth.login'))  # Redirect to login if user is not logged in
        
        if not is_staff(current_user):
            flash('You do not have permission to perform this action.')
            return redirect(url_for('auth.index'))
        
        db = get_db()
        cursor = db.cursor(dictionary=True)

        # Query to fetch pending orders
        query = """
            SELECT 
                o.orderID, 
                o.client,
                o.orderDate, 
                o.status
            FROM Ordered as o
            WHERE o.status = 'pending'
        """
        cursor.execute(query, ())
        pending_orders = cursor.fetchall()

        cursor.close()

        return render_template('func/start_order.html', pending_orders = pending_orders)
    
    @bp.route('/confirm_order', methods=('POST',))
    @login_required
    def confirm_order():
        if not current_user.is_authenticated:
            return redirect(url_for('auth.login'))  # Redirect to login if user is not logged in

        db = get_db()
        cursor = db.cursor()

        order_id = request.form.get('orderID')
        client_username = request.form.get('username')

        # Verify if the client exists in the database
        cursor.execute('SELECT * FROM person WHERE userName = %s', (client_username,))
        client = cursor.fetchone()

        if client is None:
            error = "Client {client_username} does not exist."
        else:
            try:
                # Update the order status
                query = """
                        UPDATE Ordered
                        SET status = "placed", supervisor = %s
                        WHERE orderID = %s
                    """
                cursor.execute(query, (current_user.username, order_id))
                
                db.commit()

                flash(f"Order {order_id} has been successfully confirmed.")
                return redirect(url_for('func.start_order'))

            except mysql.connector.Error as e:
                db.rollback()
                flash(f"Database Error: {str(e)}")
        
        cursor.close()

        if error:
            flash(error)

        return redirect(url_for('func.start_order'))

    @bp.route('/add_items', methods=['GET', 'POST'])
    @login_required
    def add_items():
        db = get_db()
        cursor = db.cursor(dictionary=True)

        if request.method == 'POST':
            item_id = request.form.get('itemID')
            if not item_id:
                flash("Please select an item.")
            else:
                if 'items' not in session:
                    session['items'] = []
                session['items'].append(item_id)
                flash("Item added to shopping bag.")
                return redirect(url_for('func.add_items'))  # Redirect back to selection page

        selected_items = session.get('items', [])

        # Fetch categories with available items
        if selected_items:
            cursor.execute("""
                SELECT DISTINCT c.mainCategory 
                FROM Category c
                JOIN Item i ON c.mainCategory = i.mainCategory AND c.subCategory = i.subCategory
                WHERE i.ItemID NOT IN (SELECT ItemID FROM ItemIn) AND i.ItemID NOT IN ({})
            """.format(",".join(["%s"] * len(selected_items))), selected_items)
        else:
            cursor.execute("""
                SELECT DISTINCT c.mainCategory 
                FROM Category c
                JOIN Item i ON c.mainCategory = i.mainCategory AND c.subCategory = i.subCategory
                WHERE i.ItemID NOT IN (SELECT ItemID FROM ItemIn)
            """)
        categories = cursor.fetchall()

        # Fetch subcategories based on selected category
        selected_category = request.args.get('category')
        subcategories = []
        if selected_category:
            if selected_items:
                cursor.execute("""
                    SELECT DISTINCT c.subCategory 
                    FROM Category c
                    JOIN Item i ON c.mainCategory = i.mainCategory AND c.subCategory = i.subCategory
                    WHERE i.ItemID NOT IN (SELECT ItemID FROM ItemIn) AND c.mainCategory = %s AND i.ItemID NOT IN ({})
                """.format(",".join(["%s"] * len(selected_items))), (selected_category,) + tuple(selected_items))
            else:
                cursor.execute("""
                    SELECT DISTINCT c.subCategory 
                    FROM Category c
                    JOIN Item i ON c.mainCategory = i.mainCategory AND c.subCategory = i.subCategory
                    WHERE i.ItemID NOT IN (SELECT ItemID FROM ItemIn) AND c.mainCategory = %s
                """, (selected_category,))
            subcategories = cursor.fetchall()

        # Fetch items based on selected subcategory
        selected_subcategory = request.args.get('subcategory')
        items = []
        if selected_subcategory:
            if selected_items:
                cursor.execute("""
                    SELECT i.ItemID, i.iDescription 
                    FROM Item i
                    WHERE i.ItemID NOT IN (SELECT ItemID FROM ItemIn) 
                    AND i.mainCategory = %s 
                    AND i.subCategory = %s
                    AND i.ItemID NOT IN ({})
                """.format(",".join(["%s"] * len(selected_items))), (selected_category, selected_subcategory) + tuple(selected_items))
            else:
                cursor.execute("""
                    SELECT i.ItemID, i.iDescription 
                    FROM Item i
                    WHERE i.ItemID NOT IN (SELECT ItemID FROM ItemIn) 
                    AND i.mainCategory = %s 
                    AND i.subCategory = %s
                """, (selected_category, selected_subcategory))
            items = cursor.fetchall()

        cursor.close()

        return render_template('func/add_items.html', categories=categories, subcategories=subcategories, items=items)


    @bp.route('/shopping_bag', methods=('GET', 'POST'))
    @login_required
    def shopping_bag():
        if not current_user.is_authenticated:
            return redirect(url_for('auth.login'))  # Redirect to login if user is not logged in

        item_ids = session['items']

        items = []
        if item_ids:
            db = get_db()
            cursor = db.cursor(dictionary=True)
            query = "SELECT ItemID, iDescription, mainCategory, subCategory FROM Item WHERE ItemID IN (%s)" % ",".join(map(str, item_ids))
            cursor.execute(query)
            items = cursor.fetchall()
            cursor.close()

        return render_template('func/shopping_bag.html', items=items)
    

    @bp.route('/place_order', methods=('POST',))
    @login_required
    def place_order():
        if not current_user.is_authenticated:
            return redirect(url_for('auth.login'))  # Redirect to login if user is not logged in
        
        notes = request.form.get('notes')

        if not session['items']:
            flash("Shopping bag is empty")
        else:
            db = get_db()
            cursor = db.cursor()

            try:
                # Insert new order
                cursor.execute("""
                    INSERT INTO Ordered (orderDate, orderNotes, status, client) VALUES (CURDATE(), %s, "pending", %s)
                """, (notes, current_user.username))
                order_id = cursor.lastrowid

                for item in session['items']:
                    # Insert into ItemIn
                    cursor.execute("""
                        INSERT INTO ItemIn (orderID, ItemID) VALUES (%s, %s)
                    """, (order_id, item))

                db.commit()
                flash('Successfully placed an order!')
                session['items'] = []
            except mysql.connector.Error as error:
                db.rollback()
                flash(f"Database Error: {str(error)}")

        return redirect(url_for('func.add_items'))
    

    @bp.route('/delete_item', methods=('POST',))
    @login_required
    def delete_item():
        if not current_user.is_authenticated:
            return redirect(url_for('auth.login'))  # Redirect to login if user is not logged in
        
        item_id = request.form.get('item_id')

        if not session['items']:
            flash("Shopping bag is empty")
        elif item_id in session['items']:
            session['items'].remove(item_id)
            flash(f"Item {item_id} removed from the shopping bag.")
        else:
            flash(f"Item {item_id} not found in the shopping bag.")

        return redirect(url_for('func.shopping_bag'))

    return bp



