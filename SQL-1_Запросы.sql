-- SQL Техническое задание №1

-- Задание 1
-- MAU
select date_trunc ('month', start_session) as month
     , count (distinct id_user) as mau
from skygame.game_sessions
group by month
order by month

-- WAU
select date_trunc ('week', start_session) as week
     , count (distinct id_user) as wau
from skygame.game_sessions
group by week
order by week

-- DAU
select date_trunc ('day', start_session) as day
     , count (distinct id_user) as dau
from skygame.game_sessions
group by day
order by day





-- Задание 2
select gs.id_user as user
    , sum (gs.end_session - gs.start_session) as dur_sess
from skygame.game_sessions gs
  left join skygame.users users
  on gs.id_user = users.id_user
where gs.end_session is not null
   and date_part ('year', users.reg_date) = 2022
group by gs.id_user
order by dur_sess desc
limit 25



-- Задание 3
-- ����� 1
select sum (case when gs.end_session is null then 1 else 0 end) as cnt_wo_end
-- ���������� ������������� ������
    , sum (case when gs.end_session is null then 1.0 else 0.0 end) / count (*) as share_wo_end
-- ���� ������������� ������
from skygame.game_sessions  as gs
-- ���������� ������������� ������ - 3262, ���� ������������� ������ - 0,12

-- ����� 2
select users.dev_type as dtype
     , sum (case when gs.end_session is null then 1.0 else 0.0 end) / count (*) as share_wo_end
-- ���� ������������� ������ ��� ������� ���� �������
from skygame.game_sessions  as gs
  left join skygame.users as users
  on gs.id_user = users.id_user
group by dtype
-- ����������/���� ������������� ������ ���: ios - 3184 / 0,19; android  - 78 / 0,0075

-- ����� 3
select sum (case when users.dev_type = 'ios' then 1.0 else 0.0 end) / count (*) * 100 as "%_ios"
     , sum (case when users.dev_type = 'android' then 1.0 else 0.0 end) / count (*) *100 as "%_android"
-- ������� ������������� ������, ������������ �� ������ ��� �������
from skygame.game_sessions  as gs
  left join skygame.users as users
  on gs.id_user = users.id_user
where gs.end_session is null
-- ������� ������������� ������, ������������ ��: ios - 97,61%; android  - 2,39%

