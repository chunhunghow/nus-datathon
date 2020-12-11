

-- On top of the data admission with icu, we look at the interval of icu readmission 
-- mimic 4





select *, DATE_PART('day',dischtime - lag) as dif
from
(


	select

	adm.subject_id, hadm_id, admittime, dischtime, LAG(admittime  ) OVER(PARTITION  BY adm.subject_id ORDER BY admittime ) as lag
	from mimic_core.admissions adm


	join



	(
		select
		*
		from

		(
			select

			subject_id , count(DISTINCT hadm_id) as c

			from
			(
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
			) foo
			group by subject_id
		) foo
		where c >1
	) b
	on adm.subject_id = b.subject_id

) d
limit 50


