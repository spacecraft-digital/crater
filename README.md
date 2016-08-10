A [Mongoose](http://mongoosejs.com/) database of Spacecraft technical data: customers, projects, servers and the like.

This package gives no user interface to the database. [Jiri](https://github.com/spacecraft-digital/jiri) and [Crater UI](https://github.com/spacecraft-digital/crater-ui) consume this package to provide such interfaces.

## Usage

This package exports a function that returns a Promise that resolves to a Mongoose connection.

```
require('crater')(database_url)
.then(function(db) {
   let Customer = db.model('Customer');
   Customer.find(…);
});
```

If other packages need direct access to the schema/methods without creating a database connection, they can do something like this:

```
let Crater = require('crater/lib/Crater');
let customerSchema = Crater.getSchema('Customer');
let Customer = Crater.getModel('Customer');
```

## Codebase

The database schema is defined by the files in `src/schema/`.

Instance and static methods that are available on these are defined within `src/schema/methods/{instance,static}/`

Virtual properties are used mostly to allow for properties to be aliased by different names that people may use to refer to it, and to make an array act as a single item where there is only one. e.g. Stages can have an array of URLs, but typically only have one. The virtual `url` properties aliases `urls` and allows the user to refer to just “URL”.

The root documents are `Customer` and `Person`. Other documents are used as subdocuments within these.

### Language

Crater is written in [CoffeeScript](http://coffeescript.org/).

Source code is in the `src/` folder.

A `prepublish` npm script compiles it down to JavaScript into the `lib/` folder, so JavaScript code can easily consume it. Don't edit files in `lib/` directly — edit their `src/` counterpart then run `npm run prepublish` to compile to JavaScript.
