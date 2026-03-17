select
    restaurant_id,
    prep_time_min
from {{ ref('model_sg_mst_restaurants') }}
where prep_time_min <= 0 or prep_time_min >= 60