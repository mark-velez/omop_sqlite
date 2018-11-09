/*********************************************************************************
# Copyright 2014-6 Observational Health Data Sciences and Informatics
#
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
********************************************************************************/

/************************

 ####### #     # ####### ######      #####  ######  #     #           #######      #####     
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #           #     #    
 #     # # # # # #     # #     #    #       #     # # # # #    #    # #                 #    
 #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######       #####     
 #     # #     # #     # #          #       #     # #     #    #    #       # ### #          
 #     # #     # #     # #          #     # #     # #     #     #  #  #     # ### #          
 ####### #     # ####### #           #####  ######  #     #      ##    #####  ### #######  
                                                                              

script to create OMOP common data model, version 5.2 for PostgreSQL database

last revised: 14 July 2017

Authors:  Patrick Ryan, Christian Reich


*************************/


/************************

Standardized vocabulary

************************/


CREATE TABLE concept (
  concept_id			INTEGER			NOT NULL,
  concept_name			TEXT	NOT NULL,
  domain_id				TEXT		NOT NULL,
  vocabulary_id			TEXT		NOT NULL,
  concept_class_id		TEXT		NOT NULL,
  standard_concept		TEXT		NULL,
  concept_code			TEXT		NOT NULL,
  valid_start_date		TEXT			NOT NULL,
  valid_end_date		TEXT			NOT NULL,
  invalid_reason		TEXT		NULL
)
;




CREATE TABLE vocabulary (
  vocabulary_id			TEXT		NOT NULL,
  vocabulary_name		TEXT	NOT NULL,
  vocabulary_reference	TEXT	NULL,
  vocabulary_version	TEXT	NULL,
  vocabulary_concept_id	INTEGER			NOT NULL
)
;




CREATE TABLE domain (
  domain_id			TEXT		NOT NULL,
  domain_name		TEXT	NOT NULL,
  domain_concept_id	INTEGER			NOT NULL
)
;



CREATE TABLE concept_class (
  concept_class_id			TEXT		NOT NULL,
  concept_class_name		TEXT	NOT NULL,
  concept_class_concept_id	INTEGER			NOT NULL
)
;




CREATE TABLE concept_relationship (
  concept_id_1			INTEGER			NOT NULL,
  concept_id_2			INTEGER			NOT NULL,
  relationship_id		TEXT		NOT NULL,
  valid_start_date		TEXT			NOT NULL,
  valid_end_date		TEXT			NOT NULL,
  invalid_reason		TEXT		NULL)
;



CREATE TABLE relationship (
  relationship_id			TEXT		NOT NULL,
  relationship_name			TEXT	NOT NULL,
  is_hierarchical			TEXT		NOT NULL,
  defines_ancestry			TEXT		NOT NULL,
  reverse_relationship_id	TEXT		NOT NULL,
  relationship_concept_id	INTEGER			NOT NULL
)
;


CREATE TABLE concept_synonym (
  concept_id			INTEGER			NOT NULL,
  concept_synonym_name	TEXT	NOT NULL,
  language_concept_id	INTEGER			NOT NULL
)
;


CREATE TABLE concept_ancestor (
  ancestor_concept_id		INTEGER		NOT NULL,
  descendant_concept_id		INTEGER		NOT NULL,
  min_levels_of_separation	INTEGER		NOT NULL,
  max_levels_of_separation	INTEGER		NOT NULL
)
;



CREATE TABLE source_to_concept_map (
  source_code				TEXT		NOT NULL,
  source_concept_id			INTEGER			NOT NULL,
  source_vocabulary_id		TEXT		NOT NULL,
  source_code_description	TEXT	NULL,
  target_concept_id			INTEGER			NOT NULL,
  target_vocabulary_id		TEXT		NOT NULL,
  valid_start_date			TEXT			NOT NULL,
  valid_end_date			TEXT			NOT NULL,
  invalid_reason			TEXT		NULL
)
;




CREATE TABLE drug_strength (
  drug_concept_id				INTEGER		NOT NULL,
  ingredient_concept_id			INTEGER		NOT NULL,
  amount_value					NUMERIC		NULL,
  amount_unit_concept_id		INTEGER		NULL,
  numerator_value				NUMERIC		NULL,
  numerator_unit_concept_id		INTEGER		NULL,
  denominator_value				NUMERIC		NULL,
  denominator_unit_concept_id	INTEGER		NULL,
  box_size						INTEGER		NULL,
  valid_start_date				TEXT		NOT NULL,
  valid_end_date				TEXT		NOT NULL,
  invalid_reason				TEXT	NULL
)
;



