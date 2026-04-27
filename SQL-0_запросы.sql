-- Задание 1
select    count(*) as cnt_row
        , count(id_user) as cnt_reg
        , count(distinct id_user) as cnt_user 
from skygame.users
select    id_user
	, count(*) as cnt
from skygame.users
group by id_user
having count(*) > 1
order by cnt desc

select   max(reg_date) as max_date
      , min(reg_date) as min_date
      , sum(case when reg_date is null then 1.0 else 0.0 end) as cnt_null
      , count(reg_date) as cnt_null_2 
from skygame.users

select    date_trunc('month',reg_date) as mm
	, count(id_user) as cnt
from skygame.users
group by mm
order by mm

-- Задание 2
select    date_trunc('month', start_session) as mm
        , count (*) as cnt_session_all
        , sum (case when end_session - start_session > interval '5 minute'
        then 1.0 else 0.0 end) as cnt_session_signif
        , sum(case when end_session - start_session > interval '5 minute'
        then 1.0 else 0.0 end) / count (*) as share_signif
from skygame.game_sessions
group by mm
order by mm 
---
select   date_trunc('month', start_session) as mm
        ,avg(end_session - start_session) as avg_len
from skygame.game_sessions
where end_session - start_session > interval '5 minute'
group by mm
order by mm 
---
select   date_trunc('month', start_session) as mm
        ,sum(case when end_session - start_session > interval '1 hour'
        then 1.0 else 0.0 end) / count(*) as share_long
from skygame.game_sessions
where end_session - start_session > interval '5 minute'
group by mm
order by mm

-- Задача 3
select    count(distinct id_user) as cnt_user
        , count(*) as cnt_ref 
        , sum(ref_reg) / count(*) as share_reg
from skygame.referral
---
select    id_user
        , count(*) as cnt_ref
from skygame.referral
group by id_user
order by cnt_ref desc
limit 50
---
select    id_user
        , count(*) as cnt_ref
        , sum(ref_reg)/count(*) as share_reg
from skygame.referral
group by id_user
having count(*) > 5
  and sum(ref_reg)/count(*) >= 0.5
  ---
select    id_user
        , count(*) as cnt_ref
        , sum(ref_reg)/count(*) as share_reg

from skygame.referral
group by id_user
having count(*) > 6 and sum(ref_reg)=0
