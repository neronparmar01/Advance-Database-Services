#include <iostream>
#include <occi.h>
#include <cstdlib>

using oracle::occi::Environment;
using oracle::occi::Connection;
using namespace oracle::occi;
using namespace std;


// structure of the shopping cart
struct ShoppingCart {
	int product_id;
	double price;
	int quantity;
};


// function prototypes 
int mainMenu();
int customerLogin(Connection* conn, int customerId);
void displayOrderStatus(Connection* conn, int orderId, int customerId);
void cancelOrder(Connection* conn, int orderId, int customerId);
int subMenu();
int addToCart(Connection* conn, struct ShoppingCart cart[]);
double findProduct(Connection* conn, int product_id);
void displayProducts(struct ShoppingCart cart[], int productCount);
int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount);


// implementation of prototypes
int mainMenu() {
	int options = 0;
	do {
		cout << "******************** Main Menu ********************\n"
			<< "1)\tLogin\n" << "0)\tExit\n";

		if (options != 0 && options != 1) {
			cout << "You entered a wrong value.Enter an option(0 - 1): ";
		}
		else {
			cout << "Enter an option (0-1): ";
			cin >> options;
		}
	} while (options != 0 && options != 1);

	return options;
}

// adding to cart function
int addToCart(Connection* conn, struct ShoppingCart cart[]) {
	cout << "-------------- Add Products to Cart --------------" << endl;
	for (int i = 0; i < 5; i++) {
		int productId;
		int quantity;
		ShoppingCart item;
		int select;

		do {
			cout << "Enter the product ID: ";
			cin >> productId;
			if (findProduct(conn, productId) == 0) {
				cout << "The product does not exist. Try again..." << endl;
			}
		} while (findProduct(conn, productId) == 0);

		cout << "Product Proce: " << findProduct(conn, productId) << endl;
		cout << "Enter the product Quantity: ";
		cin >> quantity;

		item.product_id = productId;
		item.price = findProduct(conn, productId);
		item.quantity = quantity;
		cart[i] = item;

		if (i == 4)
			return i + 1;
		else {
			do {
				//if user wants to add more products or want to checkout
				cout << "Enter 1 to add more products or 0 to check out: ";
				cin >> select;
			} while (select != 0 && select != 1);
		}

		if (select == 0)
			return i + 1;
	}
}

// customer login implementation
int customerLogin(Connection* conn, int customerId) {
	Statement* stmnt = conn->createStatement();

	stmnt->setSQL("BEGIN find_customer(:1, :2); END;");
	int found;
	stmnt->setInt(1, customerId);
	stmnt->registerOutParam(2, Type::OCCIINT, sizeof(found));
	stmnt->executeUpdate();
	found = stmnt->getInt(2);

	conn->terminateStatement(stmnt);

	return found;
}

// finding the product implementation
double findProduct(Connection* conn, int product_id) {
	Statement* stmnt = conn->createStatement();

	stmnt->setSQL("BEGIN find_product(:1, :2); END;");
	double price;
	stmnt->setInt(1, product_id);
	stmnt->registerOutParam(2, Type::OCCIINT, sizeof(price));
	stmnt->executeUpdate();

	price = stmnt->getDouble(2);

	conn->terminateStatement(stmnt);
	if (price > 0) {
		return price;
	}
	else {
		return 0;
	}
}

// displaying the products 
void displayProducts(struct ShoppingCart cart[], int productCount) {
	if (productCount > 0) {
		double total_price = 0.0;
		cout << "------- Ordered Products ---------" << endl;
		for (int i = 0; i < productCount; i++) {
			cout << "---Item " << i + 1 << endl;
			cout << "Product ID: " << cart[i].product_id << endl;
			cout << "Price: " << cart[i].price << endl;
			cout << "Quantity: " << cart[i].quantity << endl;
			total_price += cart[i].price * cart[i].quantity;
 		}
		cout << "----------------------------------\nTotal: " << total_price << endl;
	}
}

int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount) {
	char selection;
	do {
		cout << "Would you like to checkout? (Y/y or N/n) ";
		cin >> selection;

		if (selection != 'Y' && selection != 'y' && selection != 'N' && selection != 'n') {
			cout << "Wrong input. Try again..." << endl;
		}
	} while (selection != 'Y' && selection != 'y' && selection != 'N' && selection != 'n');

	if (selection == 'N' && selection == 'n') {
		cout << "The order is cancelled." << endl;
		return 0;
	}
	else {
		Statement* stmnt = conn->createStatement();
		stmnt->setSQL("BEGIN add_order(:1, :2); END;");
		int next_order_id;
		stmnt->setInt(1, customerId);
		stmnt->registerOutParam(2, Type::OCCIINT, sizeof(next_order_id));

		stmnt->executeUpdate();

		next_order_id = stmnt->getInt(2);

		for (int i = 0; i < productCount; i++) {
			stmnt->setSQL("BEGIN add_order_item(:1, :2, :3, :4, :5); END;");
			
			stmnt->setInt(1, next_order_id);
			stmnt->setInt(2, i + 1);
			stmnt->setInt(3, cart[i].product_id);
			stmnt->setInt(4, cart[i].quantity);
			stmnt->setDouble(5, cart[i].price);

			stmnt->executeUpdate();
		}

		cout << "The order is successfully completed." << endl;

		conn->terminateStatement(stmnt);

		return 1;
	}
}

