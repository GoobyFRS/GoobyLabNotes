# GR_Desk

GR_Desk is a business logic platform built to support GR Host operations while also being easily brandable, portable, open-source.

## Code Quality

- Single css file
- Single JavaScript file
- PEP8 compliant Python


## Core Features

- IT Ticket / Service Desk
- Knowledge Base
- CRM Platform
- configuration.yml
- branding yml
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

**Types:** Request-REQ, Change-CHG, Incident-INC,

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

### Service Desk Change Module

### Service Desk Reporting Module

### Service Desk Ingest API Endpoint Module

### Service Desk Egress API Endpoint Module

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
- is_bonus_eligable
- bonus_rate
- assigned_business_unit
- team_queue_access
- employee_pip_count
- has_active_pip
- feedback_data

### Service Desk Operations

**Types**

