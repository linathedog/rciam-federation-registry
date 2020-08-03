SELECT service_id,petition_id,service_description,logo_uri,service_name,integration_environment,status,type,state,group_manager,deleted,CASE WHEN owned IS NULL THEN false ELSE owned END,CASE WHEN notification IS NULL THEN false ELSE notification END AS notification,comment
FROM
  (SELECT id AS group_id,true AS owned,is_owner AS group_manager FROM groups LEFT JOIN group_subs ON groups.id=group_subs.group_id WHERE sub=${sub}) AS group_ids LEFT JOIN
  (SELECT id AS service_id,service_description,logo_uri,service_name,deleted,requester,integration_environment,group_id FROM service_details) AS service_details USING (group_id) LEFT JOIN service_state ON service_details.service_id=service_state.id
  LEFT JOIN (SELECT id AS petition_id,status,type, service_id,comment,CASE WHEN service_petition_details.comment IS NOT NULL THEN true ELSE false END AS notification
    FROM service_petition_details WHERE reviewed_at IS NULL AND requester=${sub}) AS petitions USING (service_id)
WHERE deleted=false OR (deleted=TRUE AND state!='deployed')
UNION
SELECT service_id,petition_id,service_description,logo_uri,service_name,integration_environment,status,type,state,group_manager,deleted,owned,notification,comment
  FROM
  (SELECT service_id,id AS petition_id,service_description,logo_uri,comment,service_name,integration_environment,CASE WHEN service_petition_details.comment IS NOT NULL THEN true ELSE false END AS notification,CASE WHEN requester=${sub} THEN true ELSE false END AS owned,status,type,null AS state,false as group_manager,false AS deleted
  FROM service_petition_details WHERE reviewed_at IS NULL AND type='create' AND requester=${sub}) as petitions
