### Referencing code objects

Code objects are referenced using one of the following syntax. There is no type checking. A correct type should reference to a valid code object at compile time, just like regular code. You can use built-in types or custom ones but in that case make sure dependencies files are correctly imported without name conflict

```yaml
fieldname: Type
```

`Type`: ""