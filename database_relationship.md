# Database Relationship

This file contains a ER diagram, written with Markdown-inspired text definitions in mermaid syntax, for data models used in this custom connector.
It can be rendered in tools that support [mermaid](https://mermaid-js.github.io/mermaid).

```mermaid
erDiagram

channel {
  id serial4 
  is_active bool 
  created_on timestampz 
  modified_on timestampz 
  uuid varchar 
  channel_type varchar 
  name varchar
  address varchar
  country varchar
  claim_code varchar 
  secret varchar 
  last_seen timestampz 
  device varchar
  os varchar
  alert_email varchar
  config text
  schemes varchar 
  role varchar 
  bod text
  tps int4
  created_by_id int4 
  modified_by_id int4 
  org_id int4
  parent_id int4
}

message {
  id bigserial 
  uuid uuid
  text text 
  high_priority bool
  created_on timestampz 
  modified_on timestampz
  sent_on timestampz
  queued_on timestampz
  direction varchar 
  status varchar 
  visibility varchar 
  msg_type varchar
  msg_count int4 
  error_count int4 
  next_attempt timestampz
  external_id varchar
  attachments varchar
  metadata text
  delete_reason varchar
  broadcast_id int4
  channel_id int4
  contact_id int4 
  contact_urn_id int4
  org_id int4 
  topup_id int4
  delete_from_counts bool
  failed_reason varchar
}

contact {
  id serial4 
  is_active bool 
  created_on timestampz 
  modified_on timestampz 
  uuid varchar 
  name varchar
  language varchar
  fields jsonb
  status varchar 
  last_seen_on timestampz
  created_by_id int4
  modified_by_id int4
  org_id int4 
  ticket_count int4 
}

flow {
  id serial4 
  is_active bool 
  created_on timestampz 
  modified_on timestampz 
  uuid varchar 
  name varchar 
  is_archived bool 
  is_system bool 
  flow_type varchar 
  metadata text
  expires_after_minutes int4 
  ignore_triggers bool 
  saved_on timestampz 
  base_language varchar
  version_number varchar 
  created_by_id int4 
  modified_by_id int4 
  org_id int4 
  saved_by_id int4 
  has_issues bool 
}

run {
  id bigserial 
  uuid uuid 
  status varchar 
  created_on timestampz 
  modified_on timestampz 
  exited_on timestampz
  expires_on timestampz
  responded bool 
  parent_uuid uuid
  results text
  path text
  events jsonb
  current_node_uuid uuid
  delete_reason varchar
  is_active bool 
  exit_type varchar
  connection_id int4
  contact_id int4 
  flow_id int4 
  org_id int4 
  session_id int8
  start_id int4
  submitted_by_id int4
}

broadcast {
  id serial4 
  raw_urns text
  text hstore 
  media hstore
  status varchar 
  base_language varchar 
  created_on timestampz 
  modified_on timestampz 
  send_all bool 
  metadata text
  channel_id int4
  created_by_id int4
  modified_by_id int4
  org_id int4 
  parent_id int4
  schedule_id int4 
  ticket_id int4
}

flowstart {
  id serial4 
  uuid uuid 
  start_type varchar 
  urns text
  query text
  restart_participants bool 
  include_active bool 
  status varchar 
  extra text
  parent_summary jsonb
  session_history jsonb
  created_on timestampz 
  modified_on timestampz 
  contact_count int4
  campaign_event_id int4
  created_by_id int4
  flow_id int4 
  org_id int4 
}

broadcast |o--o{ message: relation

channel ||--o{ message: has

contact ||--o{ message: has

contact ||--o{ run: has

flow ||--o{ run: has

flowstart |o--o{ run: has

channel ||--o{ broadcast: has

flow ||--o{ flowstart: has

```