CREATE TABLE cohort_definition (
  cohort_definition_id				INTEGER			NOT NULL,
  cohort_definition_name			TEXT	NOT NULL,
  cohort_definition_description		TEXT	NULL,
  definition_type_concept_id		INTEGER			NOT NULL,
  cohort_definition_syntax			TEXT	NULL,
  subject_concept_id				INTEGER			NOT NULL,
  cohort_initiation_date			TEXT			NULL
)
;


CREATE TABLE attribute_definition (
  attribute_definition_id		INTEGER			NOT NULL,
  attribute_name				TEXT	NOT NULL,
  attribute_description			TEXT	NULL,
  attribute_type_concept_id		INTEGER			NOT NULL,
  attribute_syntax				TEXT	NULL
)
;


/**************************

Standardized meta-data

***************************/


CREATE TABLE cdm_source 
    (  
     cdm_source_name					TEXT	NOT NULL,
	 cdm_source_abbreviation			TEXT		NULL,
	 cdm_holder							TEXT	NULL,
	 source_description					TEXT	NULL,
	 source_documentation_reference		TEXT	NULL,
	 cdm_etl_reference					TEXT	NULL,
	 source_release_date				TEXT			NULL,
	 cdm_release_date					TEXT			NULL,
	 cdm_version						TEXT		NULL,
	 vocabulary_version					TEXT		NULL
    ) 
;







/************************

Standardized clinical data

************************/


CREATE TABLE person 
    (
     person_id						INTEGER		NOT NULL , 
     gender_concept_id				INTEGER		NOT NULL , 
     year_of_birth					INTEGER		NOT NULL , 
     month_of_birth					INTEGER		NULL, 
     day_of_birth					INTEGER		NULL, 
	   birth_datetime					TEXT 	NULL,
     race_concept_id				INTEGER		NOT NULL, 
     ethnicity_concept_id			INTEGER		NOT NULL, 
     location_id					INTEGER		NULL, 
     provider_id					INTEGER		NULL, 
     care_site_id					INTEGER		NULL, 
     person_source_value			TEXT NULL, 
     gender_source_value			TEXT NULL,
	 gender_source_concept_id		INTEGER		NULL, 
     race_source_value				TEXT NULL, 
	 race_source_concept_id			INTEGER		NULL, 
     ethnicity_source_value			TEXT NULL,
	 ethnicity_source_concept_id	INTEGER		NULL
    ) 
;





CREATE TABLE observation_period 
    ( 
     observation_period_id				INTEGER		NOT NULL , 
     person_id							INTEGER		NOT NULL , 
     observation_period_start_date		TEXT		NOT NULL , 
     observation_period_end_date		TEXT		NOT NULL ,
	 period_type_concept_id				INTEGER		NOT NULL
    ) 
;



CREATE TABLE specimen
    ( 
     specimen_id						INTEGER			NOT NULL ,
	 person_id							INTEGER			NOT NULL ,
	 specimen_concept_id				INTEGER			NOT NULL ,
	 specimen_type_concept_id			INTEGER			NOT NULL ,
	 specimen_date						TEXT			NOT NULL ,
	 specimen_datetime						TEXT		NULL ,
	 quantity							NUMERIC			NULL ,
	 unit_concept_id					INTEGER			NULL ,
	 anatomic_site_concept_id			INTEGER			NULL ,
	 disease_status_concept_id			INTEGER			NULL ,
	 specimen_source_id					TEXT		NULL ,
	 specimen_source_value				TEXT		NULL ,
	 unit_source_value					TEXT		NULL ,
	 anatomic_site_source_value			TEXT		NULL ,
	 disease_status_source_value		TEXT		NULL
	)
;



CREATE TABLE death 
    ( 
     person_id							INTEGER			NOT NULL , 
     death_date							TEXT			NOT NULL , 
     death_datetime							TEXT			NULL ,
     death_type_concept_id				INTEGER			NOT NULL ,
     cause_concept_id					INTEGER			NULL , 
     cause_source_value					TEXT		NULL,
	 cause_source_concept_id			INTEGER			NULL
    ) 
;



