# Resources

At a minimum, resources must implement `IIdentifiable<TId>` where `TId` is the type of the primary key. The easiest way to do this is to inherit `Identifiable<TId>`.

```c#
public class Person : Identifiable<Guid>
{ }
```

You can use the non-generic `Identifiable` if your primary key is an integer.

```c#
public class Person : Identifiable
{ }

// is the same as

public class Person : Identifiable<int>
{ }
```

If you need to hang annotations or attributes on the `Id` property, 
you can override the virtual property.

```c#
public class Person : Identifiable
{ 
    [Key]
    [Column("person_id")]
    public override int Id { get; set; }
}
```

If your resource must inherit from another class, 
you can always implement the interface yourself. 
In this example, `ApplicationUser` inherits `IdentityUser` 
which already contains an Id property of type string.

```c#
public class ApplicationUser : IdentityUser, IIdentifiable<string>
{
    [NotMapped]
    public string StringId { get => Id; set => Id = value; }
}
```

## Attributes

If you want an attribute on your model to be publicly available, 
add the `AttrAttribute` and provide the outbound name.

```c#
public class Person : Identifiable
{
    [Attr("first-name")]
    public string FirstName { get; set; }
}
```

### Immutability

Attributes can be marked as immutable which will prevent `PATCH` requests from updating them.

```c#
public class Person : Identifiable<int>
{
    [Attr("first-name", immutable: true)]
    public string FirstName { get; set; }
}
```

### Filter|Sort-ability

All attributes are filterable and sortable by default. 
You can disable this by setting `IsFiterable` and `IsSortable` to `false `.
Requests to filter or sort these attributes will receive an HTTP 400 response.

```c#
public class Person : Identifiable<int>
{
    [Attr("first-name", isFilterable: false, isSortable: false)]
    public string FirstName { get; set; }
}
```

### Complex Attributes

Models may contain complex attributes.
Serialization of these types is done by Newtonsoft.Json,
so you should use their APIs to specify serialization formats.
You can also use global options to specify the `JsonSerializer` that gets used.

```c#
public class Foo : Identifiable
{
    [Attr("bar")]
    public Bar Bar { get; set; }
}

public class Bar
{
    [JsonProperty("compound-member")]
    public string CompoundMember { get; set; }
}
```

If you need your complex attributes persisted as a 
JSON string in your database, but you need access to it as a concrete type, you can define two members on your resource. 
The first member is the concrete type that you will directly interact with in your application. We can use the `NotMapped` attribute to prevent Entity Framework from mapping it to the database. The second is the raw JSON property that will be persisted to the database. How you use these members should determine which one is responsible for serialization. In this example, we only serialize and deserialize at the time of persistence
and retrieval.

```c#
public class Foo : Identifiable
{
    [Attr("bar"), NotMapped]
    public Bar Bar { get; set; }

    public string BarJson 
    { 
        get => (Bar == null) 
                ? "{}"
                : JsonConvert.SerializeObject(Bar);
        
        set => Bar = string.IsNullOrWhiteSpace(value)
                ? null
                : JsonConvert.DeserializeObject(value);
    };
}
```

## Relationships

In order for navigation properties to be identified in the model, 
they should be labeled with the appropriate attribute (either `HasOne` or `HasMany`).

```c#
public class Person : Identifiable<int>
{
    [Attr("first-name")]
    public string FirstName { get; set; }

    [HasMany("todo-items")]
    public virtual List<TodoItem> TodoItems { get; set; }
}
```

Dependent relationships should contain a property in the form `{RelationshipName}Id`. For example, a TodoItem may have an Owner and so the Id attribute should be OwnerId.

```c#
public class TodoItem : Identifiable<int>
{
    [Attr("description")]
    public string Description { get; set; }

    [HasOne("owner")]
    public virtual Person Owner { get; set; }
    public int OwnerId { get; set; }
}
```