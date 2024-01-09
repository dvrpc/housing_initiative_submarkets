create table public.submarkets_circuittrails_bycircuit as
with a as (
select
    sr."Class",
    c."circuit",
    sum(c.length) as submarket_trail_length
from
    submarkets.submarket_results sr
join public.circuittrails c on
    st_intersects(sr.geometry,
    c.shape)
group by
    sr."Class",
    c."circuit")
select
    "Class",
    sum(case when "circuit" = 'Existing' then "submarket_trail_length" end) as existing,
    sum(case when "circuit" = 'In Progress' then "submarket_trail_length" end) as in_progress,
    sum(case when "circuit" = 'Pipeline' then "submarket_trail_length" end) as pipeline,
    sum(case when "circuit" = 'Planned' then "submarket_trail_length" end) as planned
from
    a
group by
    "Class"
order by
    "Class";