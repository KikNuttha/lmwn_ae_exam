select
    restaurant_id,
    average_rating
from {{ ref('sg_mst_restaurants') }}
where average_rating <= 0 or average_rating >= 60