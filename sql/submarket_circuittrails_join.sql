drop table if exists public.submarkets_circuittrails_join;
create table public.submarkets_circuittrails_join as
select 
sr."Class",
c."circuit",
sum(c."length") as "length"
from submarkets.submarket_results sr
join public.circuittrails c 
on st_intersects(sr."geometry", c."shape")
group by sr."Class", c."circuit"