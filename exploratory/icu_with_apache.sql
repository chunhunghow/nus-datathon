
--for mimic -3
--there are only 12 icu id that has apache scores


select c.icustay_id from chartevents c join

(
	select
	itemid
	from d_items
	where category in ('Scores - APACHE IV (2)','ApacheIV Parameters','ApacheII Parameters','Scores - APACHE IV')
  ) it

 on it.itemid = c.itemid

 group by c.icustay_id





-- mimic 4





select c.stay_id from mimic_icu.chartevents c join

(
	select
		itemid 
	from mimic_icu.d_items 
	where category in ('Scores - APACHE IV (2)','ApacheIV Parameters','ApacheII Parameters','Scores - APACHE IV')
	  ) it
 on it.itemid = c.itemid
 
 group by c.stay_id



