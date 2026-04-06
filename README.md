# Afalagi: Real Estate Lead & Viewing Manager

## Project Description
**Afalagi** is a back-office productivity tool built for independent real estate agents. It helps manage property portfolios and track the buyer's journey by logging house viewings, recording client feedback, and monitoring interest levels, replacing messy notebooks with a clean, data-driven system.

## CRUD Features (minimum)

### CRUD 1. Property Portfolio Management
Add, view, update, and delete properties with details like location, price, rooms, and status.

### CRUD 2. Client Viewing & Feedback Tracker
Log viewings, record client feedback, assign Interest Scores (1–5 stars), and track interactions between clients and properties.

 ### CRUD 3. Categories / Tags Management
   Users (agents) can create, edit, delete, and manage custom categories or tags (e.g., "Villa", "Apartment", "Bole", "Luxury", "Under Construction", "Rental", etc.).  
   These categories/tags can be assigned to Properties, Clients, or Viewings for better organization and filtering.  
   - Create new category/tag  
   - Assign categories to items (properties, viewings, etc.)  
   - Edit existing categories  
   - Delete categories (with proper handling of references)

## Design Approach
To be developed using **Domain-Driven Design (DDD)** with **Property** and **Viewing** as main Aggregates.  
Includes role-based authorization: Agents see only their own leads; Admins view everything.

## Team Members
| Full Name            | ID          |
|----------------------|-------------|
| Abraham Nigatu       | UGR/7532/16 |
| Fransi Tsena         | UGR/9529/16 |
| Manuhe Habtamu       | UGR/2808/16 |
| Melika Mohammed      | UGR/4806/16 |
| Yordanos Teshome     | UGR/0489/16 |
