# Vehicle Maintenance Management System

## Description

System for managing vehicle maintenance, which allows the registration of vehicles and their associated maintenance records through the API REST and simple HTML views.

## Prerequisites

- Docker

## Tech stack

- Ruby 3.3.1
- Rails 7.2.2
- PostgreSQL 17

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
  "data": {
    "message": "Login successful",
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NTk0MzkzMDB9.JPH981NusDswHa6T-hZTUYuWoeDByCeXVBzlZio018w",
    "token_type": "Bearer",
    "expired_at": 1759439300,
    "user": {
      "id": 1,
      "email": "user@example.com"
    }
  }
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
  "data": [
    {
      "id": "5",
      "type": "vehicles",
      "attributes": {
        "vin": "7D9FSPMC640312549",
        "plate": "BMA-6389",
        "brand": "Kenworth",
        "model": "T680",
        "year": "1995",
        "status": "active",
        "created-at": "2025-10-02T18:24:35.213Z",
        "updated-at": "2025-10-02T18:24:35.213Z"
      }
    },
    .
    .
    .
  ],
  "links": {
    "self": "http://localhost:3000/api/v1/vehicles?page%5Bnumber%5D=1&page%5Bsize%5D=25",
    "first": "http://localhost:3000/api/v1/vehicles?page%5Bnumber%5D=1&page%5Bsize%5D=25",
    "prev": null,
    "next": null,
    "last": "http://localhost:3000/api/v1/vehicles?page%5Bnumber%5D=1&page%5Bsize%5D=25"
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
  "vin": "1HGCM82633A123456",
  "plate": "ABC123",
  "brand": "Toyota",
  "model": "Corolla",
  "year": 2020,
  "status": "active"
}
```

**Response:**

```json
{
  "data": {
    "id": "6",
    "type": "vehicles",
    "attributes": {
      "vin": "1HGCM82633A123456",
      "plate": "ABC123",
      "brand": "Toyota",
      "model": "Corolla",
      "year": "2020",
      "status": "active",
      "created-at": "2025-10-02T20:18:58.659Z",
      "updated-at": "2025-10-02T20:18:58.659Z"
    }
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
  "data": {
    "id": "6",
    "type": "vehicles",
    "attributes": {
      "vin": "1HGCM82633A123456",
      "plate": "ABC123",
      "brand": "Toyota",
      "model": "Corolla",
      "year": "2020",
      "status": "active",
      "created-at": "2025-10-02T20:18:58.659Z",
      "updated-at": "2025-10-02T20:18:58.659Z"
    }
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
  "status": "inactive"
}
```

**Response:**

```json
{
  "data": {
    "id": "6",
    "type": "vehicles",
    "attributes": {
      "vin": "1HGCM82633A123456",
      "plate": "ABC123",
      "brand": "Toyota",
      "model": "Corolla",
      "year": "2020",
      "status": "inactive",
      "created-at": "2025-10-02T20:18:58.659Z",
      "updated-at": "2025-10-02T20:22:33.033Z"
    }
  }
}
```

### Delete Vehicle

```http
DELETE /api/v1/vehicles/:id
```

**Response:**
204 Not content

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
  "data": [
    {
      "id": "2",
      "type": "maintenance-services",
      "attributes": {
        "description": "Alineación y balanceo",
        "status": "completed",
        "cost-cents": "3716.0",
        "priority": "low",
        "completed-at": "2025-10-02T18:24:35.347Z",
        "created-at": "2025-10-02T18:24:35.354Z",
        "updated-at": "2025-10-02T18:24:35.354Z"
      }
    },
    {
      "id": "1",
      "type": "maintenance-services",
      "attributes": {
        "description": "Servicio eléctrico",
        "status": "completed",
        "cost-cents": "2953.0",
        "priority": "low",
        "completed-at": "2025-10-02T18:24:35.234Z",
        "created-at": "2025-10-02T18:24:35.328Z",
        "updated-at": "2025-10-02T18:24:35.328Z"
      }
    }
  ],
  "links": {
    "self": "http://localhost:3000/api/v1/vehicles/1/maintenance_services?page%5Bnumber%5D=1&page%5Bsize%5D=25",
    "first": "http://localhost:3000/api/v1/vehicles/1/maintenance_services?page%5Bnumber%5D=1&page%5Bsize%5D=25",
    "prev": null,
    "next": null,
    "last": "http://localhost:3000/api/v1/vehicles/1/maintenance_services?page%5Bnumber%5D=1&page%5Bsize%5D=25"
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
  "description": "Regular maintenance",
  "status": "pending",
  "cost_cents": 1500.99,
  "priority": "low"
}
```

**Response:**

```json
{
  "data": {
    "id": "11",
    "type": "maintenance-services",
    "attributes": {
      "description": "Regular maintenance",
      "status": "pending",
      "cost-cents": "1500.99",
      "priority": "low",
      "completed-at": null,
      "created-at": "2025-10-02T20:26:59.800Z",
      "updated-at": "2025-10-02T20:26:59.800Z"
    }
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
  "status": "completed",
  "completed_at": "2025-10-02"
}
```

**Request Body:**

```json
{
  "data": {
    "id": "11",
    "type": "maintenance-services",
    "attributes": {
      "description": "Regular maintenance",
      "status": "completed",
      "cost-cents": "1500.99",
      "priority": "low",
      "completed-at": "2025-10-02T00:00:00.000Z",
      "created-at": "2025-10-02T20:26:59.800Z",
      "updated-at": "2025-10-02T20:31:19.042Z"
    }
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
  "data": {
    "statuses": [
      {
        "status": "completed",
        "count": 5
      },
      {
        "status": "in_progress",
        "count": 3
      },
      {
        "status": "pending",
        "count": 3
      }
    ],
    "vehicles": [
      {
        "vehicle_id": 1,
        "vin": "7368N0U325D311961",
        "plate": "YSG-5564",
        "status_breakdown": {
          "completed": 3
        },
        "total_services": 3,
        "total_cost_cents": "8169.99"
      },
      {
        "vehicle_id": 2,
        "vin": "450MERRX7EV794695",
        "plate": "UPC-8952",
        "status_breakdown": {
          "pending": 2
        },
        "total_services": 2,
        "total_cost_cents": "13650.0"
      },
      {
        "vehicle_id": 3,
        "vin": "752HHS413MR974465",
        "plate": "SCH-1154",
        "status_breakdown": {
          "in_progress": 2
        },
        "total_services": 2,
        "total_cost_cents": "17094.0"
      },
      {
        "vehicle_id": 4,
        "vin": "148178DC9LY926066",
        "plate": "DLT-1444",
        "status_breakdown": {
          "in_progress": 1,
          "pending": 1
        },
        "total_services": 2,
        "total_cost_cents": "19303.0"
      },
      {
        "vehicle_id": 5,
        "vin": "7D9FSPMC640312549",
        "plate": "BMA-6389",
        "status_breakdown": {
          "completed": 2
        },
        "total_services": 2,
        "total_cost_cents": "24847.0"
      }
    ],
    "top_vehicles_by_cost": [
      {
        "vehicle_id": 5,
        "total_cost_cents": "24847.0"
      },
      {
        "vehicle_id": 4,
        "total_cost_cents": "19303.0"
      },
      {
        "vehicle_id": 3,
        "total_cost_cents": "17094.0"
      }
    ],
    "summary": {
      "total_services": 11,
      "total_cost_cents": "83063.99"
    }
  },
  "meta": {
    "from": "2025-08-01",
    "to": "2025-10-20",
    "generated_at": "2025-10-02T20:34:10.046Z"
  }
}
```

## Authentication

All endpoints except `/api/v1/auth/login` require authentication. Include the JWT token in the Authorization header:

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

**If you need to create an account, you can use endpoint:**

#### Create account

```http
POST /api/v1/users
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
  "data": {
    "message": "Account created successfully",
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NTk0MzMwODN9.ZCMHftW5HgQa0UTsHiiyfiqDVIhtAJKMbKcA6QiSnIY",
    "token_type": "Bearer",
    "expired_at": 1759433083,
    "user": {
      "id": 1,
      "email": "user@example.com"
    }
  }
}
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
