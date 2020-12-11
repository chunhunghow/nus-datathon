-- LOS of the admission case with ICU
-- mimic 4




select

icu_patient.gender,
icu_patient.anchor_age,
icu_patient.dod,
admittime,
dischtime,
deathtime,
admission_type,
admission_location,
discharge_location,
insurance,edregtime,
edouttime,
hospital_expire_flag,
first_icu.*,
DATE_PART('day',dischtime - admittime) as hosp_los

from


(
	select *
		from mimic_core.admissions adm
	join
		mimic_core.patients pat
	on pat.subject_id = adm.subject_id
	where pat.anchor_age > 15
	and adm.hospital_expire_flag = 0

  ) icu_patient


join




(


	select icu.*
		from mimic_icu.icustays icu
	join
	(
		select hadm_id  , min(intime) as min_intime
		FROM
			mimic_icu.icustays
		GROUP BY hadm_id
	) first_
	on icu.hadm_id = first_.hadm_id and icu.intime = first_.min_intime

) first_icu
on icu_patient.hadm_id = first_icu.hadm_id


