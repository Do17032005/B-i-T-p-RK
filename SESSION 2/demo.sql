-- 1. Xây dựng Bảng Users (Bên "Một" của Orders)

CREATE TABLE Users (

    id BIGSERIAL PRIMARY KEY,

    username VARCHAR(50) NOT NULL UNIQUE, 

    email VARCHAR(255) NOT NULL UNIQUE,

    password_hash TEXT NOT NULL, 

    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() 

);

 

-- 2. Xây dựng Bảng Products (Một phần của quan hệ N:N)

CREATE TABLE Products (

    id BIGSERIAL PRIMARY KEY,

    name VARCHAR(255) NOT NULL,

    description TEXT,

    price NUMERIC(10, 2) NOT NULL, -- Kiểu số chính xác cho tiền tệ

    stock_quantity INT DEFAULT 0

);

 

-- 3. Xây dựng Bảng Orders (Bên "Nhiều" của Users)

CREATE TABLE Orders (

    id BIGSERIAL PRIMARY KEY,

    order_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    total_amount NUMERIC(12, 2) DEFAULT 0,

    

    -- Khóa Ngoại (Foreign Key) liên kết đến bảng Users

    user_id BIGINT NOT NULL REFERENCES Users(id) 

);

 

-- 4. Xây dựng Bảng Order_Details (Bảng Trung Gian cho N:N)

CREATE TABLE Order_Details (

    

    -- Khóa Ngoại liên kết đến Orders

    order_id BIGINT NOT NULL REFERENCES Orders(id),

    

    -- Khóa Ngoại liên kết đến Products

    product_id BIGINT NOT NULL REFERENCES Products(id),

    

    -- Thuộc tính riêng của mối quan hệ

    quantity INT NOT NULL CHECK (quantity > 0), -- Ràng buộc CHECK đảm bảo số lượng > 0

    price_at_purchase NUMERIC(10, 2) NOT NULL, 

    

    -- Thiết lập Khóa Chính kép để đảm bảo tính duy nhất

    PRIMARY KEY (order_id, product_id)

);