CREATE TABLE visit_occurrence 
    ( 
     visit_occurrence_id			INTEGER			NOT NULL , 
     person_id						INTEGER			NOT NULL , 
     visit_concept_id				INTEGER			NOT NULL , 
	 visit_start_date				TEXT			NOT NULL , 
	 visit_start_datetime			TEXT		NULL ,
     visit_end_date					TEXT			NOT NULL ,
	 visit_end_datetime				TEXT		NULL ,
	 visit_type_concept_id			INTEGER			NOT NULL ,
	 provider_id					INTEGER			NULL,
     care_site_id					INTEGER			NULL, 
     visit_source_value				TEXT		NULL,
	 visit_source_concept_id		INTEGER			NULL ,
	 admitting_source_concept_id	INTEGER			NULL ,
	 admitting_source_value			TEXT		NULL ,
	 discharge_to_concept_id		INTEGER		NULL ,
	 discharge_to_source_value		TEXT		NULL ,
	 preceding_visit_occurrence_id	INTEGER			NULL
    ) 
;



CREATE TABLE procedure_occurrence 
    ( 
     procedure_occurrence_id		INTEGER			NOT NULL , 
     person_id						INTEGER			NOT NULL , 
     procedure_concept_id			INTEGER			NOT NULL , 
     procedure_date					TEXT			NOT NULL , 
     procedure_datetime					TEXT			NOT NULL ,
     procedure_type_concept_id		INTEGER			NOT NULL ,
	 modifier_concept_id			INTEGER			NULL ,
	 quantity						INTEGER			NULL , 
     provider_id					INTEGER			NULL , 
     visit_occurrence_id			INTEGER			NULL , 
     procedure_source_value			TEXT		NULL ,
	 procedure_source_concept_id	INTEGER			NULL ,
	 qualifier_source_value			TEXT		NULL
    ) 
;



CREATE TABLE drug_exposure 
    ( 
     drug_exposure_id				INTEGER			NOT NULL , 
     person_id						INTEGER			NOT NULL , 
     drug_concept_id				INTEGER			NOT NULL , 
     drug_exposure_start_date		TEXT			NOT NULL , 
     drug_exposure_start_datetime	TEXT		NOT NULL ,
     drug_exposure_end_date			TEXT			NOT NULL ,
     drug_exposure_end_datetime		TEXT		NULL ,
     verbatim_end_date				TEXT			NULL ,
	 drug_type_concept_id			INTEGER			NOT NULL ,
     stop_reason					TEXT		NULL , 
     refills						INTEGER			NULL , 
     quantity						NUMERIC			NULL , 
     days_supply					INTEGER			NULL , 
     sig							TEXT	NULL , 
	 route_concept_id				INTEGER			NULL ,
	 lot_number						TEXT		NULL ,
     provider_id					INTEGER			NULL , 
     visit_occurrence_id			INTEGER			NULL , 
     drug_source_value				TEXT		NULL ,
	 drug_source_concept_id			INTEGER			NULL ,
	 route_source_value				TEXT		NULL ,
	 dose_unit_source_value			TEXT		NULL
    ) 
;


CREATE TABLE device_exposure 
    ( 
     device_exposure_id				INTEGER			NOT NULL , 
     person_id						INTEGER			NOT NULL , 
     device_concept_id				INTEGER			NOT NULL , 
     device_exposure_start_date		TEXT			NOT NULL , 
     device_exposure_start_datetime		TEXT			NOT NULL ,
     device_exposure_end_date		TEXT			NULL ,
     device_exposure_end_datetime		TEXT			NULL ,
     device_type_concept_id			INTEGER			NOT NULL ,
	 unique_device_id				TEXT		NULL ,
	 quantity						INTEGER			NULL ,
     provider_id					INTEGER			NULL , 
     visit_occurrence_id			INTEGER			NULL , 
     device_source_value			TEXT	NULL ,
	 device_source_concept_id		INTEGER			NULL
    ) 
;


CREATE TABLE condition_occurrence 
    ( 
     condition_occurrence_id		INTEGER			NOT NULL , 
     person_id						INTEGER			NOT NULL , 
     condition_concept_id			INTEGER			NOT NULL , 
     condition_start_date			TEXT			NOT NULL , 
     condition_start_datetime			TEXT			NOT NULL ,
     condition_end_date				TEXT			NULL ,
     condition_end_datetime				TEXT			NULL ,
     condition_type_concept_id		INTEGER			NOT NULL ,
     stop_reason					TEXT		NULL , 
     provider_id					INTEGER			NULL , 
     visit_occurrence_id			INTEGER			NULL , 
     condition_source_value			TEXT		NULL ,
	 condition_source_concept_id	INTEGER			NULL ,
	 condition_status_source_value	TEXT		NULL ,
     condition_status_concept_id	INTEGER			NULL 
    ) 
;



