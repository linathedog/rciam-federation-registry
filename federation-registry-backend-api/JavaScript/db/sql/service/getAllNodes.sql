SELECT
    sd.id,
    sd.service_name AS name,
    sd.logo_uri AS logo,
    sd.pid,
    json_build_object(
        'name', sd.name,
        'ror_id', sd.ror_id
    ) AS legal_entity,
    sd.endpoint AS node_endpoint
FROM (
    SELECT *
    FROM (
        (
            SELECT *
            FROM service_details
            WHERE deleted = false
        ) AS bar
        LEFT JOIN service_state USING (id)
    ) AS foo
    LEFT JOIN service_details_node USING (id)
    LEFT JOIN organizations USING (organization_id)
    WHERE tenant = ${tenant}
) AS sd
WHERE deleted = false;