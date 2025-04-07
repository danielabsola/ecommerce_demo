/*
Nota: Para resolver los puntos 1 y 2 requeridos mi idea fue ir trabajando con CTEs que permitan
manipular un universo de menor volumen de datos requeridos temporalmente provenientes 
de tablas que pueden estar almacenando grandes volumnes de datos.
Una vez hecho estos CTEs realizo los joins con los datos acotados.  
*/

/*
1.Listar los usuarios que cumplan años el día de hoy cuya cantidad de ventas 
realizadas en enero 2020 sea superior a 1500.
*/
WITH users AS (
    SELECT customer_id
    , desc_first_name
    , desc_last_name
    FROM public.customers
    WHERE EXTRACT('month' from birthdate) = EXTRACT('month' from CURRENT_DATE)
    AND EXTRACT('day' from birthdate) = EXTRACT('day' from CURRENT_DATE)
), 
sales_1_2020 AS (
    SELECT order_date
    , order_id
    , customer_id_seller
    , item_id
    , quantity
    FROM public.orders o 
    WHERE EXTRACT('year' from o.order_date) = 2020
    AND EXTRACT('month' from o.order_date) = 1 
),
users_sales AS (
    SELECT u.customer_id
    , u.desc_first_name
    , u.desc_last_name
    , sum(s.quantity * i.unit_amount) AS sales_amount
    FROM public.users u
    INNER JOIN public.items i ON u.customer_id = i.customer_id_seller
    INNER JOIN sales_1_2020 s ON s.item_id = i.item_id 
    GROUP BY 1, 2, 3
    HAVING sum(s.quantity * i.unit_price)>1500
    ORDER BY 4 DESC
)
select * from users_sales;
/*
For each month of 2020, list the top 5 users who sold the most ($) in the Mobile Phones 
category. The analysis requires month and year, seller's first and last name, number of 
sales made, quantity of products sold and the total amount transacted. For each month 
of 2020, list the top 5 users who sold the most ($) in the Mobile Phones category. The 
analysis requires month and year, seller's first and last name, number of sales made, 
quantity of products sold and the total amount transacted.
*/
WITH category_phones AS (
    SELECT s.category_id
    , s.cat_fst_id
    , s.cat_snd_id
    FROM public.categories_master m 
    INNER JOIN public.subcategories_second_level f ON m.category_id = f.category_id
    INNER JOIN public.subcategories_second_level s ON f.cat_fst_id = s.cat_fst_id
    WHERE m.desc_category LIKE '%Tecnología%'
    AND f.desc_category LIKE '%Celulares%'
    AND (s.desc_category LIKE '%Celulares%' OR s.desc_category LIKE '%Smartphones%')
),
sales_2020 AS (
    SELECT order_date
    , item_id
    , order_id
    , quantity
    FROM public.orders
    WHERE EXTRACT('year' from o.order_date) = 2020
),
sales_phones_2020 AS (
    SELECT s.order_date
    , i.item_id
    , i.customer_id_seller
    , i.unit_amount
    , s.order_id
    , s.quantity
    FROM public.items i 
    INNER JOIN category_phones cp ON i.category_id = cp.category_id
                                AND i.cat_fst_id = cp.cat_fst_id
                                AND i.cat_snd_id = cp.cat_snd_id
    INNER JOIN sales_2020 s ON i.item_id = s.item_id
),
top_5_users_sales_phones AS (
    SELECT EXTRACT('year' from sp.order_date) AS year
    , EXTRACT('month' from sp.order_date) AS month
    , c.customer_id
    , c.desc_first_name
    , c.desc_last_name
    , count(sp.order_id) AS quantity_orders
    , sum(sp.quantity) AS quantity_products
    , sum(sp.quantity * i.unit_amount) AS sales_amount
    FROM public.customers c
    INNER JOIN sales_phones_2020 sp ON c.customer_id = sp.customer_id_seller
    GROUP BY 1, 2, 3, 4, 5
    ORDER BY 8 DESC
    LIMIT 5 
)
select * from top_5_users_sales_phones;
/*
Population of a new table with the price and status of the Items at the end of the day. 
Consider that it must be reprocessable. It should be noted that in the Item table, we will 
only have the last status reported by the defined PK. 
*/
CREATE OR REPLACE PROCEDURE public.sp_bkp_items_daily(run_date Date)
LANGUAGE 'plpgsql' /* o LANGUAGE SQL*/
AS $BODY$ 
DECLARE
BEGIN /* o BEGIN ATOMIC si usamos LANGUAGE SQL */
    DELETE FROM public.items_bkp_daily WHERE date_bkp = run_date;
    INSERT INTO public.items_bkp_daily(date_bkp, item_id, status_id, unit_amount)
    SELECT run_date, item_id, statua_id, unit_amount FROM public.items;
END;
$BODY$;

/* SELECT * FROM public.items_bkp_daily WHERE date_bkp = run_date; */

/* CALL public.sp_bkp_items_daily('2024-03-15'); */
