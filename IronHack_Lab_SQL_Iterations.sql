-- Question 1
SELECT DISTINCT
    b.store_id, ROUND(SUM(a.amount), 0) AS total_business
FROM
    payment a
        JOIN
    customer b USING (customer_id)
GROUP BY 1;

-- Question 2
delimiter // 
create procedure total_business()
begin 
	select store_id    
    , ROUND(SUM(p.amount), 0) AS total_business
	from payment p
	join customer using (customer_id)
	group by store_id;
end
// delimiter ;

call total_business();

-- Question 3
DELIMITER //
create procedure total_per_store(in store_id int,out total_amout float)
begin
	select s.store_id,sum(p.amount) as total_business from payment p
	join staff s on s.staff_id = p.staff_id
	group by s.store_id
	having s.store_id = store_id;
 end //
DELIMITER ;

call total_per_store(2, @total_sales_value);

-- Question 4
DELIMITER //
create procedure total_per_store_var(in store_id int)
begin
	declare total_sales_value float;
	select sum(p.amount) into total_sales_value
    from payment p
	join staff s on s.staff_id = p.staff_id
	group by s.store_id
	having s.store_id = store_id;
    select total_sales_value; 
 end //
DELIMITER ;
call total_per_store_var(2);


-- Question 5 
DELIMITER //
create procedure total_per_store_var_flag(in store_id int)
begin
	declare total_sales_value float;
    declare flag varchar(10) default "";
	select sum(p.amount) into total_sales_value
    from payment p
	join staff s on s.staff_id = p.staff_id
	group by s.store_id
	having s.store_id = store_id;
    
    if total_sales_value >= 30000 then
		set flag = 'Green';
	else
		set flag = 'Red';
	end if;
      
    select total_sales_value, flag; 
 end //
DELIMITER ;
call total_per_store_var_flag(2);
