--ÇÀÄÀÍÈÅ 1

select    date_trunc('month',dtime_pay) as mm
       	 , type
	 , sum(cnt_buy * price) as revenue
from skygame.monetary m
   join skygame.item_list i
      	on m.id_item_buy = i.id_item
   join skygame.log_prices p
on m.id_item_buy = p.id_item
      and m.dtime_pay >= p.valid_from
      and m.dtime_pay <= coalesce(valid_to, to_date('01/01/3000', 'DD/MM/YYYY'))
group by   mm
         , type
order by mm


--ÇÀÄÀÍÈÅ 2
select    date_trunc('month',dtime_pay) as mm
	, avg(cnt_buy) as cnt
	, sum(cnt_buy * price) as revenue
from skygame.monetary m
   join skygame.item_list i
      	on m.id_item_buy = i.id_item
   join skygame.log_prices p
      on m.id_item_buy = p.id_item
     	 and m.dtime_pay >= p.valid_from
     	 and m.dtime_pay <= coalesce(valid_to, to_date('01/01/3000', 'DD/MM/YYYY'))
where name_item = 'Crystal'
group by mm
order by mm

-- ÇÀÄÀÍÈÅ 3

select  *
        , extract('day' from (to_date('28/04/2023', 'DD/MM/YYYY') - mm) / 30) as interv
        , avg_rev / (extract('day' from ((select max(dtime_pay) from skygame.monetary) - mm) / 30)) as avg_rev_per_month
from (
      select    date_trunc('month', reg_date) as mm
       		 , sum(cnt_buy * price) as revenue
      		  , count(distinct m.id_user) as cnt
     		  , sum(cnt_buy * price) / count(distinct m.id_user) as avg_rev
from skygame.monetary m
         join skygame.log_prices p
			  on m.id_item_buy = p.id_item
     			 and m.dtime_pay >= p.valid_from
     			 and m.dtime_pay <= coalesce(valid_to, to_date('01/01/3000', 'DD/MM/YYYY'))
  		 join skygame.users u
    			  on m.id_user = u.id_user
      where reg_date < (select max(dtime_pay) - interval '1 month' from skygame.monetary)
      group by mm
      order by mm
     	 ) t
