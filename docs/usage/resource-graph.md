# The Resource Graph

_NOTE: prior to 3.0.0 this was called the `ContextGraph`_

The `ResourceGraph` is a map of all the json:api resources and their relationships that your API serves.

It is built at app startup and available as a singleton through Dependency Injection.

## Constructing The Graph

### Entity Framework

If you are using Entity Framework Core as your ORM, you can add an entire `DbContext` with one line.

```c#
// Startup.cs
public void ConfigureServices(IServiceCollection services)
{
    services.AddJsonApi<AppDbContext>();
}
```

### Defining Non-EF Resources

If you have resources that are not members of a DbContext, you can manually add them to the graph.

```c#
// Startup.cs
public void ConfigureServices(IServiceCollection services)
{
    var mvcBuilder = services.AddMvc();

    services.AddJsonApi(options => {
        options.BuildResourceGraph((builder) => {
            // MyModel is the internal type
            // "my-models" is the type alias exposed through the API
            builder.AddResource<MyModel>("my-models");
        });
    }, mvcBuilder);
}
```

### Resource Names

If a `DbContext` is specified when adding the services, the context will be used to define the resources and their names. By default, these names will be hyphenated.

```c#
public class AppDbContext : DbContext {
    // this will be translated into "my-models"
    public DbSet<MyModel> MyModels { get; set; }
}
```

You can also specify your own resource name.

```c#
public class AppDbContext : DbContext {
    // this will be translated into "someModels"
    [Resource("someModels")]
    public DbSet<MyModel> MyModels { get; set; }
}
```





