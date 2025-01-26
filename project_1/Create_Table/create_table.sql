CREATE TABLE public.longitude_latitude_data 

(           state TEXT,
            latitude REAL,
            longitude REAL,
            customer_state TEXT PRIMARY KEY
);

CREATE TABLE public.ecommerce_data

(           customer_id TEXT,
            customer_first_name TEXT,
            customer_last_name TEXT,
            category_name TEXT,
            product_name TEXT,
            customer_segment TEXT,
            customer_city TEXT,
            customer_state TEXT,
            customer_country TEXT,
            customer_region TEXT,
            delivery_status TEXT,
            order_date DATE,
            order_id TEXT,
            ship_date DATE,
            shipping_type TEXT,
            days_for_shipment_scheduled INT,
            days_for_shipment_real INT,
            order_item_discount DECIMAL(10,2),
            sales_per_order DECIMAL(10,2),
            order_quantity INT,
            profit_per_order DECIMAL(10,2),
            PRIMARY KEY (customer_id,order_id),
            FOREIGN KEY (customer_state) REFERENCES public.longitude_latitude_data (customer_state) 
);



ALTER TABLE public.ecommerce_data OWNER TO postgres;
ALTER TABLE public.longitude_latitude_data  OWNER TO postgres; 

