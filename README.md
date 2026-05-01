# Reference-Architecture

A production-ready, scalable .NET microservices architecture that demonstrates best practices for building enterprise applications.

## 📋 Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Architecture](#architecture)
- [Technologies Used](#technologies-used)
- [Getting Started](#getting-started)
- [Key Features](#key-features)

## 🎯 Overview

This repository contains a comprehensive reference architecture showcasing multiple real-world application patterns:

- **NexCart Microservices**: E-commerce platform built with ASP.NET Core microservices
- **E-BookShop**: ASP.NET Core MVC application with Stripe payment integration
- **LibraryManagement System**: Full-stack library management with Angular frontend and .NET backend

## 📁 Project Structure

### 1. NexCart.Microservice.APIS - E-Commerce Microservices

Production-ready microservices architecture with multiple service domains:

```
NexCart.Microservice.APIS/
├── UsersApi/                          # User Management Service
│   ├── NexCart.UsersApi/              # API Layer
│   ├── NexCart.Users.Services/        # Business Logic
│   ├── NexCart.Users.Infrastructure/  # Data Access
│   ├── NexCart.Users.DTO/             # Data Transfer Objects
│   ├── NexCart.Users.Entities/        # Domain Models
│   ├── NexCart.Users.Validators/      # Input Validation
│   ├── NexCart.Users.Mappers/         # Object Mapping
│   ├── NexCart.Users.ServiceContracts/
│   ├── NexCart.Users.RepositoryContracts/
│   └── NextCart.Users.Helpers/        # Utility Classes
│
├── ProductsApi/                       # Product Management Service
│   ├── NexCart.ProductsApi/           # API Layer
│   ├── NexCart.Products.Services/     # Business Logic
│   ├── NexCart.Products.Repositories/ # Data Access
│   ├── NexCart.Products.Context/      # EF Core Context
│   ├── NexCart.Products.DTO/          # Data Transfer Objects
│   ├── NexCart.Products.Entities/     # Domain Models
│   ├── NexCart.Products.Validators/   # Input Validation
│   ├── NexCart.Products.Mappers/      # Object Mapping
│   ├── NexCart.Products.ServiceContracts/
│   ├── NexCart.Products.RepositoryContracts/
│   └── NexCart.Products.Helpers/      # Utility Classes
│
├── OrdersApi/                         # Order Management Service
│   ├── NexCart.OrdersApi/             # API Layer
│   ├── NexCart.Orders.Services/       # Business Logic
│   ├── NexCart.Orders.Repositories/   # Data Access
│   ├── NexCart.Orders.DTO/            # Data Transfer Objects
│   ├── NexCart.Orders.Entities/       # Domain Models
│   ├── NexCart.Orders.Validators/     # Input Validation
│   ├── NexCart.Orders.Mappers/        # Object Mapping
│   ├── NexCart.Orders.HttpClients/    # External API Clients
│   ├── NexCart.Orders.Policies/       # Retry & Circuit Breaker Policies
│   ├── NexCart.Orders.ServiceContracts/
│   ├── NexCart.Orders.RepositoryContracts/
│   └── NexCart.Orders.Helpers/        # Utility Classes
│
├── Infrastructure/
│   └── NexCart.ServiceBus/            # RabbitMQ Integration & Message Bus
│
└── NexCart.MicroserviceApis.sln       # Solution File
```

**Key Patterns:**
- Layered Architecture (API, Services, Infrastructure)
- Repository Pattern
- DTO Pattern for API contracts
- Dependency Injection
- Validation layer with FluentValidation
- Object Mapping with AutoMapper
- Resilience patterns (Retry, Circuit Breaker)
- Async/Await patterns

---

### 2. E-BookShop - ASP.NET Core MVC Application

Complete e-commerce application with Stripe payment integration:

```
E-BookShop/
│
├── Book.DataAccess/                  # Data Access Layer
│   ├── Data/                         # ApplicationDbContext and migrations
│   ├── Repository/                   # Repository and UnitOfWork implementations
│
├── Book.Models/                      # Entity and ViewModel classes
│   ├── ViewModels/                   # ViewModel classes for MVC
│
├── Book.Utility/                     # Utility classes
│   ├── Roles
│   ├── Stripe settings
│   └── Email sender
│
├── BulkyWeb/                         # ASP.NET Core MVC web application
│   ├── Areas/                        # MVC Areas: Admin, Customer, Identity
│   ├── Views/                        # Razor views for all areas
│   ├── wwwroot/                      # Static files (images, CSS, JS)
│   ├── Program.cs                    # Main entry point
│   └── appsettings.json              # Configuration (DB, Stripe, etc.)
│
├── Bulky.Documents/                  # Document-related logic (future expansion)
│
├── Bulky.sln                         # Visual Studio solution file
└── README.md                         # Project documentation
```

**Key Features:**
- Multi-area MVC application (Admin, Customer, Identity)
- Stripe payment integration
- Unit of Work pattern
- Repository pattern
- Razor views and layouts
- Role-based access control

---

### 3. NexCart Frontend - Vue.js + Vite

Modern Vue.js SPA frontend for NexCart microservices:

```
NexCart-Frontend/
├── src/                              # Source code
│   ├── assets/                       # Static assets (images, fonts, etc.)
│   ├── components/                   # Reusable Vue components
│   │   └── layout/                   # Layout components (header, footer, etc.)
│   ├── composables/                  # Vue composition functions
│   ├── constants/                    # Application constants and configuration
│   ├── router/                       # Vue Router configuration
│   ├── services/                     # API services and external integrations
│   ├── stores/                       # Pinia store modules
│   ├── views/                        # Page components
│   │   ├── auth/                     # Authentication related pages
│   │   ├── cart/                     # Shopping cart pages
│   │   ├── home/                     # Home page components
│   │   ├── menu-item/                # Menu item related pages
│   │   └── order/                    # Order management pages
│   ├── App.vue                       # Root Vue component
│   └── main.js                       # Application entry point
│
├── public/                           # Public static assets
├── node_modules/                     # Dependencies
├── vite.config.js                    # Vite configuration
├── package.json                      # Dependencies and scripts
└── README.md                         # Project documentation
```

**Key Features:**
- Vue 3 with Composition API
- Vite for fast development and build
- Pinia for state management
- Vue Router for client-side routing
- RESTful API integration
- Component-based architecture

---

### 4. LibraryManagement System - Full Stack Application

Complete library management system with Angular frontend and .NET backend:

#### Backend API (LibraryManagement.API)

```
LibraryManagement.API/
├── Controllers/                      # API controllers
│   ├── LibrarianController.cs        # Librarian operations
│   └── StudentController.cs          # Student operations
│
├── Data/                             # Database context
│   └── LibraryContext.cs             # Entity Framework context
│
├── DTOs/                             # Data Transfer Objects
│   ├── AddBookFormDto.cs
│   ├── BookDto.cs
│   ├── BookIssueDto.cs
│   ├── LoginDto.cs
│   ├── NotificationDto.cs
│   ├── StudentDto.cs
│   └── UpdatePasswordDto.cs
│
├── Models/                           # Entity models
│   ├── Book.cs
│   ├── BookIssue.cs
│   ├── Librarian.cs
│   ├── LibrarySettings.cs
│   ├── Notification.cs
│   └── Student.cs
│
├── Services/                         # Business logic services
│   ├── AuthService.cs                # Authentication & authorization
│   ├── FileService.cs                # File upload operations
│   └── LibraryService.cs             # Core library operations
│
├── Migrations/                       # Entity Framework migrations
├── wwwroot/                          # Static files
│   └── uploads/                      # PDF file storage
│
├── Program.cs                        # Application entry point
├── appsettings.json                  # Configuration
└── LibraryManagement.sln             # Solution file
```

#### Frontend (LibraryManagement.WEB - Angular)

```
LibraryManagement.WEB/
├── src/
│   ├── app/
│   │   ├── auth/                     # Authentication Module
│   │   │   ├── auth.guard.ts         # Route protection guard
│   │   │   ├── auth.service.ts       # Authentication service
│   │   │   ├── login/                # Login component
│   │   │   ├── register/             # Registration component
│   │   │   ├── forgot-password/      # Password recovery
│   │   │   └── reset-password/       # Password reset
│   │   │
│   │   ├── librarian/                # Librarian Module
│   │   │   ├── dashboard/            # Librarian dashboard
│   │   │   ├── manage-books/         # Book management interface
│   │   │   ├── add-book/             # Add new books
│   │   │   ├── edit-book/            # Edit existing books
│   │   │   ├── manage-students/      # Student management
│   │   │   ├── add-student/          # Add new students
│   │   │   ├── issue-book/           # Book issuance
│   │   │   ├── return-book/          # Book returns
│   │   │   ├── notifications/        # Notification management
│   │   │   └── settings/             # System settings
│   │   │
│   │   ├── student/                  # Student Module
│   │   │   ├── dashboard/            # Student dashboard
│   │   │   ├── search-books/         # Book search interface
│   │   │   ├── issued-books/         # View borrowed books
│   │   │   ├── profile/              # Profile management
│   │   │   └── notifications/        # Student notifications
│   │   │
│   │   ├── shared/                   # Shared Resources
│   │   │   ├── components/           # Reusable UI components
│   │   │   ├── models/               # TypeScript interfaces
│   │   │   │   ├── book.model.ts     # Book data structure
│   │   │   │   ├── student.model.ts  # Student data structure
│   │   │   │   ├── book-issue.model.ts
│   │   │   │   ├── notification.model.ts
│   │   │   │   └── index.ts          # Model exports
│   │   │   └── services/             # Shared services
│   │   │       ├── auth.service.ts   # Authentication logic
│   │   │       └── library.service.ts# Library operations
│   │   │
│   │   ├── app.component.*           # Main app component
│   │   ├── app.module.ts             # Root module
│   │   ├── app-routing.module.ts     # Application routing
│   │   └── app.routes.ts             # Route definitions
│   │
│   ├── assets/                       # Static assets
│   ├── environments/                 # Environment configuration
│   ├── index.html                    # Main HTML file
│   └── main.ts                       # Application entry point
│
├── public/                           # Public assets
├── angular.json                      # Angular CLI configuration
├── package.json                      # Dependencies and scripts
├── tsconfig.json                     # TypeScript configuration
└── README.md                         # Project documentation
```

**Key Features:**
- Role-based access control (Librarian vs. Student)
- Book management and tracking
- PDF storage and retrieval
- Authentication and authorization
- Real-time notifications
- Student profile management

---

## 🏗️ Architecture

All projects follow **Clean Architecture** and **SOLID** principles:

### Layering Strategy

1. **Presentation Layer** - Controllers, Views, Components
2. **Business Logic Layer** - Services, Validators, Mappers
3. **Data Access Layer** - Repositories, DbContext, Migrations
4. **Infrastructure Layer** - External services, message bus, utilities

### Cross-Cutting Concerns

- Dependency Injection
- Logging
- Exception Handling
- Validation
- Authentication & Authorization
- Resilience patterns

---

## 🛠️ Technologies Used

### Backend
- **Framework**: ASP.NET Core 6.0+
- **Database**: SQL Server / Entity Framework Core
- **Messaging**: RabbitMQ
- **Payment**: Stripe
- **Logging**: Serilog
- **Validation**: FluentValidation
- **Mapping**: AutoMapper

### Frontend
- **Vue.js 3** - UI Framework
- **Angular 15+** - Advanced SPA framework
- **Vite** - Build tool and development server
- **Pinia** - State management
- **TypeScript** - Type-safe JavaScript

### DevOps
- **Container**: Docker
- **CI/CD**: GitHub Actions
- **Version Control**: Git

---

## 🚀 Getting Started

### Prerequisites

- .NET 6.0 SDK or higher
- SQL Server (local or cloud)
- Node.js 16+ and npm
- Docker (optional)

### Running NexCart Microservices

1. **Clone the repository**
   ```bash
   git clone https://github.com/MdMirajAnsari/Reference-Architecture.git
   cd Reference-Architecture
   ```

2. **Setup database**
   ```bash
   # Update connection string in appsettings.json
   dotnet ef database update
   ```

3. **Start services**
   ```bash
   dotnet run --project NexCart.Microservice.APIS/UsersApi/NexCart.UsersApi
   dotnet run --project NexCart.Microservice.APIS/ProductsApi/NexCart.ProductsApi
   dotnet run --project NexCart.Microservice.APIS/OrdersApi/NexCart.OrdersApi
   ```

### Running E-BookShop

1. **Setup database**
   ```bash
   cd E-BookShop
   dotnet ef database update
   ```

2. **Configure Stripe**
   - Update `appsettings.json` with your Stripe API keys

3. **Run application**
   ```bash
   dotnet run --project BulkyWeb
   ```

### Running LibraryManagement System

#### Backend
```bash
cd LibraryManagement.API
dotnet ef database update
dotnet run
```

#### Frontend
```bash
cd LibraryManagement.WEB
npm install
npm start
```

---

## ✨ Key Features

### Microservices Architecture
- ✅ Service isolation and independent deployment
- ✅ API gateway pattern ready
- ✅ Event-driven communication via RabbitMQ
- ✅ Distributed transaction management

### Clean Code Practices
- ✅ Layered architecture
- ✅ SOLID principles
- ✅ Design patterns (Repository, Factory, Strategy)
- ✅ Comprehensive exception handling

### Enterprise Patterns
- ✅ Unit of Work pattern
- ✅ Repository pattern
- ✅ DTO pattern
- ✅ Validation layer
- ✅ Resilience patterns (Retry, Circuit Breaker)

### API Best Practices
- ✅ RESTful API design
- ✅ Proper HTTP status codes
- ✅ API versioning
- ✅ OpenAPI/Swagger documentation

---

## 📝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👤 Author

**Md Miraj Ansari**

- GitHub: [@MdMirajAnsari](https://github.com/MdMirajAnsari)

---

## 📞 Support

For support, open an issue on GitHub or contact the maintainer.

---

**Happy Coding! 🚀**