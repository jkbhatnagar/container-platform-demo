# Customer Complaints Management System — README

## Overview

This MySQL schema supports a simple 3-tier complaints management application with built-in auditing.

It provides:

  - User management (customers, staff, managers)
  - Complaint tracking with status and attachments
  - Automated audit logging of complaint lifecycle changes
  - Convenient views for reporting
  - Stored procedures for consistent operations
  - Triggers to ensure audit logs on all complaint changes

-----

## Database Structure

### Tables

  - **Users**: Stores user info with roles: customer, staff, or manager
  - **Complaints**: Stores customer complaints with status and timestamps
  - **AuditLogs**: Records actions on complaints (creation, status changes, updates)

### Views

  - `v_open_complaints`: Lists complaints currently in ‘Open’ status with customer names
  - `v_complaints_with_audit`: Shows complaints joined with their audit log entries and actors

### Stored Procedures

  - `sp_create_complaint(customer_id, category, description, attachment_url)`
      - Creates a new complaint and automatically logs the creation action.
  - `sp_update_complaint_status(complaint_id, new_status, actor_id)`
      - Updates the complaint status and logs the status change, recording the acting user.

### Triggers

  - **On complaint insert**: Automatically logs complaint creation.
  - **On complaint update**: Logs any update; if status changes, logs old and new status.
  - **On complaint delete**: Logs complaint deletion.

-----

## Usage Examples

### Add a complaint

```sql
CALL sp_create_complaint(1, 'Shipping Delay', 'Package delayed 3 days', NULL);
```

### Update complaint status

```sql
CALL sp_update_complaint_status(1, 'Resolved', 2);
```

### Query open complaints

```sql
SELECT * FROM v_open_complaints;
```

### View complaint audit logs

```sql
SELECT * FROM v_complaints_with_audit WHERE complaint_id = 1 ORDER BY timestamp;
```

-----

## Notes

  - Passwords stored as hashes in `Users.password_hash` (hashing strategy outside this schema).
  - `actor_id` in `AuditLogs` may be `NULL` for automatic trigger logs without known user context.
  - Stored procedures and triggers ensure audit consistency and ease of use for the application layer.
  - To maintain security, grant appropriate privileges so users only interact through procedures and views.

-----

## Deployment

Run the provided `.sql` script in MySQL Workbench or CLI to create the schema, insert sample data, define views, procedures, triggers, and test queries.