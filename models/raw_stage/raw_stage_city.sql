{{ config(materialized='view') }}
{%- set src = source('dimension_city_source', 'dimension_city') -%}
select
    {{ dbt_utils.star(from=src) }}
from {{ src }}