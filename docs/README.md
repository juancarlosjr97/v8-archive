---
sidebar: auto
---

# Directus API Reference

## Introduction

### Versioning

The Directus API uses SemVer for version labeling within the repo and for files which mention a specific version (eg: `package.json`). The API will _not_ include the version in the URL because the API is "versionless". Being versionless means that we will not remove or change API behavior, only _adding_ new features and enhancements – therefore, no breaking changes will ever be introduced.

### Environments

All endpoints are prefixed with the database name (as defined in the config file). The API will read all config files in order to connect to the right database for the current request.
A special character ( `_` ) can be used to target the default database, whichever that is.

A few examples of api requests:

*   `/api/_/collections` (uses default config file `config.php`)
*   `/api/prod/items/projects` (uses prod config file `config.prod.php`)

::: tip
The name in the API URL is not the name of the database itself.
:::

### Response Format

All output will adhere to the same general JSON structure:

```json
{
    "error": {
        "code": [Number],
        "message": [String]
    },
    "data": [Object | Array],
    "meta": [Object]
}
```

### Error Codes

The API uses HTTP status codes in addition to the message value. Everything in the 200 range is a valid response. The API does not serve translated error messages based on locale.

| Code | Description           |
| ---- | --------------------- |
| 200  | OK                    |
| 201  | Created               |
| 204  | No Content            |
| 400  | Bad Request           |
| 401  | Unauthorized          |
| 403  | Forbidden             |
| 404  | Not Found             |
| 409  | Conflict              |
| 422  | Unprocessable Entity  |
| 500  | Internal Server Error |

### Validation

The API performs two types of validation on submitted data:

*   **Data Type** – The API checks the submitted value's type against against the database's field type. For example, a String submitted for an INT field will result in an error.
*   **RegEx** – The API checks the submitted value against its column's `directus_fields.validation` RegEx. If the value doesn't match then an error will be returned.

## Authentication

Most endpoints are checked against the permissions settings. If a user is not authenticated or isn’t allowed to access certain endpoints then API will respond with either a `401 Unauthorized` or a `403 Forbidden` respectively. In addition to these status codes, the API returns a specific reason in the `error.message` field.

### Tokens

