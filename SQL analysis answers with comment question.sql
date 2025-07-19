-- 📚 Create tables
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(200),
    author VARCHAR(80),
    genre VARCHAR(200),
    published_year INT,
    price NUMERIC(10,2),
    stock INT
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(200),
    email VARCHAR(200),
    phone VARCHAR(20),
    city VARCHAR(60),
    country VARCHAR(150)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    book_id INT REFERENCES books(book_id),
    order_date DATE,
    quantity INT,
    total_amount NUMERIC(10,2)
);

-- ✅ Import check
SELECT * FROM books;
SELECT * FROM customers;
SELECT * FROM orders;

-- ===========================
-- 🟩 Basic questions
-- ===========================

-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM books
WHERE genre = 'Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM books
WHERE published_year > 1950;

-- 3) List all customers from Canada:
SELECT * FROM customers
WHERE country = 'Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stocks of books available:
SELECT SUM(stock) AS total_stock FROM books;

-- 6) Find details of the most expensive book:
SELECT * FROM books
ORDER BY price DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT DISTINCT c.*
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM orders
WHERE total_amount > 20;

-- 9) List all genres available in the books table:
SELECT DISTINCT genre FROM books;

-- 10) Find the book with lowest stock (excluding out of stock):
SELECT * FROM books
WHERE stock > 0
ORDER BY stock ASC
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) AS total_revenue FROM orders;

-- ===========================
-- 🟦 Advanced questions
-- ===========================

-- 1) Total number of books sold for each genre:
SELECT b.genre, SUM(o.quantity) AS total_books_sold
FROM books b
JOIN orders o ON b.book_id = o.book_id
GROUP BY b.genre;

-- 2) Average price of books in the Fantasy genre:
SELECT AVG(price) AS average_price
FROM books
WHERE genre = 'Fantasy';

-- 3) List customers who placed at least two orders:
SELECT c.customer_id, c.name, COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) >= 2;

-- 4) Find the most frequently ordered book:
SELECT b.title, COUNT(o.order_id) AS order_count
FROM books b
JOIN orders o ON b.book_id = o.book_id
GROUP BY b.title
ORDER BY order_count DESC
LIMIT 1;

-- 5) Top three most expensive books in Fantasy genre:
SELECT * FROM books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;

-- 6) Total quantity of books sold by each author:
SELECT b.author, SUM(o.quantity) AS total_quantity_sold
FROM books b
JOIN orders o ON b.book_id = o.book_id
GROUP BY b.author;

-- 7) List cities where customers who spent over $30 on any order are located:
SELECT DISTINCT c.city
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.total_amount > 30;

-- 8) Find the customer who spent the most on orders:
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;

-- 9) Calculate the stock remaining after fulfilled orders:
SELECT 
    b.book_id,
    b.title,
    b.stock,
    COALESCE(SUM(o.quantity), 0) AS total_quantity_sold,
    b.stock - COALESCE(SUM(o.quantity), 0) AS stock_remaining
FROM books b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id, b.title, b.stock;
