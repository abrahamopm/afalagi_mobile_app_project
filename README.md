# Afalagi: Real Estate Lead & Viewing Manager

## Project Description
Afalagi is a back-office productivity tool built for independent real estate agents. It helps manage property portfolios and track the buyer's journey by logging house viewings, recording client feedback, and monitoring interest levels, replacing messy notebooks with a clean, data-driven system.

## Project Structure

This repository is organized as a monorepo:

-   **/flutter**: Contains the mobile application source code (Flutter).
-   **/backend**: Contains the server-side API and database logic (Node.js).

## CRUD Features (minimum)

### CRUD 1. Property Portfolio Management
Add, view, update, and delete properties with details like location, price, rooms, and status.

### CRUD 2. Client Viewing & Feedback Tracker
Log viewings, record client feedback, assign Interest Scores (1–5 stars), and track interactions between clients and properties.

### CRUD 3. Categories / Tags Management
Users (agents) can create, edit, delete, and manage custom categories or tags (e.g., "Villa", "Apartment", "Bole", "Luxury", "Under Construction", "Rental", etc.). These categories/tags can be assigned to Properties and Clients for organization and filtering. Property list screens support tag-based filters.

* Create new category/tag
* Assign categories to items (properties, clients)
* Edit existing categories
* Delete categories (with proper handling of references on properties)

## Design Approach

The project follows modern architectural patterns to ensure scalability, maintainability, and a premium user experience.

### Authentication & data isolation
- **Identity Management**: Registration, secure login (JWT), and session persistence via `/auth/me`.
- **Per-agent data isolation**: API queries scope all properties, clients, viewings, and tags to the authenticated user. Agents cannot access another agent's portfolio.
- **Offline reads**: The mobile app caches portfolio data locally and serves it when offline. **Writes require a network connection** (create/update/delete are not queued offline).
- **Data Privacy**: Account deletion (`DELETE /auth/me`) permanently removes the user and cascades deletion of their properties, clients, viewings, and tags.

> **Note:** The backend stores a `role` field on users (`user` | `admin`) for future use, but the current API does not enforce role-based permissions beyond per-user ownership.

## Running locally

1. Start MongoDB and the API from `/backend` (default `http://localhost:5000`).
2. Run the Flutter app from `/flutter`. The default API base URL targets the Android emulator host (`http://10.0.2.2:5000/api/v1`). Adjust `flutter/lib/core/constants/constants.dart` for physical devices or iOS simulators.

### Admin login (local development)

1. With MongoDB running, seed an admin user from `/backend`:

   ```bash
   node scripts/seedAdmin.js
   ```

2. Sign in on the mobile app with:

   | Field | Value |
   | :--- | :--- |
   | Email | `admin@afalagi.com` |
   | Password | `Admin123!` |

3. After login you are routed to the **Admin Panel** (dashboard, users, properties, profile). Agent accounts use the standard agent shell at `/dashboard`.

To use different credentials, set `ADMIN_EMAIL`, `ADMIN_PASSWORD`, and optionally `ADMIN_NAME` before running the seed script.

## Team Members

| Full Name | ID |
| :--- | :--- |
| Abraham Nigatu | UGR/7532/16 |
| Fransi Tsena | UGR/9529/16 |
| Manuhe Habtamu | UGR/2808/16 |
| Melika Mohammed | UGR/4806/16 |
| Yordanos Teshome | UGR/0489/16 |