// for displaying the order status
void displayOrderStatus(Connection* conn, int orderId, int customerId) {
	Statement* stmnt = conn->createStatement();

	stmnt->setSQL("BEGIN customer_order(:1, :2, :3); END;");
	stmnt->setInt(1, customerId);
	stmnt->setInt(2, orderId);
	stmnt->registerOutParam(3, Type::OCCIINT, sizeof(int));
	stmnt->executeUpdate();

	int isValid = stmnt->getInt(3);

	if (isValid == 0) {
		cout << "Order ID is not valid." << endl;
	}
	else {
		stmnt->setSQL("BEGIN display_order_status(:1, :2, :3); END;");
		stmnt->setInt(1, orderId);
		stmnt->registerOutParam(2, Type::OCCIINT, sizeof(int));
		stmnt->executeUpdate();

		int orderStatus = stmnt->getInt(2);

		if (orderStatus == 0) {
			cout << "Order does not exist." << endl;
		}
		else {
			cout << "Order is ";

			switch (orderStatus) {
			case 1:
				cout << "placed." << endl;
				break;
			case 2:
				cout << "shipped." << endl;
				break;
			case 3:
				cout << "delivered." << endl;
				break;
				// Add more cases as needed
			default:
				cout << "in an unknown status." << endl;
			}
		}
	}
	conn->terminateStatement(stmnt);
}

// cancel order implementation
void cancelOrder(Connection* conn, int orderId, int customerId) {
	Statement* stmnt = conn->createStatement();

	stmnt->setSQL("BEGIN customer_order(:1, :2, :3); END;");
	stmnt->setInt(1, customerId);
	stmnt->setInt(2, orderId);
	stmnt->registerOutParam(3, Type::OCCIINT, sizeof(int));
	stmnt->executeUpdate();

	int isValidOrder = stmnt->getInt(3);

	if (isValidOrder == 0) {
		cout << "Order ID is not valid." << endl;
	}
	else {
		stmnt->setSQL("BEGIN cancel_order(:1, :2); END;");
		stmnt->setInt(1, orderId);
		stmnt->registerOutParam(2, Type::OCCIINT, sizeof(int));
		stmnt->executeUpdate();

		int isOrderCancelled = stmnt->getInt(2);

		if (isOrderCancelled == 1) {
			cout << "Order is canceled." << endl;
		}
		else {
			cout << "Order does not exist." << endl;
		}
	}
	conn->terminateStatement(stmnt);
}

// submenu implementation
int subMenu() {
	int option;

	do {
		cout << "******************** Customer Service Menu ********************\n"
			<< "1) Place an order\n"
			<< "2) Check an order status\n"
			<< "3) Cancel an order\n"
			<< "0) Exit\n"
			<< "Enter an option (0-3): ";

		cin >> option;

		if (option < 0 || option > 3) {
			cout << "Invalid option. Please try again." << endl;
		}

	} while (option < 0 || option > 3);

	return option;
}


// main fucntion
int main(void) {
	Environment* env = nullptr;
	Connection* conn = nullptr;

	string str;
	string user = "dbs311_233zbb21";
	string pass = "53291817";
	string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";


	try {
		env = Environment::createEnvironment(Environment::DEFAULT);
		conn = env->createConnection(user, pass, constr);

		// variables for storing the information of customers
		int choose;
		int customerId;
		do {
			choose = mainMenu();

			if (choose == 1) {
				cout << "Enter the customer ID: ";
				cin >> customerId;

				if (customerLogin(conn, customerId) == 0) {
					cout << "The customer does not exist." << endl;
				}
				else {
					ShoppingCart cart[5];
					int count = addToCart(conn, cart);
					displayProducts(cart, count);
					checkout(conn, cart, customerId, count);
				}
			}
		} while (choose != 0);

		cout << "Connection is Successful!\n\n" << endl;


		cout << "Good bye!..." << endl;
		env->terminateConnection(conn);
		Environment::terminateEnvironment(env);

	}
	catch(SQLException& sqlExcp){
		cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
	}

	return 0;
}