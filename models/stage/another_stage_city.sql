{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model: raw_stage_city
ldts: 'GETDATE()'
rsrc: '!City' 
hashed_columns:
    hk_h_City:
        - CityKey
        - City
        - Location
        - ValidTo
    hd_h_City:
        is_hashdiff: true
        use_rtrim: true
        columns:
            - CityKey
            - City
            - Location
            - ValidTo
derived_columns: 
    validTo_addmonth:
        value: "DATEADD(month, 1, ValidFrom)"
        datatype: datetime2
        src_cols_required:
            - ValidFrom
    cont_sales:
        value: CONCAT_WS(' - ', Continent, SalesTerritory)
        datatype: "varchar(255)"
        src_cols_required:
            - Continent
            - SalesTerritory


{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set source_model = metadata_dict['source_model'] -%}
{%- set ldts = metadata_dict['ldts'] -%}
{%- set rsrc = metadata_dict['rsrc'] -%}
{%- set hashed_columns = metadata_dict['hashed_columns'] -%}
{%- set derived_columns = metadata_dict['derived_columns'] -%}
{%- set prejoined_columns = metadata_dict['prejoined_columns'] -%}
{%- set missing_columns = metadata_dict['missing_columns'] -%}

{{ datavault4dbt.stage(source_model=source_model,
                    ldts=ldts,
                    rsrc=rsrc,
                    hashed_columns=hashed_columns,
                    derived_columns=derived_columns,
                    prejoined_columns=prejoined_columns,
                    missing_columns=missing_columns) }}