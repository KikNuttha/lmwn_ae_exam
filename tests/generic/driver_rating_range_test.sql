select
    driver_id,
    driver_rating
from {{ ref('sg_mst_drivers') }}
where driver_rating <= 0 or driver_rating >= 5