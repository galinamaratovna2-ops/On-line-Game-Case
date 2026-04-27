with crit_invite as
( select id_user
from skygame.referral
group by id_user
having count (*) >= 3 and
       sum (ref_reg) >= 1
)

select date_trunc ('month', start_session) mm
      , count (distinct id_user) lmau_inv
from skygame.game_sessions
where id_user in (select * from crit_invite)
group by mm
order by mm

with crit_1000 as
(select id_user
from skygame.monetary m
    join skygame.log_prices p
    on m.id_item_buy = p.id_item
where dtime_pay >= valid_from and dtime_pay < coalesce (valid_to, '3000-01-01')
group by id_user
having sum (m.cnt_buy * p.price) >= 1000
)

select date_trunc ('month', start_session) mm
      , count (distinct id_user) lmau_1000
from skygame.game_sessions
where id_user in (select * from crit_1000)
group by mm
order by mm

with crit_invite as
( select id_user
from skygame.referral
group by id_user
having count (*) >= 3 and
       sum (ref_reg) >= 1
),

crit_1000 as
(select id_user
from skygame.monetary m
    join skygame.log_prices p
    on m.id_item_buy = p.id_item
where dtime_pay >= valid_from and dtime_pay < coalesce (valid_to, '3000-01-01')
group by id_user
having sum (m.cnt_buy * p.price) >= 1000
)

select date_trunc ('month', start_session) mm
      , count (distinct id_user) lmau_invate_1000
from skygame.game_sessions
where id_user in (select * from crit_invite) or id_user in (select * from crit_1000)
group by mm
order by mm


select m.id_user
    , sum (m.cnt_buy * p.price) rev
    , ceil (extract ('day' from max (m.dtime_pay) - min (u.reg_date)) / 30) interv
    , sum (m.cnt_buy * p.price) / ceil (extract ('day' from max (m.dtime_pay) - min (u.reg_date)) / 30) avg_rev
from skygame.monetary m
    join skygame.log_prices p
    on m.id_item_buy = p.id_item
        join skygame.users u
            on m.id_user = u.id_user
    where dtime_pay >= valid_from and dtime_pay < coalesce (valid_to, '3000-01-01')
group by m.id_user
order by avg_rev desc
limit 100