CREATE TABLE measurement 
    ( 
     measurement_id					INTEGER			NOT NULL , 
     person_id						INTEGER			NOT NULL , 
     measurement_concept_id			INTEGER			NOT NULL , 
     measurement_date				TEXT			NOT NULL , 
     measurement_datetime				TEXT		NULL ,
	 measurement_type_concept_id	INTEGER			NOT NULL ,
	 operator_concept_id			INTEGER			NULL , 
     value_as_number				NUMERIC			NULL , 
     value_as_concept_id			INTEGER			NULL , 
     unit_concept_id				INTEGER			NULL , 
     range_low						NUMERIC			NULL , 
     range_high						NUMERIC			NULL , 
     provider_id					INTEGER			NULL , 
     visit_occurrence_id			INTEGER			NULL ,  
     measurement_source_value		TEXT		NULL , 
	 measurement_source_concept_id	INTEGER			NULL ,
     unit_source_value				TEXT		NULL ,
	 value_source_value				TEXT		NULL
    ) 
;



CREATE TABLE note 
    ( 
     note_id						INTEGER			NOT NULL , 
     person_id						INTEGER			NOT NULL , 
     note_date						TEXT			NOT NULL ,
	 note_datetime						TEXT		NULL ,
	 note_type_concept_id			INTEGER			NOT NULL ,
	 note_class_concept_id			INTEGER			NOT NULL ,
	 note_title						TEXT	NULL ,
	 note_text						TEXT			NOT NULL ,
	 encoding_concept_id			INTEGER			NOT NULL ,
	 language_concept_id			INTEGER			NOT NULL ,
     provider_id					INTEGER			NULL ,
	 visit_occurrence_id			INTEGER			NULL ,
	 note_source_value				TEXT		NULL
    ) 
;



/*This table is new in CDM v5.2*/
CREATE TABLE note_nlp
(
  note_nlp_id					BIGINT			NOT NULL ,
  note_id						INTEGER			NOT NULL ,
  section_concept_id			INTEGER			NULL ,
  snippet						TEXT	NULL ,
  "offset"						TEXT	NULL ,
  lexical_variant				TEXT	NOT NULL ,
  note_nlp_concept_id			INTEGER			NULL ,
  note_nlp_source_concept_id	INTEGER			NULL ,
  nlp_system					TEXT	NULL ,
  nlp_date						TEXT			NOT NULL ,
  nlp_datetime					TEXT		NULL ,
  term_exists					TEXT		NULL ,
  term_temporal					TEXT		NULL ,
  term_modifiers				TEXT	NULL
)
;


CREATE TABLE observation 
    ( 
     observation_id					INTEGER			NOT NULL , 
     person_id						INTEGER			NOT NULL , 
     observation_concept_id			INTEGER			NOT NULL , 
     observation_date				TEXT			NOT NULL , 
     observation_datetime				TEXT		NULL ,
     observation_type_concept_id	INTEGER			NOT NULL , 
	 value_as_number				NUMERIC			NULL , 
     value_as_string				TEXT		NULL , 
     value_as_concept_id			INTEGER			NULL , 
	 qualifier_concept_id			INTEGER			NULL ,
     unit_concept_id				INTEGER			NULL , 
     provider_id					INTEGER			NULL , 
     visit_occurrence_id			INTEGER			NULL , 
     observation_source_value		TEXT		NULL ,
	 observation_source_concept_id	INTEGER			NULL , 
     unit_source_value				TEXT		NULL ,
	 qualifier_source_value			TEXT		NULL
    ) 
;



CREATE TABLE fact_relationship 
    ( 
     domain_concept_id_1			INTEGER			NOT NULL , 
	 fact_id_1						INTEGER			NOT NULL ,
	 domain_concept_id_2			INTEGER			NOT NULL ,
	 fact_id_2						INTEGER			NOT NULL ,
	 relationship_concept_id		INTEGER			NOT NULL
	)
;




/************************

Standardized health system data

************************/



CREATE TABLE location 
    ( 
     location_id					INTEGER			NOT NULL , 
     address_1						TEXT		NULL , 
     address_2						TEXT		NULL , 
     city							TEXT		NULL , 
     state							TEXT		NULL , 
     zip							TEXT		NULL , 
     county							TEXT		NULL , 
     location_source_value			TEXT		NULL
    ) 
;



CREATE TABLE care_site 
    ( 
     care_site_id						INTEGER			NOT NULL , 
	 care_site_name						TEXT	NULL ,
     place_of_service_concept_id		INTEGER			NULL ,
     location_id						INTEGER			NULL , 
     care_site_source_value				TEXT		NULL , 
     place_of_service_source_value		TEXT		NULL
    ) 
