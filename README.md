# Vehicle Maintenance Management System

## Description
System for managing vehicle maintenance, which allows the registration of vehicles and their associated maintenance records through the REST API and simple HTML views.

## Prerequisites
* Docker

## Tech stack
* Ruby 3.3.1
* Rails 7.2.2
* PostgreSQL 17

## Initial Setup
1. Create `.env` file in the project root:
```env
DB_USER=postgres
DB_PASSWORD=your_password
DB_NAME=challenge_rails_backend_development
DB_HOST=db
```

3. Build and start containers:
```bash
docker compose up
```

## API Endpoints

### Authentication

#### Login
```http
POST /api/v1/auth/login
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "user": {
      "id": 1,
      "email": "user@example.com"
  },
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.njAWp5JJoK1rykdWk6JJr5BGLNs6SwJoIrX-JQpMD18"
}
```

## Vehicles

### List Vehicles
```http
GET /api/v1/vehicles
```

**Query Parameters:**
- `page`: Page number (default: 1)
- `per_page`: Items per page (default: 25)
- `sort_by`: Sort field (e.g., brand, model)
- `sort_order`: Sort direction (asc/desc)
- `search`: Search vehicle for vin or plate
- `status`: Filter by status (e.g., active, inactive, in_maintenance)

**Response:**
```json
{
  "vehicles": [
    {
      "id": 2,
      "vin": "1HGCM826defef33A4352",
      "plate": "QPF-3190s",
      "brand": "International 2",
      "model": "ProStar Serie 300",
      "year": "1996",
      "status": "active",
      "created_at": "2025-09-18T19:40:00.360Z",
      "updated_at": "2025-09-18T19:44:02.004Z"
    },
    {
      "id": 1,
      "vin": "7C2EWZHF7AB965919",
      "plate": "QPF-3190",
      "brand": "International",
      "model": "ProStar Serie 300",
      "year": "2014",
      "status": "active",
      "created_at": "2025-09-18T19:35:18.297Z",
      "updated_at": "2025-09-18T19:39:17.038Z"
    }
  ],
  "meta": {
    "pagination": {
      "total_records": 2,
      "current_page": 1,
      "total_pages": 1,
      "next_page": null,
      "prev_page": null
    }
  }
}
```

### Create Vehicle
```http
POST /api/v1/vehicles
```

**Request Body:**
```json
{
  "vehicle": {
    "vin": "1HGCM82633A123456",
    "plate": "ABC123",
    "brand": "Toyota",
    "model": "Corolla",
    "year": 2020,
    "status": "active"
  }
}
```

### Get Vehicle
```http
GET /api/v1/vehicles/:id
```
**Response:**
```json
{
  "vehicle": {
      "id": 50,
      "vin": "1HGCM82633A123456",
      "plate": "ABC123",
      "brand": "Toyota",
      "model": "Corolla",
      "year": "2020",
      "status": "active",
      "created_at": "2025-09-19T17:28:05.586Z",
      "updated_at": "2025-09-19T17:28:05.586Z"
  }
}
```

### Update Vehicle
```http
PUT /api/v1/vehicles/:id
PATCH /api/v1/vehicles/:id
```

**Request Body:**
```json
{
  "vehicle": {
    "status": "inactive"
  }
}
```

**Response:**
```json
{
  "vehicle": {
      "id": 50,
      "vin": "1HGCM82633A123456",
      "plate": "ABC123",
      "brand": "Toyota",
      "model": "Corolla",
      "year": "2020",
      "status": "inactive",
      "created_at": "2025-09-19T17:28:05.586Z",
      "updated_at": "2025-09-19T17:28:05.586Z"
  }
}
```

### Delete Vehicle
```http
DELETE /api/v1/vehicles/:id

**Response:**
204 Not content
```

## Maintenance Services

### List Maintenance Services
```http
GET /api/v1/vehicles/:vehicle_id/maintenance_services
```

