# GR_Desk

GR_Desk is a business logic platform built to support GR Host operations while also being easily brandable, portable, open-source.

## Code Quality

- Use Jinja for HTML templates.
- Follow HTML5 W3 best practices for modern web.
- Single css file with all elements. Reuse as many as possible.
- Single JavaScript file
- Strict PEP8 compliant Python
- configuration via config.yml
- custom branding via custom.yml


## Core Features

- IT Ticket / Service Desk
- Knowledge Base
- CRM Platform
- HR Platform
- configuration.yml
- branding.yml
- DOTENV for secrets

### Secondary Features

- Customer Management
- Metrics Reporting
- Employee Management
- Discord ChatOps
- Slack ChatOps

### IT Ticket Service Desk

Use json key-value pairs to store and sort this data.

Name, in-game username, ticket_type, ticket_ subject, and ticket_body.

**Types:** Request-REQ, Change-CHG, Incident-INC, Billing-TKT

**Ticket Key:Values**

- uuid
- ticket_number
- ticket_status
- requestor_name
- requestor_username
- ticket_type
- ticket_subject
- ticket_body
- ticket_impact
- ticket_urgency
- escalation_level
- assigned_team_queue
- assigned_support_person
- ticket_worknotes
- ticket_created_timestamp
- ticket_escalation_timestamp
- ticket_closed_timestamp
- ticket_acknowledged_timestamp
- requestor_vip_status
- ticket_overdue

### Service Desk Change Module

- uuid
- change_number
- change_status
- change_requestor
- assigned_team_queue
- change_support_person
- change_subject
- change_description
- change_rollback_plan
- change_implement_plan
- change_test_plan
- change_start_timestamp
- change_end_timestamp
- change_to_appid

### Service Desk Reporting Module

- Total Open Count
- Total Closed
- Current Open Count
- Open Last 7 Days
- Closed Last 7 Days
- Open Last 30 Days
- Closed Last 30 Days
- Closed Count per Technician

### Service Desk Ingest API Endpoint Module

- uptime-kuma
- tailscale
- CubeCoders AMP
- newrelic

### Service Desk Egress API Endpoint Module

- newrelic

## Customer Management Platform

Use json key-value pairs to store and sort this data.

**Customer Key:Values**

- uuid
- customer_id
- customer_username
- customer_first_name
- customer_last_name
- customer_prefered_name
- customer_ingame_username
- customer_contact_email
- customer_account_created_date
- customer_account_status
- customer_fraud_risk
- customer_vip_status
- customer_account_value
- customer_helpdesk_tickets
- is_content_creator

## Employee Management Platform

Use json key-value pairs to store and sort this data.

- uuid
- employee_id
- employee_first_name
- employee_last_name
- employee_preferred_name
- employee_age
- employee_dob
- employee_state
- employee_ingame_username
- employee_chat_userid
- employee_hire_date
- employee_termination_date
- rehire_status
- employee_role
- employee_compensation
- salary_exempt
- is_bonus_eligible
- bonus_rate
- assigned_business_unit
- team_queue_access
- employee_pip_count
- has_active_pip
- is_on_probation
- total_pto_available
- reports_to_who

### Service Desk Operations


