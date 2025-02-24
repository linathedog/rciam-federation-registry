INSERT INTO service_${type:raw}details_node (id,endpoint,pid)
VALUES (${id},${endpoint},${pid})
RETURNING *