;


	
CREATE TABLE provider 
    ( 
     provider_id					INTEGER			NOT NULL ,
	 provider_name					TEXT	NULL , 
     NPI							TEXT		NULL , 
     DEA							TEXT		NULL , 
     specialty_concept_id			INTEGER			NULL , 
     care_site_id					INTEGER			NULL , 
	 year_of_birth					INTEGER			NULL ,
	 gender_concept_id				INTEGER			NULL ,
     provider_source_value			TEXT		NULL , 
     specialty_source_value			TEXT		NULL ,
	 specialty_source_concept_id	INTEGER			NULL , 
	 gender_source_value			TEXT		NULL ,
	 gender_source_concept_id		INTEGER			NULL
    ) 
;




/************************

Standardized health economics

************************/


CREATE TABLE payer_plan_period 
    ( 
     payer_plan_period_id			INTEGER			NOT NULL , 
     person_id						INTEGER			NOT NULL , 
     payer_plan_period_start_date	TEXT			NOT NULL , 
     payer_plan_period_end_date		TEXT			NOT NULL , 
     payer_source_value				VARCHAR (50)	NULL , 
     plan_source_value				VARCHAR (50)	NULL , 
     family_source_value			VARCHAR (50)	NULL 
    ) 
;




CREATE TABLE cost 
    (
     cost_id					INTEGER	    NOT NULL , 
     cost_event_id       INTEGER     NOT NULL ,
     cost_domain_id       TEXT    NOT NULL ,
     cost_type_concept_id       INTEGER     NOT NULL ,
     currency_concept_id			INTEGER			NULL ,
     total_charge						NUMERIC			NULL , 
     total_cost						NUMERIC			NULL , 
     total_paid						NUMERIC			NULL , 
     paid_by_payer					NUMERIC			NULL , 
     paid_by_patient						NUMERIC			NULL , 
     paid_patient_copay						NUMERIC			NULL , 
     paid_patient_coinsurance				NUMERIC			NULL , 
     paid_patient_deductible			NUMERIC			NULL , 
     paid_by_primary						NUMERIC			NULL , 
     paid_ingredient_cost				NUMERIC			NULL , 
     paid_dispensing_fee					NUMERIC			NULL , 
     payer_plan_period_id			INTEGER			NULL ,
     amount_allowed		NUMERIC			NULL , 
     revenue_code_concept_id		INTEGER			NULL , 
     reveue_code_source_value    TEXT   NULL ,
	 drg_concept_id			INTEGER		NULL,
     drg_source_value		TEXT		NULL
    ) 
;





/************************

Standardized derived elements

************************/

CREATE TABLE cohort 
    ( 
	 cohort_definition_id			INTEGER			NOT NULL , 
     subject_id						INTEGER			NOT NULL ,
	 cohort_start_date				TEXT			NOT NULL , 
     cohort_end_date				TEXT			NOT NULL
    ) 
;


CREATE TABLE cohort_attribute 
    ( 
	 cohort_definition_id			INTEGER			NOT NULL , 
     cohort_start_date				TEXT			NOT NULL , 
     cohort_end_date				TEXT			NOT NULL , 
     subject_id						INTEGER			NOT NULL , 
     attribute_definition_id		INTEGER			NOT NULL ,
	 value_as_number				NUMERIC			NULL ,
	 value_as_concept_id			INTEGER			NULL
    ) 
;




CREATE TABLE drug_era 
    ( 
     drug_era_id					INTEGER			NOT NULL , 
     person_id						INTEGER			NOT NULL , 
     drug_concept_id				INTEGER			NOT NULL , 
     drug_era_start_date			TEXT			NOT NULL , 
     drug_era_end_date				TEXT			NOT NULL , 
     drug_exposure_count			INTEGER			NULL ,
	 gap_days						INTEGER			NULL
    ) 
;


CREATE TABLE dose_era 
    (
     dose_era_id					INTEGER			NOT NULL , 
     person_id						INTEGER			NOT NULL , 
     drug_concept_id				INTEGER			NOT NULL , 
	 unit_concept_id				INTEGER			NOT NULL ,
	 dose_value						NUMERIC			NOT NULL ,
     dose_era_start_date			TEXT			NOT NULL , 
     dose_era_end_date				TEXT			NOT NULL 
    ) 
;




CREATE TABLE condition_era 
    ( 
     condition_era_id				INTEGER			NOT NULL , 
     person_id						INTEGER			NOT NULL , 
     condition_concept_id			INTEGER			NOT NULL , 
     condition_era_start_date		TEXT			NOT NULL , 
     condition_era_end_date			TEXT			NOT NULL , 
     condition_occurrence_count		INTEGER			NULL
    ) 
;






