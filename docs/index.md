# JSON API .Net Core

A [{ json:api }](https://jsonapi.org) web application framework for .Net Core.

## Objectives

### 1. Eliminate Boilerplate

The goal of this package is to facility the development of json:api applications that leverage the full range 
of features provided by the specification.

Eliminate CRUD boilerplate and provide the following features across all your resource endpoints: 

- Relationship inclusion and navigation
- Filtering
- Sorting
- Pagination
- Sparse field selection
- And more...

As an example, with just the following model and controller definitions, you can service all of the following requests:

```http
GET /articles HTTP/1.1
Accept: application/vnd.api+json
```

[!code-csharp[Article](../src/Examples/GettingStarted/Models/Article.cs)]

[!code-csharp[ArticlesController](../src/Examples/GettingStarted/Controllers/ArticlesController.cs)]

### 2. Extensibility

This library relies heavily on an open-generic-based dependency injection model which allows for easy per-resource customization.