**Query Parameters:**
- `page`: Page number (default: 1)
- `per_page`: Items per page (default: 25)
- `sort_by`: Sort field (e.g., cost_cents, completed_at, etc.)
- `sort_order`: Sort direction (asc/desc)
- `search`: Search maintenance service for id
- `status`: Filter by status (e.g., pending, in_progress, completed)
- `priority`: Filter by priority (e.g., low, medium, high)

**Response:**
```json
{
  "maintenance_services": [
    {
        "id": 2,
        "description": "Revisión de frenos",
        "status": "completed",
        "cost_cents": "14003.0",
        "priority": "high",
        "completed_at": "2025-09-18T19:35:18.494Z",
        "created_at": "2025-09-18T19:35:18.498Z",
        "updated_at": "2025-09-18T19:35:18.498Z"
    },
    {
        "id": 1,
        "description": "Cambio de filtros",
        "status": "completed",
        "cost_cents": "6780.0",
        "priority": "medium",
        "completed_at": "2025-09-18T19:35:18.478Z",
        "created_at": "2025-09-18T19:35:18.483Z",
        "updated_at": "2025-09-18T19:35:18.483Z"
    }
  ],
  "meta": {
    "pagination": {
      "total_records": 2,
      "current_page": 1,
      "total_pages": 1,
      "next_page": null,
      "prev_page": null
    }
  }
}
```

### Create Maintenance Service
```http
POST /api/v1/vehicles/:vehicle_id/maintenance_services
```

**Request Body:**
```json
{
  "maintenance_service": {
    "description": "Regular maintenance",
    "status": "pending",
    "cost_cents": 1500.99,
    "priority": "low"
  }
}
```

### Update Maintenance Service
```http
PUT /api/v1/maintenance_services/:id
PATCH /api/v1/maintenance_services/:id
```

**Request Body:**
```json
{
  "maintenance_service": {
    "status": "completed"
  }
}
```

## Reports

### Maintenance Summary
```http
GET /api/v1/reports/maintenance_summary
```

**Query Parameters:**
- `from`: Start date (YYYY-MM-DD), required
- `to`: End date (YYYY-MM-DD), required

**Response:**
```json
{
  "statuses": [
    {
      "status": "completed",
      "count": 2
    },
    {
      "status": "pending",
      "count": 1
    },
    {
      "status": "in_progress",
      "count": 1
    }
  ],
    "vehicles": [
      {
        "vehicle_id": 55,
        "vin": "117K10K60H5766670",
        "plate": "ASE-3631",
        "status_breakdown": {
            "completed": 2
        },
        "total_services": 2,
        "total_cost_cents": "14420.0"
      },
      {
        "vehicle_id": 51,
        "vin": "541UDECB169447935",
        "plate": "GVN-5434",
        "status_breakdown": {
            "pending": 1,
            "in_progress": 1
        },
        "total_services": 2,
        "total_cost_cents": "12228.0"
      }
    ],
    "top_vehicles_by_cost": [
      {
        "vehicle_id": 55,
        "total_cost_cents": "14420.0"
      },
      {
        "vehicle_id": 51,
        "total_cost_cents": "12228.0"
      }
    ],
    "summary": {
      "total_services": 4,
      "total_cost_cents": "26648.0"
    },
    "meta": {
      "from": "2025-08-01",
      "to": "2025-09-20",
      "generated_at": "2025-09-19T18:33:34.631Z"
    }
}
```

## Authentication

All endpoints except `/api/v1/auth/login` require authentication. Include the JWT token in the Authorization header:

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```
## Views
The application has simple HTML views to enable quick interaction without using the API.
Access views at `http://localhost:3000`
## Development Tools

### Database Management
Access Adminer at `http://localhost:8080`:
- PostgreSQL
- User: [DB_USER from .env]
- Password: [DB_PASSWORD from .env]
- Database: [DB_NAME from .env]

## Testing
Run the test suite with:
```bash
bundle exec rspec
```

> **Important:** This API is under **active development**. 