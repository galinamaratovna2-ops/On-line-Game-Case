-- ЗАДАНИЕ 1
select case when date_trunc ('month', reg_date) in ('2022-11-01', '2022-12-01') then 'когорта_11-12.2022'
                                                                    else 'остальные когорты' end coh
                , avg (gs.end_session - gs.start_session) len_ses
from skygame.game_sessions gs
    join skygame.users us
        on gs.id_user = us.id_user
where round (extract (epoch from end_session - start_session) / 60) > 5
group by coh
-- Результат - 3 h 37 min (для когорт 11-12.2022) и 2 h 57 min (для остальных когорт)

-- ЗАДАНИЕ 2
with k_factor as
(select sum(ref_reg)/count(distinct u.id_user) as kf
       from skygame.users as u
       left join skygame.referral as r on r.id_user = u.id_user
) ,

cohort_data as
(select count(id_user)/count(distinct date_trunc('month', reg_date)) as avg_cohort_size
    from skygame.users
)

select kf, kf * avg_cohort_size
from k_factor, cohort_data