To gain access to protected data, you must include an access token with every request. These tokens follow the [JWT spec](https://jwt.io) and contain the user id, group id, email address, auth method, and expiration date in a payload that is encrypted with a secret key. There are several ways to include this access token:

#### 1. Bearer Token in Authorization Header

`curl -H "Authorization: Bearer Py8Rumu.LD7HE5j.uFrOR5" https://example.com/api/`

#### 2. HTTP Basic Auth

`curl -u Py8Ru.muLD7HE.5juFrOR5: https://example.com/api/`

#### 3. Query `access_token` Parameter

`curl https://example.com/api/?access_token=Py8RumuLD.7HE5j.uFrOR5`

### Get Token

Gets a token from a Directus user's credentials

```http
POST /auth/authenticate
```

#### Body

The users credentials

```json
{
    "email": "rijk@directus.io",
    "password": "supergeheimwachtwoord"
}
```

#### Common Responses

| Code            | Description                        |
| --------------- | ---------------------------------- |
| 200 OK          | `data: [new access token]`         |
| 400 Bad Request | `message: wrong email or password` |

::: warning
The access token that is returned through this endpoint must be used with any subsequent requests except for endpoints that don’t require auth. @TODO LIST ENDPOINTS THAT DON'T REQUIRE AUTH
:::

### Refresh Token

Gets a token from a Directus user's credentials

```http
POST /auth/refresh
```

#### Body

A valid token

```json
{
    "token": "123abc456def"
}
```

#### Common Responses

| Code            | Description                |
| --------------- | -------------------------- |
| 200 OK          | `data: [new access token]` |
| 400 Bad Request | `message: invalid token`   |

::: warning
The access token that is returned through this endpoint must be used with any subsequent requests except for endpoints that don’t require auth.
:::

### Password Reset Request

The API will send an email to the requested user’s email containing a link with a short-lived one-time-use reset token. This reset token can be used to finish the password reset flow.

**@TODO**: Is this correct? The reset token could also use the JWT spec to keep it consistent. The payload should contain the email address and expiration date.

```http
POST /auth/password/request
```

#### Body

The user's email address and the app URL from which the reset is requested

```json
{
    "email": "rijk@directus.io",
    "instance": "https://example.com/admin/"
}
```

#### Common Responses

| Code   | Description                                                                |
| ------ | -------------------------------------------------------------------------- |
| 200 OK | Always returns success to avoid malicious checks for valid email addresses |

### Password Reset

The API checks the validity of the reset token, that it hasn't expired, and matches the encrypted email address contained in the code to the one provided. It must be a GET request, since we can’t do POST requests from email clients. This endpoint generates a random temporary password for the user and sends it to their email address.

```http
GET /auth/password/reset/[reset-token]
```

#### Common Responses

| Code   | Description                                                                |
| ------ | -------------------------------------------------------------------------- |
| 200 OK | Always returns success to avoid malicious checks for valid email addresses |

## Parameters

There are many common query parameters used throughout the API. Those are described here and referenced from within each endpoint's section.

### Sorting

`sort` is a CSV of fields used to sort fetched items. Sorting defaults to ascending (ASC) but a minus sign (`-`) can be used to reverse this to descending (DESC). Fields are prioritized by their order in the CSV. You can use a `?` to sort by random.

#### Examples

*   `sort=?` Sorts randomly
*   `sort=name` Sorts by `name` ASC
*   `&sort=name,-age` Sorts by `name` ASC followed by `age` DESC
*   `sort=name,-age,?` Sorts by `name` ASC followed by `age` DESC, followed by random

### Fields

`fields` is a CSV of columns to include in the output. This parameter supports dot notation to request nested relational fields. You can also use a wildcard (`*`) for "everything".

#### Examples

*   `fields=*` Gets all top-level fields
*   `fields=*.*` Gets all top-level fields and all relational fields one-level deep
*   `fields=*,images.*` Gets all top-level fields and all relational fields within `images`
*   `fields=first_name,last_name` Gets only the `first_name` and `last_name` fields
*   `fields=*.*,images.thumbnails.*` Get all fields for top level and one level deep, as well as three levels deep within `images.thumbnails`

### Filtering

Used to fetch specific items from a collection based on one or more filters. Filters follow the syntax `filter[<field-name>][<operator>]=<value>`.

#### Filter Operators

| Operator             | Description                            |
| -------------------- | -------------------------------------- |
| `=`, `eq`            | Equal to                               |
| `<>`, `!=`, `neq`    | Not Equal to                           |
| `<`, `lt`            | Less than                              |
| `<=`, `lte`          | Less than or equal to                  |
| `>`, `gt`            | Greater than                           |
| `>=`, `gte`          | Greater than or equal to               |
| `in`                 | One of these                           |
| `nin`                | Not one of these                       |
| `null`               | Is null                                |
| `nnull`              | Is not null                            |
| `contains`, `like`   | Contains the substring                 |
| `ncontains`, `nlike` | Doesn't contain this substring         |
| `between`            | Is between                             |
| `nbetween`           | Is not between                         |
| `empty`              | Is empty (null or falsy value)         |
| `nempty`             | Is not empty (null or falsy value)     |
| `all`                | Match all related items @TODO: Clarify |
| `has`                | Has one or more related items          |

#### AND vs OR

By default, all chained filters are treated as ANDs. To create an OR combination, you can add the `logical` operator like follows:

```
GET /items/projects?filter[category][eq]=development&filter[logical][or]&filter[category][eq]=design
```

::: tip
In nearly all cases, it makes more sense to use the `in` operator instead of going with the logical-or. For example, the above example can be rewritten as

```
GET /items/projects?filter[category][in]=development,design
```

:::

### Metadata

`meta` is a CSV of metadata fields to include. This parameter supports the wildcard (`*`) to return all metadata fields.

#### Options

*   `result_count` - Number of items returned in this response
*   `total_count` - Total number of items in this collection
*   `status` - Collection item count by statuses
*   `collection` - The collection name
*   `type`
    *   `collection` if it is a collection of items
    *   `item` if it is a single item

### Language

`lang` is a CSV of languages that should be returned with the response. This parameter can only be used when a Translation field has been included in the collection. This parameter supports the wildcard (`*`) to return all translations.

### Search Query

`q` is a search query that will perform a filter on all string-based fields within the collection (see list below). It's an easy way to search for an item without creating complex field filters – though it is far less optimized.

#### Searched Datatypes

*   `VARCHAR`
*   `TEXT`
    @TODO LIST ALL DATATYPES HERE

### Skip Activity Log

`skip_activity` is a parameter used if you need to perform an action through the API but do not want the event stored within `directus_activity`.

::: warning

Many features of Directus use the activity table, and it is important for accountability – so please use this parameter judiciously.

:::

## Items

Items are essentially individual database records which each contain one or more fields (database columns). Each item belongs to a specific container (database table) and is identified by the value of its primary key field. In this section we describe the different ways you can manage items.

### Create Item

Creates one or more items in a given collection

```http
POST /items/[collection-name]
```

#### Body

A single item or an array of multiple items to be created. Field keys must match the collection's column names.

##### One Item (Regular)

```json
{
    "title": "Project One",
    "category": "Design"
}
```

##### Multiple Items (Batch)

```json
[
    {
        "title": "Project One",
        "category": "Design"
    },
    {
        "title": "Project Two",
        "category": "Development"
    }
]
```

#### Common Responses

| Code                     | Description                                                             |
| ------------------------ | ----------------------------------------------------------------------- |
| 201 Created              | `data`: The created item(s), including default fields added by Directus |
| 400 Bad Request          | `message`: Syntax error in provided JSON                                |
| 404 Not Found            | `message`: Collection doesn’t exist                                     |
| 422 Unprocessable Entity | `message`: Field doesn’t exist in collection                            |

::: tip
The API may not return any data for successful requests if the user doesn't have adequate read permission @TODO DOES THAT MEAN A 403 IS RETURNED?
:::

### Get Item

Get one or more single items from a given collection

```http
GET /items/[collection-name]/[pk]
GET /items/[collection-name]/[pk],[pk],[pk]
```

#### Query Parameters

| Name   | Default   | Description                                                |
| ------ | --------- | ---------------------------------------------------------- |
| fields | \*        | CSV of fields to include in response [Learn More](#fields) |
| meta   |           | CSV of metadata fields to include [Learn More](#metadata)  |
| status | Published | CSV of statuses [Learn More](#status)                      |
| lang   | \*        | Include translation(s) [Learn More](#language)             |

#### Common Responses

| Code          | Description                                                                  |
| ------------- | ---------------------------------------------------------------------------- |
| 200 OK        | `data`: Retrieved item<br>`meta`: Depends on requested metadata              |
| 404 Not Found | `message`: Collection doesn’t exist, or item doesn't exist within collection |

#### Examples

*   Return the project item with an ID of `1`
    ```bash
    curl https://api.directus.io/_/items/projects/1
    ```
    *   Return project items with IDs of `1`, `3`, `11`
    ```bash
    curl https://api.directus.io/_/items/projects/1,3,11
    ```

### Get Items

Get an array of items from a given collection

```http
GET /items/[collection-name]
```

#### Query Parameters

| Name          | Default   | Description                                                |
| ------------- | --------- | ---------------------------------------------------------- |
| limit         | 200       | The number of items to request                             |
| offset        | 0         | How many items to skip before fetching results             |
| sort          | id        | CSV of fields to sort by [Learn More](#sorting)            |
| fields        | \*        | CSV of fields to include in response [Learn More](#fields) |
| filter[field] |           | Filter items using operators [Learn More](#filtering)      |
| meta          |           | CSV of metadata fields to include [Learn More](#metadata)  |
| status        | Published | CSV of statuses [Learn More](#status)                      |
| lang          | \*        | Include translation(s) [Learn More](#language)             |
| q             |           | Search string [Learn More](#search-query)                  |

#### Common Responses

| Code          | Description                                                     |
| ------------- | --------------------------------------------------------------- |
| 200 OK        | `data`: Array of items<br>`meta`: Depends on requested metadata |
| 404 Not Found | `message`: Collection doesn’t exist                             |

#### Examples

*   Search for all projects in the `design` category
    ```bash
    curl -g https://api.directus.io/_/items/projects?filter[category][eq]=design
    ```

### Get Item Revision

Get a specific revision from a given item. This endpoint uses a zero-based offset to select a revision, where `0` is the creation revision. Negative offsets are allowed, and select as if `0` is the current revisions.

```http
GET /items/[collection-name]/[pk]/revisions/[offset]
```

#### Query Parameters

| Name   | Default   | Description                                                |
| ------ | --------- | ---------------------------------------------------------- |
| fields | \*        | CSV of fields to include in response [Learn More](#fields) |
| meta   |           | CSV of metadata fields to include [Learn More](#metadata)  |
| status | Published | CSV of statuses [Learn More](#status)                      |
| lang   | \*        | Include translation(s) [Learn More](#language)             |

#### Common Responses

| Code          | Description                                                                  |
| ------------- | ---------------------------------------------------------------------------- |
| 200 OK        | `data`: Retrieved item<br>`meta`: Depends on requested metadata              |
| 404 Not Found | `message`: Collection doesn’t exist, or item doesn't exist within collection |

#### Examples

*   Return the 2nd revision (from creation) for the project item with a primary key of 1
    ```bash
    curl https://api.directus.io/_/items/projects/1/revisions/2
    ```
*   Return the 2nd from current revision for the project item with a primary key of 1
    ```bash
    curl https://api.directus.io/_/items/projects/1/revisions/-2
    ```

### Get Item Revisions

Get an array of revisions from a given item

```http
GET /items/[collection-name]/[pk]/revisions
```

#### Query Parameters

| Name          | Default   | Description                                                |
| ------------- | --------- | ---------------------------------------------------------- |
| limit         | 200       | The number of items to request                             |
| offset        | 0         | How many items to skip before fetching results             |
| fields        | \*        | CSV of fields to include in response [Learn More](#fields) |
| meta          |           | CSV of metadata fields to include [Learn More](#metadata)  |
| lang          | \*        | Include translation(s) [Learn More](#language)             |

#### Common Responses

| Code          | Description                                                     |
| ------------- | --------------------------------------------------------------- |
| 200 OK        | `data`: Array of items<br>`meta`: Depends on requested metadata |
| 404 Not Found | `message`: Collection doesn’t exist                             |

#### Examples

*   Get all revisions from the project item with a primary key of 1
    ```bash
    curl https://api.directus.io/_/items/projects/1/revisions
    ```

### Update Item

Update or replace a single item from a given collection

@TODO LOOK INTO ALLOWING FILTER PARAM FOR UPDATES, EG: `PUT /items/projects?filter[title][eq]=title`

```http
PATCH /items/[collection-name]/[pk]
PUT /items/[collection-name]/[pk],[pk],[pk]
```

::: warning PATCH VS PUT

*   **PATCH** partially updates the item with the provided data, any missing data is ignored
*   **PUT** overwrites the item and any missing data will fallback to its default value

:::

#### Body

A single item to be updated. Field keys must match the collection's column names

#### Common Responses

| Code                     | Description                                                          |
| ------------------------ | -------------------------------------------------------------------- |
| 200 OK                   | `data`: The updated item, including default fields added by Directus |
| 400 Bad Request          | `message`: Syntax error in provided JSON                             |
| 404 Not Found            | `message`: Collection doesn’t exist                                  |
| 422 Unprocessable Entity | `message`: Column doesn’t exist in collection                        |

#### Examples

*   Return the project item with an ID of `1`
    ```bash
    curl https://api.directus.io/_/items/projects/1
    ```

### Update Items

Update multiple items in a given collection

```http
PATCH /items/[collection-name]
PUT /items/[collection-name]
```

::: warning PATCH VS PUT

*   **PATCH** partially updates the item with the provided data, any missing data is ignored
*   **PUT** fully updates the item and any missing data will fallback to its default value

:::

::: danger WARNING
Batch Update can quickly overwrite large amounts of data. Please be careful when implementing this request.
:::

#### Common Responses

| Code                     | Description                                                          |
| ------------------------ | -------------------------------------------------------------------- |
| 200 OK                   | `data`: The updated item, including default fields added by Directus |
| 400 Bad Request          | `message`: Syntax error in provided JSON                             |
| 404 Not Found            | `message`: Collection doesn’t exist                                  |
| 422 Unprocessable Entity | `message`: Column doesn’t exist in collection                        |

### Revert Item

Reverts a single item to a previous revision state

```http
PATCH /items/[collection-name]/[item-pk]/revert/[revision-pk]
```

#### Body

There is no body for this request

#### Common Responses

| Code                     | Description                                                          |
| ------------------------ | -------------------------------------------------------------------- |
| 200 OK                   | `data`: The updated item, including default fields added by Directus |
| 404 Not Found            | `message`: Collection doesn’t exist                                  |
| 422 Unprocessable Entity | `message`: Item doesn’t exist in collection                          |

#### Examples

*   Revert the project item (ID:`1`) to its previous state in revision (ID:`2`)
    ```bash
    curl https://api.directus.io/_/items/projects/1/revert/2
    ```

### Delete Item

Deletes one or more items from a specific collection. This endpoint also accepts CSV of primary key values, and would then return an array of items

```http
DELETE /items/[collection-name]/[pk]
DELETE /items/[collection-name]/[pk],[pk],[pk]
```

#### Common Responses

| Code           | Description                                     |
| -------------- | ----------------------------------------------- |
| 204 No Content | Record was successfully deleted                 |
| 404 Not Found  | `message`: Item doesn't exist within collection |

::: danger WARNING
Batch Delete can quickly destroy large amounts of data. Please be careful when implementing this request.
:::

## System

@TODO All these endpoints need to have the same reference as listed above

All system tables (`directus_*`) are blocked from being used through the regular `/items` endpoint to prevent security leaks or because they require additional processing before sending to the end user. This means that any requests to `/items/directus_*` will always return `401 Unauthorized`.

These system endpoints still follow the same spec as a “regular” `/items/[collection-name]` endpoint but require the additional processing outlined below:

### Activity

`POST /activity/message` @TODO

### Fields

`/fields/<collection>` is used for creating, updating, or deleting columns through the API requires the API to modify the database schema directly.

### Files

`/files` is used for creating or updating a file requires the API to accept a special field allowing for the base64 file data. Beyond that, it accepts POST requests with the multipart-formdata enctype, to allow for easier uploading of file(s).

### Folders

`/folders` is used for creating, updating, or deleting a virtual folder.

### Permissions

`/permissions` does not have any additional processing, it is simply an alias for the blocked `/items/directus_permissions`

### Collections

`/collections` is similar to columns, this endpoint alters the database schema directly.

### Get Revision

Get a specific revision

```http
GET /revisions/[pk]
```

#### Query Parameters

| Name   | Default   | Description                                                |
| ------ | --------- | ---------------------------------------------------------- |
|        |           | @TODO |

#### Common Responses

| Code            | Description                                                                  |
| --------------- | ---------------------------------------------------------------------------- |
| 200 OK          | `data`: A single Directus Revision<br>`meta`: Depends on requested metadata |
| 400 Bad Request | `message`: Syntax error in provided JSON                                     |

#### Examples

*   Get the revision with primary key 91
    ```bash
    curl https://api.directus.io/_/revisions/91
    ```

### Get Revisions

Get all item revisions, for all collections within this instance

```http
GET /revisions
```

#### Query Parameters

| Name   | Default   | Description                                                |
| ------ | --------- | ---------------------------------------------------------- |
|        |           | @TODO |

#### Common Responses

| Code            | Description                                                                  |
| --------------- | ---------------------------------------------------------------------------- |
| 200 OK          | `data`: Array of Directus Revisions<br>`meta`: Depends on requested metadata |
| 400 Bad Request | `message`: Syntax error in provided JSON                                     |

#### Examples

*   Get all the Directus revisions for this instance
    ```bash
    curl https://api.directus.io/_/revisions
    ```

### Create User

Creates a new user within this instance

```http
POST /users
```

#### Body

The email and password for the new user to be created. Any other submitted fields are optional, but field keys must match column names within `directus_users`.

```json
{
    "email": "rijk@directus.io",
    "password": "d1r3ctus"
}
```

#### Common Responses

| Code                     | Description                                                          |
| ------------------------ | -------------------------------------------------------------------- |
| 201 Created              | `data`: The created user, including default fields added by Directus |
| 400 Bad Request          | `message`: Syntax error in provided JSON                             |
| 422 Unprocessable Entity | `message`: Column doesn’t exist in collection                        |

### Get User

Gets a single user from within this instance

```http
GET /users/[pk]
GET /users/[pk],[pk],[pk]
```

#### Query Parameters

| Name   | Default   | Description                                                |
| ------ | --------- | ---------------------------------------------------------- |
| fields | \*        | CSV of fields to include in response [Learn More](#fields) |
| meta   |           | CSV of metadata fields to include [Learn More](#metadata)  |
| status | Published | CSV of statuses [Learn More](#status)                      |
| lang   | \*        | Include translation(s) [Learn More](#language)             |

#### Common Responses

| Code          | Description                                                     |
| ------------- | --------------------------------------------------------------- |
| 200 OK        | `data`: Retrieved user<br>`meta`: Depends on requested metadata |
| 404 Not Found | `message`: Item doesn't exist within collection                 |

#### Examples

*   Return the user with an ID of `1`
    ```bash
    curl https://api.directus.io/_/users/1
    ```

### Get Users

Gets Directus users within this instance

```http
GET /users
```

#### Query Parameters

| Name          | Default   | Description                                                |
| ------------- | --------- | ---------------------------------------------------------- |
| limit         | 200       | The number of items to request                             |
| offset        | 0         | How many items to skip before fetching results             |
| sort          | id        | CSV of fields to sort by [Learn More](#sorting)            |
| fields        | \*        | CSV of fields to include in response [Learn More](#fields) |
| filter[field] |           | Filter items using operators [Learn More](#filtering)      |
| meta          |           | CSV of metadata fields to include [Learn More](#metadata)  |
| status        | Published | CSV of statuses [Learn More](#status)                      |
| lang          | \*        | Include translation(s) [Learn More](#language)             |
| q             |           | Search string [Learn More](#search-query)                  |
| id            |           | CSV of primary keys to fetch                               |

#### Common Responses

| Code            | Description                                                              |
| --------------- | ------------------------------------------------------------------------ |
| 200 OK          | `data`: Array of Directus users<br>`meta`: Depends on requested metadata |
| 400 Bad Request | `message`: Syntax error in provided JSON                                 |

#### Examples

*   Get all the Directus users for this instance
    ```bash
    curl https://api.directus.io/_/users
    ```

### Update User

Update a user within this instance

```http
PATCH /users/[pk]
PUT /users/[pk]
```

@TODO DO WE WANT TO SUPPORT CSV OF PKs HERE TOO?

*   **PATCH** will partially update the item with the provided data, any missing fields will be ignored
*   **PUT** will update the item and any missing data will fallback to its default value

#### Body

A single user to be updated. Field keys must match column names within `directus_users`.

#### Common Responses

| Code                     | Description                                                          |
| ------------------------ | -------------------------------------------------------------------- |
| 200 OK                   | `data`: The updated item, including default fields added by Directus |
| 400 Bad Request          | `message`: Syntax error in provided JSON                             |
| 404 Not Found            | `message`: Collection doesn’t exist @TODO NO USER FOUND?             |
| 422 Unprocessable Entity | `message`: Column doesn’t exist in collection                        |

### Delete User

Deletes one or more users from this instance

```http
DELETE /users/[pk]
DELETE /users/[pk],[pk],[pk]
```

#### Common Responses

| Code           | Description                                           |
| -------------- | ----------------------------------------------------- |
| 204 No Content | User was successfully deleted                         |
| 404 Not Found  | `message`: User doesn't exist within `directus_users` |

### Invite User

Invite a new user to this instance. This will send an email to the user with further instructions

```http
POST /users/invite
```

#### Body

An email, or an array of emails to send invites to.

```json
{
    "email": "rijk@directus.io"
}
```

or

```
{
  "email": [
    "rijk@directus.io",
    "welling@directus.io",
    "ben@directus.io"
  ]
}
```

#### Common Responses

| Code                     | Description                              |
| ------------------------ | ---------------------------------------- |
| 200 OK                   | Emails successfully sent                 |
| 400 Bad Request          | `message`: Syntax error in provided JSON |
| 422 Unprocessable Entity | `message`: Email is invalid              |

### Track User

Set the time and last Directus App page accessed by the user. Last Access is used to determine if the user is still logged into the Directus app, and Last Page is used to avoid editing conflicts between multiple users.

```http
PATCH /users/[pk]/tracking/page
```

#### Body

The path to the last page the user was on in the Directus App

```json
{
    "last_page": "/tables/projects"
}
```

#### Common Responses

| Code                     | Description                              |
| ------------------------ | ---------------------------------------- |
| 200 OK                   | User successfully tracked                |
| 400 Bad Request          | `message`: Syntax error in provided JSON |
| 422 Unprocessable Entity | `message`: Field is invalid              |

## Utilities

### Hash String

Hashes the submitted string using the chosen algorithm

```http
POST /utils/hash
```

#### Body

The hashing algorithm to use and the string to hash

```json
{
    "hasher": "core|bcrypt|sha1|sha224|sha256|sha384|sha512",
    "string": "Directus"
}
```

#### Common Responses

| Code            | Description                              |
| --------------- | ---------------------------------------- |
| 200 OK          | `data`: The hashed string                |
| 400 Bad Request | `message`: Syntax error in provided JSON |

### Match Hashed String

Confirms encrypted hashes against the API

```http
POST /utils/hash/match
```

#### Body

The hashing algorithm to use and the string to hash

```json
{
    "hasher": "core|bcrypt|sha1|sha224|sha256|sha384|sha512",
    "string": "Directus",
    "hash": "c898896f3f70f61bc3fb19bef222aa860e5ea717"
}
```

#### Common Responses

| Code            | Description                                                                              |
| --------------- | ---------------------------------------------------------------------------------------- |
| 200 OK          | `data`: Boolean. Note that `false` (string does not match hash) is a successful response |
| 400 Bad Request | `message`: Syntax error in provided JSON                                                 |

### Get Random String

Gets a random alphanumeric string from the API

```http
GET /utils/random/string
```

| Name   | Default | Description                |
| ------ | ------- | -------------------------- |
| length | 32      | Length of string to return |

#### Common Responses

| Code            | Description                              |
| --------------- | ---------------------------------------- |
| 200 OK          | `data`: The random string                |
| 400 Bad Request | `message`: Syntax error in provided JSON |

## SCIM

Directus partly supports Version 2 of System for Cross-domain Identity Management, or SCIM. This open standard allows for users to be created, managed, and disabled outside of Directus so that enterprise clients have the ability to use a single, centralize system for user provisioning.

### Supported endpoints

| Endpoint     | Methods                 |
| ------------ | ----------------------- |
| /Users       | GET, POST               |
| /Users/{id}  | GET, PUT, PATCH         |
| /Groups      | GET, POST               |
| /Groups/{id} | GET, PUT, PATCH, DELETE |

Read more in the "SCIM Endpoints and HTTP Methods" section of  [RFC7644](https://tools.ietf.org/html/rfc7644#section-3.2).

### Get a list of users

```
GET /scim/v2/Users
```

#### Parameters
| Name       | Type        | Description 
| ---------- | ------------| ------------
| startIndex | `Integer`   | The 1-based index of the first result in the current set of list results.
| count      | `Integer`   | Specifies the desired maximum number of query results per page.
| filter     | `String`    | Only `eq` is supported

```
GET /scim/v2/Users?filter=userName eq user@example.com
```

#### Response

```json
{
  "schemas": [
    "urn:ietf:params:scim:api:messages:2.0:ListResponse"
  ],
  "totalResults": 3,
  "Resources": [
    {
      "schemas": [
        "urn:ietf:params:scim:schemas:core:2.0:User"
      ],
      "id": "789",
      "externalId": 1,
      "meta": {
          "resourceType": "User",
          "location": "http://example.com/_/scim/v2/Users/789",
          "version": "W/\"fb2c131da3a58d1f32800c3179cdfe50\""
      },
      "name": {
          "familyName": "User",
          "givenName": "Admin"
      },
      "userName": "admin@example.com",
      "emails": [
          {
              "value": "admin@example.com",
              "type": "work",
              "primary": true
          }
      ],
      "locale": "en-US",
      "timezone": "Europe/Berlin",
      "active": true
    },
    {
      "schemas": [
        "urn:ietf:params:scim:schemas:core:2.0:User"
      ],
      "id": "345",
      "externalId": 2,
      "meta": {
        "resourceType": "User",
        "location": "http://example.com/_/scim/v2/Users/345",
        "version": "W/\"68c210ea2la8isj2ba11d8b3b2982d\""
      },
      "name": {
        "familyName": "User",
        "givenName": "Intern"
      },
      "userName": "intern@example.com",
      "emails": [
        {
          "value": "intern@example.com",
          "type": "work",
          "primary": true
        }
      ],
      "locale": "en-US",
      "timezone": "America/New_York",
      "active": true
    },
    {
      "schemas": [
        "urn:ietf:params:scim:schemas:core:2.0:User"
      ],
      "id": "123",
      "externalId": 3,
      "meta": {
        "resourceType": "User",
        "location": "http://example.com/_/scim/v2/Users/123",
        "version": "W/\"20e4fasdf0jkdf9aa497f55598c8c883\""
      },
      "name": {
        "familyName": "User",
        "givenName": "Disabled"
      },
      "userName": "disabled@example.com",
      "emails": [
        {
          "value": "disabled@example.com",
          "type": "work",
          "primary": true
        }
      ],
      "locale": "en-US",
      "timezone": "America/New_York",
      "active": false
    }
  ]
}
```

### Get details for a single user

```
GET /scim/v2/Users/:id
```

#### Response:

```json
{
  "schemas": [
    "urn:ietf:params:scim:schemas:core:2.0:User"
  ],
  "id": "789",
  "externalId": 1,
  "meta": {
    "resourceType": "User",
    "location": "http://example.com/_/scim/v2/Users/789",
    "version": "W/\"fb2c131da3a58d1f32800c3179cdfe50\""
  },
  "name": {
    "familyName": "User",
    "givenName": "Admin"
  },
  "userName": "admin@example.com",
  "emails": [
    {
      "value": "admin@example.com",
      "type": "work",
      "primary": true
    }
  ],
  "locale": "en-US",
  "timezone": "Europe/Berlin",
  "active": true
}
```

### Creating an user

```
POST /scim/v2/Users
```

#### Body

```json
{
     "schemas":["urn:ietf:params:scim:schemas:core:2.0:User"],
     "userName":"johndoe@example.com",
     "externalId":"johndoe-id",
     "name":{
       "familyName":"Doe",
       "givenName":"John"
     }
   }
```

#### Response

```json
{
  "schemas": [
    "urn:ietf:params:scim:schemas:core:2.0:User"
  ],
  "id": "johndoe-id",
  "externalId": 4,
  "meta": {
    "resourceType": "User",
    "location": "http://example.com/_/scim/v2/Users/johndoe-id",
    "version": "W/\"fb2c131ad3a58d1f32800c1379cdfe50\""
  },
  "name": {
    "familyName": "Doe",
    "givenName": "John"
  },
  "userName": "johndoe@example.com",
  "emails": [
    {
      "value": "johndoe@example.com",
      "type": "work",
      "primary": true
    }
  ],
  "locale": "en-US",
  "timezone": "America/New_York",
  "active": false
}
```

### Update an user attributes

```
PATCH /scim/v2/Users/:id
```

#### Body
```json
{
     "schemas":["urn:ietf:params:scim:schemas:core:2.0:User"],
     "name":{
       "familyName":"Doe",
       "givenName":"Johnathan"
     }
   }
```

#### Response

```json
{
  "schemas": [
    "urn:ietf:params:scim:schemas:core:2.0:User"
  ],
  "id": "johndoe-id",
  "externalId": 4,
  "meta": {
    "resourceType": "User",
    "location": "http://example.com/_/scim/v2/Users/johndoe-id",
    "version": "W/\"fb2c131ad3a66d1f32800c1379cdfe50\""
  },
  "name": {
    "familyName": "Doe",
    "givenName": "Johnathan"
  },
  "userName": "johndoe@example.com",
  "emails": [
    {
      "value": "johndoe@example.com",
      "type": "work",
      "primary": true
    }
  ],
  "locale": "en-US",
  "timezone": "America/New_York",
  "active": false
}
```


### Get a list of groups

```
GET /scim/v2/Groups
```

#### Parameters
| Name       | Type        | Description 
| ---------- | ------------| ------------
| startIndex | `Integer`   | The 1-based index of the first result in the current set of list results.
| count      | `Integer`   | Specifies the desired maximum number of query results per page.
| filter     | `String`    | Only `eq` is supported

```
GET /scim/v2/Groups
```

#### Response

```json
{
  "schemas": [
    "urn:ietf:params:scim:api:messages:2.0:ListResponse"
  ],
  "totalResults": 3,
  "Resources": [
    {
      "schemas": [
        "urn:ietf:params:scim:schemas:core:2.0:Group"
      ],
      "id": "one",
      "externalId": 1,
      "meta": {
        "resourceType": "Group",
        "location": "http://example.com/_/scim/v2/Groups/one",
        "version": "W/\"7b7bc2512ee1fedcd76bdc68926d4f7b\""
      },
      "displayName": "Administrator",
      "members": [
        {
          "value": "admin@example.com",
          "$ref": "http://example.com/_/scim/v2/Users/789",
          "display": "Admin User"
        }
      ]
    },
    {
      "schemas": [
        "urn:ietf:params:scim:schemas:core:2.0:Group"
      ],
      "id": "two",
      "externalId": 2,
      "meta": {
        "resourceType": "Group",
        "location": "http://example.com/_/scim/v2/Groups/two",
        "version": "W/\"3d067bedfe2f4677470dd6ccf64d05ed\""
      },
      "displayName": "Public",
      "members": []
    },
    {
      "schemas": [
        "urn:ietf:params:scim:schemas:core:2.0:Group"
      ],
      "id": "three",
      "externalId": 3,
      "meta": {
        "resourceType": "Group",
        "location": "http://example.com/_/scim/v2/Groups/three",
        "version": "W/\"17ac93e56edd16cafa7b57979b959292\""
      },
      "displayName": "Intern",
      "members": [
        {
            "value": "intern@example.com",
            "$ref": "http://example.com/_/scim/v2/Users/345",
            "display": "Intern User"
        },
        {
            "value": "disabled@example.com",
            "$ref": "http://example.com/_/scim/v2/Users/123",
            "display": "Disabled User"
        }
      ]
    }
  ]
}
```

### Get details for a single user

```
GET /scim/v2/Groups/:id
```

#### Response:

```json
{
  "schemas": [
    "urn:ietf:params:scim:schemas:core:2.0:Group"
  ],
  "id": "one",
  "externalId": 1,
  "meta": {
    "resourceType": "Group",
    "location": "http://example.com/_/scim/v2/Groups/one",
    "version": "W/\"7b7bc2512ee1fedcd76bdc68926d4f7b\""
  },
  "displayName": "Administrator",
  "members": [
    {
      "value": "admin@example.com",
      "$ref": "http://example.com/_/scim/v2/Users/1",
      "display": "Admin User"
    }
  ]
}
```

### Creating an group

```
POST /scim/v2/Users
```

#### Body

```json
{
  "schemas":["urn:ietf:params:scim:schemas:core:2.0:Group"],
  "displayName":"Editors",
  "externalId":"editors-id"
}
```

#### Response

```json
{
  "schemas": [
    "urn:ietf:params:scim:schemas:core:2.0:Group"
  ],
  "id": "editors-id",
  "externalId": 4,
  "meta": {
    "resourceType": "Group",
    "location": "http://example.com/_/scim/v2/Groups/editors-id",
    "version": "W/\"7b7bc2512ee1fedcd76bdc68926d4f7b\""
  },
  "displayName": "Editors",
  "members": []
}
```

### Update an group attributes

```
PATCH /scim/v2/Groups/:id
```

#### Body
```json
{
  "schemas":["urn:ietf:params:scim:schemas:core:2.0:Group"],
  "displayName":"Writers"
}
```

#### Response

```json
{
  "schemas": [
    "urn:ietf:params:scim:schemas:core:2.0:Group"
  ],
  "id": "editors-id",
  "externalId": 4,
  "meta": {
    "resourceType": "Group",
    "location": "http://example.com/_/scim/v2/Groups/editors-id",
    "version": "W/\"7b7bc2512ee1fedcd76bdc68926d4f7b\""
  },
  "displayName": "Writers",
  "members": []
}
```

### Delete a group

```
DELETE /scim/v2/Groups/:id
```

#### Response

Empty response when successful.

## Extensions

Directus can easily be extended through the addition of several types of extensions. Extensions are important pieces of the Directus App that live in the decoupled Directus API. These include Interfaces, Listing Views, and Pages. These three different types of extensions live in their own directory and may have their own endpoints.

### Get Interfaces, List Views, Pages

These endpoints read the API's file system for directory names and return an array of extension names as well as the contents of each's `meta.json` files.

```http
GET /interfaces
GET /listviews
GET /pages
```

#### Common Responses

| Code   | Description                         |
| ------ | ----------------------------------- |
| 200 OK | `data`: An array of extension names |

<!--
::: tip
This is tip message
:::

::: warning
This is a warning
:::

::: danger
This is a danger Note
:::

::: danger STOP
This is danger note with a custom title
:::
-->